# Griffith Kart Club website

Website for Griffith Kart Club Inc., Tharbogang Raceway, est. 1975.

## What's here
- `index.html`: the whole site (one page, no build step)
- `assets/`: logo and favicon
- `supabase/migrations/`: database setup for the calendar and executive team

## Updating the site
**Calendar and executive team:** edit the rows in Supabase (Table Editor, `events` and `committee`). The site picks up changes on the next page load. If Supabase isn't connected, the site uses the built-in lists in the settings block near the bottom of `index.html`.

**Everything else:** edit `index.html` and commit.

## Connecting Supabase
Connected to project `obheiqzdzlxzrykijcro` (Griffith Kart Club org). `index.html` holds the **publishable** key only. Never put the secret key in this file. New tables or changes go in `supabase/migrations/` and deploy automatically on push to `main`.

## Hosting (GitHub Pages)
Settings > Pages > Source: Deploy from a branch > `main` / root. To use griffithkartclub.com.au, add it under Custom domain and point the domain's DNS at GitHub Pages.

## Live sources
- Facebook feed: facebook.com/griffithkarts
- Results: speedhive.mylaps.com/organizations/341676
- Calendar source: kansw.com.au/calendar
