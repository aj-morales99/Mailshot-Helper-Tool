# Changelog

All notable changes to the Cornerstone Mailshot Tool are documented here.

## [v1.0.0] — 2026-06-02

### Initial release

**Core features**
- Bullhorn CRM contact search with Lucene query builder
- 8 default filter rows: Company, Work Email, Company Email Domain, Status, Email Status, Custom Industry, Custom County, Custom Type of Work
- Auto-filter by job title hierarchy (Projects / Design / Commercial / Workshop tracks)
- Results tree with keep/exclude/uncertain (green/red/yellow) classification

**Instantly.ai integration**
- Push filtered contacts as leads to a new Instantly campaign
- Full campaign creation: schedule, timezone, sending accounts/groups, delivery optimisation
- Force-add leads regardless of duplicates (skip_if_* all false)
- Animated popup with fade-in/slide-up and dim overlay

**Bullhorn Tearsheet / Hotlist**
- Save filtered contacts to a new Tearsheet
- Optional note logging on each contact profile
- Duplicate name pre-check before saving

**Export**
- CSV export with all contact fields

**UI**
- CustomTkinter dark theme with Cornerstone gold (#c9a96e) accent
- Cornerstone Project Source logo embedded (arch icon)
- Rounded inputs, pill buttons, animated popups
- Fade-in animations on all dialogs

**Job title hierarchy rules**
- Directors always kept
- Site manager / supervisor / construction manager always excluded
- "Senior X" keeps same-level and above
- Modifier words (electrical, mechanical, civil, site) ignored — root keyword used
- Abbreviations normalised: PM → project manager, QS → quantity surveyor, etc.

**Configuration**
- `config.json` for all API keys and credentials — edit without touching code

**Build**
- `build_app.sh` — macOS .app builder
- `build_app_windows.bat` — Windows .exe builder
- GitHub Actions workflow for automated cross-platform releases
