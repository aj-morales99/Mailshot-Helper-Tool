# Cornerstone Mailshot Tool

A desktop application for filtering Bullhorn CRM contacts and pushing them directly into Instantly.ai email campaigns.

---

## What it does

- **Search and filter** contacts from Bullhorn CRM using multiple criteria — company, email, status, county, industry, type of work, and more
- **Auto-filter by job title** — enter a candidate's title and the tool automatically classifies contacts as keep, exclude, or uncertain based on seniority hierarchy
- **Push to Instantly** — create a new Instantly.ai campaign and import filtered contacts as leads in one step
- **Save to Bullhorn** — export filtered contacts to a Tearsheet or Hotlist directly in Bullhorn
- **Export CSV** — download filtered contacts as a spreadsheet

---

## Requirements

- Python 3.10 or later
- macOS or Windows

---

## Installation

```bash
pip install customtkinter requests pillow
```

---

## Running the app

```bash
python3 AllInOneTool.py
```

---

## Configuration

Open `config.json` in any text editor and fill in your credentials:

```json
{
  "bullhorn_client_id":     "your-client-id",
  "bullhorn_client_secret": "your-client-secret",
  "bullhorn_username":      "your-api-username",
  "bullhorn_password":      "your-api-password",
  "instantly_api_key":      "your-instantly-api-key"
}
```

Save the file and restart the app. No rebuild needed.

---

## Adding your logo

Drop a PNG file named `logo.png` in the same folder as `AllInOneTool.py`. The app will use it automatically.

---

## Building a standalone app

**macOS:**
```bash
chmod +x build_app.sh
./build_app.sh
```
Output: `dist/Cornerstone Mailshot.app`

**Windows:**
```
build_app_windows.bat
```
Output: `dist\Cornerstone Mailshot\` — share the entire folder as a zip.

---

## Releases

Pre-built downloads for macOS and Windows are available on the [Releases](../../releases) page.
