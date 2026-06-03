## [v1.0.7] — 2026-06-03
- Fixed missing get_values() method accidentally removed in previous edit
- Stop on reply, open tracking, link tracking all default to disabled in Instantly
- Company filter now defaults to Exclude instead of Include Any
- Company Email Domain query now uses correct @domain.com format matching Bullhorn storage
- Inline filter clauses now use lowercase matching for better Bullhorn Lucene compatibility

# Changelog

## [v1.0.5] — 2026-06-02
- Fixed app icon showing as blue square inside the app — now correctly shows Cornerstone gold arches
- Renamed GitHub repository to Mailshot-Helper-Tool

## [v1.0.4] — 2026-06-02
- Fixed UI flicker when adding/removing filter chips
- Fixed filter row jumping when switching between same field types
- Fixed results list flashing on search — now batches all inserts at once

## [v1.0.3] — 2026-06-02
- Fixed all popups flashing in wrong position (top-right) before snapping to centre
- Fixed filter dropdowns briefly appearing at top-left corner of window
- All popups now open directly at correct position on both macOS and Windows

## [v1.0.2] — 2026-06-02
- Fixed animations causing flickering and weird movements on Windows
- macOS retains smooth fade-in and slide-up animations
- Windows now uses clean instant transitions with no movement artefacts
- Dropdowns appear instantly on Windows with no slide animation

## [v1.0.1] — 2026-06-02
- Removed Selenium dependency — no longer requires Chrome or ChromeDriver to connect
- Connection now uses a direct requests-based OAuth flow that works inside packaged apps
- Credentials are now baked into the built app via GitHub Secrets — no config.json sharing needed

## [v1.0.0] — 2026-06-02
### Initial release
- Bullhorn CRM contact search with Lucene query builder
- 8 default filters: Company, Work Email, Company Email Domain, Status, Email Status, Custom Industry, Custom County, Custom Type of Work
- Auto-filter by job title hierarchy across Projects, Design, Commercial and Workshop tracks
- Job title normalisation: handles abbreviations (PM, QS, CM), slash variants, modifiers (senior electrical project manager → project manager)
- Directors always kept, site managers/supervisors always excluded
- Instantly.ai campaign creation and lead import with full field mapping
- Bullhorn Tearsheet / Hotlist export with duplicate name check
- CSV export
- CustomTkinter UI with Cornerstone brand colours and logo
- Fade-in popup animations on macOS, instant transitions on Windows
- GitHub Actions automated builds for macOS and Windows on every release tag
