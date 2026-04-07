-- ============================================================
-- Greenie Teardown
-- Drops all app tables and functions in dependency order.
-- Run this in the Supabase SQL editor before re-running schema.sql.
-- WARNING: destroys all data.
-- ============================================================

drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();

drop table if exists scores         cascade;
drop table if exists matchups       cascade;
drop table if exists rounds         cascade;
drop table if exists team_members   cascade;
drop table if exists teams          cascade;
drop table if exists league_members cascade;
drop table if exists leagues        cascade;
drop table if exists holes          cascade;
drop table if exists courses        cascade;
drop table if exists profiles       cascade;
drop table if exists members        cascade;
