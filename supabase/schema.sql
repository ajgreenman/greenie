-- ============================================================
-- Greenie Schema
-- Run this in the Supabase SQL editor (Project > SQL Editor).
-- Safe to re-run: uses CREATE TABLE IF NOT EXISTS throughout.
-- ============================================================

-- ============================================================
-- TABLES
-- ============================================================

-- Members: golf participants. A member may or may not have an
-- app account (profiles row). Admins can add members manually.
create table if not exists members (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  handicap   integer not null default 0,
  created_at timestamptz not null default now()
);

-- Profiles: one row per authenticated user (auth.users).
-- Links the Supabase identity to a league member.
-- member_id is nullable — a new user has no member yet.
create table if not exists profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  member_id  uuid references members(id) on delete set null,
  name       text not null,
  email      text not null,
  created_at timestamptz not null default now()
);

-- Courses
create table if not exists courses (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  created_at timestamptz not null default now()
);

-- Holes: child of courses. (course_id, number) must be unique.
create table if not exists holes (
  id        uuid primary key default gen_random_uuid(),
  course_id uuid not null references courses(id) on delete cascade,
  number    integer not null,
  par       integer not null,
  unique(course_id, number)
);

-- Leagues
create table if not exists leagues (
  id              uuid primary key default gen_random_uuid(),
  name            text not null,
  course_id       uuid not null references courses(id),
  day             text not null, -- matches DayOfTheWeek enum: 'monday'..'sunday'
  admin_member_id uuid references members(id) on delete set null,
  created_at      timestamptz not null default now()
);

-- League members (junction)
create table if not exists league_members (
  league_id uuid not null references leagues(id) on delete cascade,
  member_id uuid not null references members(id) on delete cascade,
  primary key (league_id, member_id)
);

-- Teams: belong to a league, exactly 2 members (enforced at app layer)
create table if not exists teams (
  id        uuid primary key default gen_random_uuid(),
  league_id uuid not null references leagues(id) on delete cascade,
  name      text not null
);

-- Team members (junction)
create table if not exists team_members (
  team_id   uuid not null references teams(id) on delete cascade,
  member_id uuid not null references members(id) on delete cascade,
  primary key (team_id, member_id)
);

-- Rounds
create table if not exists rounds (
  id             uuid primary key default gen_random_uuid(),
  league_id      uuid not null references leagues(id) on delete cascade,
  course_id      uuid not null references courses(id),
  date           date not null,
  status         text not null default 'upcoming', -- 'upcoming' | 'inProgress' | 'completed'
  hole_numbers   integer[] not null default '{}',  -- e.g. {1,2,3,4,5,6,7,8,9}
  start_time     timestamptz,
  team_tee_times jsonb,  -- {"<teamId>": "2025-07-06T17:30:00Z", ...}
  created_at     timestamptz not null default now()
);

-- Matchups: two teams competing within a round
create table if not exists matchups (
  id       uuid primary key default gen_random_uuid(),
  round_id uuid not null references rounds(id) on delete cascade,
  team1_id uuid not null references teams(id),
  team2_id uuid not null references teams(id)
);

-- Scores: one row per member per round.
-- hole_scores is a jsonb map of hole number → strokes, e.g. {"1": 4, "2": 3}.
-- JSON keys are always strings; the app parses them back to int.
create table if not exists scores (
  id          uuid primary key default gen_random_uuid(),
  round_id    uuid not null references rounds(id) on delete cascade,
  member_id   uuid not null references members(id),
  hole_scores jsonb not null default '{}',
  unique(round_id, member_id)
);


-- ============================================================
-- INDEXES
-- ============================================================

create index if not exists holes_course_id_idx       on holes(course_id);
create index if not exists league_members_league_idx  on league_members(league_id);
create index if not exists league_members_member_idx  on league_members(member_id);
create index if not exists team_members_team_idx      on team_members(team_id);
create index if not exists teams_league_id_idx        on teams(league_id);
create index if not exists rounds_league_id_idx       on rounds(league_id);
create index if not exists matchups_round_id_idx      on matchups(round_id);
create index if not exists scores_round_id_idx        on scores(round_id);
create index if not exists scores_member_id_idx       on scores(member_id);


-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

alter table members        enable row level security;
alter table profiles       enable row level security;
alter table courses        enable row level security;
alter table holes          enable row level security;
alter table leagues        enable row level security;
alter table league_members enable row level security;
alter table teams          enable row level security;
alter table team_members   enable row level security;
alter table rounds         enable row level security;
alter table matchups       enable row level security;
alter table scores         enable row level security;

-- Authenticated users can read everything
create policy "authenticated read members"        on members        for select using (auth.role() = 'authenticated');
create policy "authenticated read courses"        on courses        for select using (auth.role() = 'authenticated');
create policy "authenticated read holes"          on holes          for select using (auth.role() = 'authenticated');
create policy "authenticated read leagues"        on leagues        for select using (auth.role() = 'authenticated');
create policy "authenticated read league_members" on league_members for select using (auth.role() = 'authenticated');
create policy "authenticated read teams"          on teams          for select using (auth.role() = 'authenticated');
create policy "authenticated read team_members"   on team_members   for select using (auth.role() = 'authenticated');
create policy "authenticated read rounds"         on rounds         for select using (auth.role() = 'authenticated');
create policy "authenticated read matchups"       on matchups       for select using (auth.role() = 'authenticated');
create policy "authenticated read scores"         on scores         for select using (auth.role() = 'authenticated');

-- Profiles: users can read all, but only write their own
create policy "authenticated read profiles" on profiles for select using (auth.role() = 'authenticated');
create policy "users insert own profile"    on profiles for insert with check (auth.uid() = id);
create policy "users update own profile"    on profiles for update using (auth.uid() = id);

-- Scores: authenticated users can insert/update their own member's score.
-- We join through profiles to resolve auth.uid() → member_id.
create policy "members insert own score" on scores for insert
  with check (
    member_id = (select member_id from profiles where id = auth.uid())
  );

create policy "members update own score" on scores for update
  using (
    member_id = (select member_id from profiles where id = auth.uid())
  );


-- ============================================================
-- AUTO-CREATE PROFILE ON SIGN-UP
-- Trigger fires after a new auth.users row is inserted.
-- Creates a profile with name/email pulled from auth metadata.
-- ============================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
    new.email
  );
  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
