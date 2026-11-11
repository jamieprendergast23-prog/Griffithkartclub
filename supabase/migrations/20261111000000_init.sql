-- Griffith Kart Club website: calendar and committee
-- Public can read published rows only. Writes need a signed-in committee login
-- (or the Supabase dashboard / Table Editor).

create table public.events (
  id            bigint generated always as identity primary key,
  start_date    date not null,
  end_date      date,
  name          text not null,
  venue         text not null default 'Griffith Kart Club',
  event_type    text not null default 'home' check (event_type in ('home','state','nat')),
  results_url   text,
  supp_regs_url text,
  published     boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  constraint events_dates_ok check (end_date is null or end_date >= start_date)
);
create index events_start_date_idx on public.events (start_date);

create table public.committee (
  id            bigint generated always as identity primary key,
  role          text not null,
  name          text not null,
  is_executive  boolean not null default false,
  sort_order    int not null default 100,
  term          text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create or replace function public.set_updated_at() returns trigger
language plpgsql set search_path = '' as $$
begin new.updated_at = now(); return new; end $$;

create trigger events_updated_at before update on public.events
  for each row execute function public.set_updated_at();
create trigger committee_updated_at before update on public.committee
  for each row execute function public.set_updated_at();

alter table public.events enable row level security;
alter table public.committee enable row level security;

create policy "Public can read published events" on public.events
  for select to anon, authenticated using (published);
create policy "Public can read executive" on public.committee
  for select to anon, authenticated using (is_executive);
create policy "Signed-in committee can manage events" on public.events
  for all to authenticated using (true) with check (true);
create policy "Signed-in committee can manage committee" on public.committee
  for all to authenticated using (true) with check (true);

-- Seed: 2026 season (KA NSW calendar) and executive (AGM 18 March 2026)
insert into public.events (start_date, end_date, name, venue, event_type, results_url, supp_regs_url) values
 ('2026-02-28','2026-02-28','Hot Summer Night, Club Championship Rd 1','Griffith Kart Club','home','https://speedhive.mylaps.com/organizations/341676',null),
 ('2026-03-13','2026-03-15','Penrite Australian Kart Championship Rd 1','Coffs Harbour','nat',null,null),
 ('2026-04-17','2026-04-19','Joseph Bianchini Memorial & Riverina Cup','Griffith Kart Club','home','https://speedhive.mylaps.com/events/3465885',null),
 ('2026-07-10','2026-07-12','Brad Jones Challenge','Griffith Kart Club','home','https://speedhive.mylaps.com/events/3602841',null),
 ('2026-09-18','2026-09-19','Retro Karting NSW Titles (Oceania Series Rd 4)','Griffith Kart Club','home',null,null),
 ('2026-10-02','2026-10-04','KA NSW State Championship','Eastern Creek','state',null,null),
 ('2026-10-10','2026-10-10','Club Championship Meeting','Griffith Kart Club','home',null,null),
 ('2026-10-31','2026-11-01','Ultimate Club Racer VI','Lismore','nat',null,null),
 ('2026-11-28','2026-11-28','Christmas Club Meeting','Griffith Kart Club','home',null,'https://www.kansw.com.au/calendar/');

insert into public.committee (role, name, is_executive, sort_order, term) values
 ('President','Sam Belardo',true,1,'2026-27'),
 ('Vice President','Adrian Bianchini',true,2,'2026-27'),
 ('Secretary','Jamie Griffiths',true,3,'2026-27'),
 ('Treasurer','Jamie Prendergast',true,4,'2026-27'),
 ('Child Safety Officer / MPIO','Peter Prendergast',false,10,'2026-27');
