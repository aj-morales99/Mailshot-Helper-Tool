# Cornerstone Mailshot Helper Tool — Developer Context

This file exists so Claude Code / any AI assistant can get up to speed without needing the original conversation history.

---

## What this app does

A desktop app for Cornerstone Project Source (construction/engineering recruitment) that:
1. Connects to Bullhorn CRM via OAuth2 and searches contacts using Lucene queries
2. Auto-filters contacts by job title seniority against a candidate's title
3. Pushes filtered contacts as leads into Instantly.ai email campaigns
4. Saves filtered contacts to Bullhorn Tearsheets / Hotlists
5. Exports filtered contacts as CSV

---

## Tech stack

- **Python 3.10+**
- **CustomTkinter** — dark UI with Cornerstone gold (#c9a96e) accent
- **Bullhorn CRM REST API** (EMEA region) — OAuth2 password grant, no browser/Selenium
- **Instantly.ai API v2** — campaign creation, lead import
- **PyInstaller** — packaged as macOS .app and Windows .exe via GitHub Actions

---

## File structure

```
Mailshot Helper Tool.py   ← entire app (single file)
config.json               ← credentials (never commit real values)
logo.png                  ← Cornerstone arch logo (gold, transparent bg)
CHANGELOG.md              ← version history
README.md                 ← user-facing docs
.github/workflows/
  release.yml             ← builds macOS + Windows on tag push, injects secrets
```

---

## Config file (config.json)

```json
{
  "bullhorn_client_id":     "...",
  "bullhorn_client_secret": "...",
  "bullhorn_username":      "...",
  "bullhorn_password":      "...",
  "bullhorn_redirect_uri":  "https://welcome.bullhornstaffing.com",
  "instantly_api_key":      "..."
}
```

Real credentials are stored as **GitHub Secrets** and injected at build time. The repo always has placeholder values.

---

## Bullhorn API notes

- **Auth URL**: `https://auth-emea.bullhornstaffing.com`
- **Login URL**: `https://rest-emea.bullhornstaffing.com`
- Token exchange uses `params=` (query string), NOT `data=` (POST body)
- REST login returns a dynamic `restUrl` — must use this for all subsequent calls
- Every request needs `BhRestToken` as a query parameter
- OAuth is pure `requests.Session()` — no Selenium, no browser

## Bullhorn fields used

```
id, firstName, lastName, occupation, email, phone, mobile, status,
customText1,          ← LinkedIn URL
customTextBlock2,     ← Custom County (location)
customTextBlock4,     ← Custom Industry
customTextBlock5,     ← Type of Work (Projects/Design/Commercial/Workshop)
clientCorporation(id, name, customTextBlock1)  ← customTextBlock1 = email domain stored as @domain.com
```

---

## Instantly API notes

- **Base URL**: `https://api.instantly.ai/api/v2`
- API key is base64-encoded, passed as Bearer token
- **Leads endpoint**: `POST /api/v2/leads/add` (NOT `/leads`)
- All three skip flags must be explicitly `false` to force-add duplicates
- Campaign creation fields: `name`, `campaign_schedule`, `email_list`, `email_tag_list`, `sequences`
- After creating a campaign, **PATCH it** to force-disable tracking:
  ```json
  { "stop_on_reply": false, "stop_on_auto_reply": false, "open_tracking": false, "link_tracking": false }
  ```
- Timezone enum uses `Europe/Isle_of_Man` for UK (NOT `Europe/London` — not in Instantly's enum)
- Account groups are fetched from `/custom-tags` — their UUIDs go in `email_tag_list`

---

## Job title hierarchy (Cornerstone industry tracks)

Based on Cornerstone's own introduction document. Four tracks:

### Projects
`MD → Contracts/Projects Director → Contracts Manager → Project Manager → Site Manager → Supervisor → Foreman → Operatives`

### Design
`Design Director → Design Manager → Lead Engineer → Senior Designer → Designer/Engineer → Junior Designer`

### Commercial
`Commercial Director → Commercial Manager → QS/Estimator/Buyer → Junior QS`

### Workshop
`Workshop Director → Workshop Manager → Workshop Supervisor → Operatives`

**Key rules:**
- Directors (`"director"` anywhere in title) → always KEEP
- Site managers, supervisors, construction managers, foremen → always REMOVE (on-site roles)
- HR roles → always KEEP (see HR_KEYWORDS list in code)
- **Senior prefix** raises effective level by 1: Senior QS (base level 2) → effective level 1 → kept when candidate is Commercial Manager
- **Junior/assistant/trainee prefix** lowers by 1
- Modifier words ignored for classification: "Senior Electrical Project Manager" → classifies as Project Manager
- Abbreviations normalised: PM→project manager, QS→quantity surveyor, CM→contracts manager, Snr/Sr→senior

---

## Per-company top-up logic

After running auto-filter against the candidate title:

1. Count "green" (keep) contacts per company
2. If fewer than the max (default 8, user-adjustable), top up from "red" contacts sorted by seniority
3. Top-up contacts get **orange** tag (`◈`)
4. If a contact has 3+ disciplines in `customTextBlock5` (Type of Work), they're flagged orange even if role is junior — they're likely a decision-maker

**Colour scheme:**
- 🟢 `☑` Green — normal keep
- 🟠 `◈` Orange — top-up or decision-maker (included but flagged)
- 🟡 `?` Yellow — uncertain job title
- 🔴 `☐` Red — excluded

---

## GitHub Actions release process

Tag format: `v1.0.0`, `v1.0.1` etc.

```bash
git add -A
git commit -m "describe changes"
git tag v1.0.2
git push && git push --tags
```

GitHub builds macOS (.app) and Windows (.exe) automatically (~8 mins). The `config.json` in the built app has real credentials injected from GitHub Secrets.

**Download links (always latest):**
- macOS: `https://github.com/aj-morales99/Mailshot-Helper-Tool/releases/latest/download/Mailshot-Helper-Tool-macOS.zip`
- Windows: `https://github.com/aj-morales99/Mailshot-Helper-Tool/releases/latest/download/Mailshot-Helper-Tool-Windows.zip`

---

## Known platform differences

- **macOS**: fade-in animations, slide-up popups, dim overlay, dock icon via NSApp
- **Windows**: all animations disabled (cause flickering), instant transitions
- `IS_WINDOWS` and `IS_MAC` flags set at startup control all platform-specific behaviour
- Popups use `withdraw()` before positioning to prevent flash at wrong location

---

## UI framework notes

- `ctk.CTkButton`, `ctk.CTkEntry`, `ctk.CTkComboBox`, `ctk.CTkCheckBox` — all use `configure()` not `config()`
- CTK colour params: `fg_color`, `hover_color`, `text_color`, `border_color` (NOT `bg`, `fg`)
- Regular `tk.Label`, `tk.Text`, `tk.Listbox` still use `config()` with `bg`/`fg`
- App inherits from `ctk.CTk`, popups from `tk.Toplevel`
- Icon set via `after(50, ...)` to run AFTER CTk's own icon setup overwrites it

---

## Current version

**v1.0.1** (released) — see CHANGELOG.md

**Unreleased changes (in working file):**
- Senior prefix level-raising in hierarchy comparison
- HR keywords expanded (Group HR, L&D, People & Culture, etc.)
- Per-company top-up with orange tagging
- Decision-maker detection (3+ disciplines = orange)
