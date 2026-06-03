# Changelog

## [v1.0.0] — 2026-06-03

### Initial release

**Search & Filters**
- Bullhorn CRM contact search with Lucene query builder
- 8 default filters: Company (Exclude), Work Email, Company Email Domain, Status, Email Status, Custom Industry, Custom County, Custom Type of Work
- Company Email Domain uses plain text entry — type a domain (e.g. `severfield.com`) and it builds `NOT clientCorporation.customTextBlock1:(@severfield.com)` in the query
- Live company search with debounce and stale-result guard
- Multi-select chips with stable widget pool (no flicker)

**Auto-filter by job title**
- Hierarchy tracks: Projects, Design, Commercial, Workshop
- Directors always kept; site managers/supervisors/construction managers always excluded
- Senior prefix handled: "Senior X" beats plain "X"
- Modifier words ignored: "Senior Electrical Project Manager" → classifies as Project Manager
- Abbreviations normalised: PM, QS, CM, Snr, Sr etc.

**Instantly.ai integration**
- Create campaign with schedule, timezone, sending accounts/groups, daily limit
- Stop on reply, open tracking, link tracking all default to disabled
- Delivery optimisation checkboxes (text-only, first email text-only)
- Force-add leads regardless of duplicates
- Full field mapping: name, email, job title, company, phone, LinkedIn, location

**Bullhorn Tearsheet / Hotlist**
- Save filtered contacts to a new Tearsheet with duplicate name pre-check
- Optional note logging on each contact profile

**Export**
- CSV export of filtered contacts

**UI**
- CustomTkinter dark theme with Cornerstone brand gold (#c9a96e)
- Cornerstone arch logo embedded — shows in titlebar, taskbar/dock
- Rounded inputs and pill buttons on all controls
- Popups open centered with no flash (withdraw before positioning)
- macOS: fade-in + slide-up animations; Windows: instant clean transitions

**Build & Distribution**
- GitHub Actions automated builds for macOS (.app) and Windows (.exe)
- Credentials injected via GitHub Secrets at build time — not stored in code
- Windows zip includes desktop shortcut + HOW TO INSTALL.txt
