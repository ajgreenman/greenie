-- ============================================================
-- Greenie Schema
-- Run this in the Supabase SQL editor (Project > SQL Editor).
-- Safe to re-run: uses CREATE TABLE IF NOT EXISTS throughout.
-- ============================================================

-- ============================================================
-- TABLES
-- ============================================================

-- Profiles: one row per authenticated user (auth.users).
-- handicap is global; leagues can override it per-member via
-- league_members.handicap_override.
create table if not exists profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  name       text not null,
  email      text not null,
  handicap   integer not null default 0,
  created_at timestamptz not null default now()
);

-- Courses
create table if not exists courses (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  rating     numeric(4,1),  -- course rating from white/middle tees (e.g. 66.1)
  slope      integer,       -- slope rating from white/middle tees (e.g. 116)
  created_at timestamptz not null default now()
);

-- Holes: child of courses. (course_id, number) must be unique.
create table if not exists holes (
  id             uuid primary key default gen_random_uuid(),
  course_id      uuid not null references courses(id) on delete cascade,
  number         integer not null,
  par            integer not null,
  yardage        integer not null,        -- white/middle tee yardage
  handicap_index integer not null,        -- stroke index 1–18
  unique(course_id, number)
);

-- Leagues
create table if not exists leagues (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  course_id     uuid not null references courses(id),
  day           text not null, -- matches DayOfTheWeek enum: 'monday'..'sunday'
  admin_user_id uuid references profiles(id) on delete set null,
  created_at    timestamptz not null default now()
);

-- League members (junction).
-- handicap_override is null when the league uses the player's global handicap.
-- A league admin can set it to override for their specific league.
create table if not exists league_members (
  league_id         uuid not null references leagues(id) on delete cascade,
  user_id           uuid not null references profiles(id) on delete cascade,
  handicap_override integer,
  primary key (league_id, user_id)
);

-- Teams: belong to a league, exactly 2 members (enforced at app layer)
create table if not exists teams (
  id        uuid primary key default gen_random_uuid(),
  league_id uuid not null references leagues(id) on delete cascade,
  name      text not null
);

-- Team members (junction)
create table if not exists team_members (
  team_id uuid not null references teams(id) on delete cascade,
  user_id uuid not null references profiles(id) on delete cascade,
  primary key (team_id, user_id)
);

-- Rounds
create table if not exists rounds (
  id           uuid primary key default gen_random_uuid(),
  league_id    uuid not null references leagues(id) on delete cascade,
  course_id    uuid not null references courses(id),
  date         date not null,
  status       text not null default 'upcoming', -- 'upcoming' | 'inProgress' | 'completed'
  hole_numbers integer[] not null default '{}',  -- e.g. {1,2,3,4,5,6,7,8,9}
  start_time   timestamptz,
  team_tee_times jsonb,  -- {"<teamId>": "2025-07-06T17:30:00Z", ...}
  created_at   timestamptz not null default now()
);

-- Matchups: two teams competing within a round
create table if not exists matchups (
  id       uuid primary key default gen_random_uuid(),
  round_id uuid not null references rounds(id) on delete cascade,
  team1_id uuid not null references teams(id),
  team2_id uuid not null references teams(id)
);

-- Scores: one row per user per round.
-- hole_scores is a jsonb map of hole number → strokes, e.g. {"1": 4, "2": 3}.
-- JSON keys are always strings; the app parses them back to int.
create table if not exists scores (
  id          uuid primary key default gen_random_uuid(),
  round_id    uuid not null references rounds(id) on delete cascade,
  user_id     uuid not null references profiles(id),
  hole_scores jsonb not null default '{}',
  unique(round_id, user_id)
);


-- ============================================================
-- INDEXES
-- ============================================================

create index if not exists holes_course_id_idx        on holes(course_id);
create index if not exists league_members_league_idx  on league_members(league_id);
create index if not exists league_members_user_idx    on league_members(user_id);
create index if not exists team_members_team_idx      on team_members(team_id);
create index if not exists teams_league_id_idx        on teams(league_id);
create index if not exists rounds_league_id_idx       on rounds(league_id);
create index if not exists matchups_round_id_idx      on matchups(round_id);
create index if not exists scores_round_id_idx        on scores(round_id);
create index if not exists scores_user_id_idx         on scores(user_id);


-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

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
create policy "authenticated read profiles"       on profiles       for select using (auth.role() = 'authenticated');
create policy "authenticated read courses"        on courses        for select using (auth.role() = 'authenticated');
create policy "authenticated read holes"          on holes          for select using (auth.role() = 'authenticated');
create policy "authenticated read leagues"        on leagues        for select using (auth.role() = 'authenticated');
create policy "authenticated read league_members" on league_members for select using (auth.role() = 'authenticated');
create policy "authenticated read teams"          on teams          for select using (auth.role() = 'authenticated');
create policy "authenticated read team_members"   on team_members   for select using (auth.role() = 'authenticated');
create policy "authenticated read rounds"         on rounds         for select using (auth.role() = 'authenticated');
create policy "authenticated read matchups"       on matchups       for select using (auth.role() = 'authenticated');
create policy "authenticated read scores"         on scores         for select using (auth.role() = 'authenticated');

-- Profiles: users can only write their own row
create policy "users insert own profile" on profiles for insert with check (auth.uid() = id);
create policy "users update own profile" on profiles for update using (auth.uid() = id);

-- Scores: users can only insert/update their own score
create policy "users insert own score" on scores for insert
  with check (user_id = auth.uid());

create policy "users update own score" on scores for update
  using (user_id = auth.uid());


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
