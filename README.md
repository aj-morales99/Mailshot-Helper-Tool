# Cornerstone Mailshot Tool

## Files in this folder

| File | Purpose |
|---|---|
| `AllInOneTool.py` | Main application |
| `config.json` | All API keys and credentials — edit here |
| `logo.png` | **Drop your company logo here** (any size, PNG with transparency) |
| `build_app.sh` | One-command macOS .app builder |

---

## Quick start (run from source)

```bash
# 1. Install dependencies (once)
pip3 install customtkinter requests pillow

# 2. Run the app
python3 AllInOneTool.py
```

---

## Adding your company logo

1. Export your logo as a **PNG with transparent background**, any square size (256×256 or larger recommended)
2. Name it exactly **`logo.png`**
3. Drop it in the **same folder as `AllInOneTool.py`**
4. Restart the app — it will appear in the title bar, taskbar/dock, and header

> The app ships with a placeholder green "C" logo. It is automatically replaced when `logo.png` is present.

---

## Updating API keys / credentials

Open `config.json` in any text editor:

```json
{
  "bullhorn_client_id":     "your-client-id",
  "bullhorn_client_secret": "your-client-secret",
  "bullhorn_username":      "your-api-username",
  "bullhorn_password":      "your-api-password",
  "instantly_api_key":      "your-instantly-key"
}
```

Save and **restart the app**. No rebuild needed.

> If `config.json` is missing, the app falls back to the hardcoded defaults in the script.

---

## Building a standalone macOS .app

```bash
# Make the build script executable (once)
chmod +x build_app.sh

# Build
./build_app.sh
```

This will:
1. Install PyInstaller + dependencies if missing
2. Convert `logo.png` → `logo.icns` for the macOS dock icon
3. Bundle everything into `dist/Cornerstone Mailshot.app`
4. Copy `config.json` next to the `.app` so you can edit keys without rebuilding

**Distribute the entire `dist/` folder.** The `config.json` next to the `.app` takes priority over the embedded one.

### Manual PyInstaller command (if you prefer)

```bash
pyinstaller \
  --noconfirm \
  --windowed \
  --name "Cornerstone Mailshot" \
  --icon logo.icns \
  --add-data "config.json:." \
  --add-data "logo.png:." \
  --hidden-import customtkinter \
  --collect-all customtkinter \
  AllInOneTool.py
```

---

## Config reference

| Key | What it's for |
|---|---|
| `bullhorn_client_id` | Bullhorn OAuth2 client ID |
| `bullhorn_client_secret` | Bullhorn OAuth2 client secret |
| `bullhorn_username` | Bullhorn API username |
| `bullhorn_password` | Bullhorn API password |
| `bullhorn_redirect_uri` | OAuth2 redirect (usually leave as-is) |
| `instantly_api_key` | Instantly v2 API key (base64-encoded) |

---

## Windows — avoiding the virus popup

### Why it happens
Windows SmartScreen and antivirus software flag PyInstaller `.exe` files by default — not because the app is harmful, but because PyInstaller bundles are commonly used by malware. **Your app is not a virus.** This is a false positive.

### Option 1 — No certificate (internal use only)
Build with `build_app_windows.bat`. Recipients will see a SmartScreen popup saying "Windows protected your PC". They click **"More info" → "Run anyway"** — one time, then it's trusted.

To minimise how often this happens:
- Distribute as a **zip file**, not a bare `.exe` — browsers flag unsigned `.exe` downloads more aggressively than zips
- Use `--onedir` (folder) instead of `--onefile` — single-file executables are more suspicious to AV
- The build script already uses `--noupx` to disable UPX compression, which is a major false-positive trigger

### Option 2 — OV Code Signing Certificate (~£60–150/yr)
Reduces SmartScreen warnings after your app builds enough "reputation" (downloads). Doesn't eliminate SmartScreen immediately but it does disappear over time.

Providers: Sectigo, Comodo, Certum

### Option 3 — EV Code Signing Certificate (~£200–400/yr) ✅ Recommended for distribution
**Immediately trusted** by SmartScreen and most AV software. No popup at all.
Requires business identity verification (takes 2–5 days).

Providers: **DigiCert**, **Sectigo EV**, **GlobalSign**

To sign after building:
```cmd
signtool sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 /a "dist\Cornerstone Mailshot\Cornerstone Mailshot.exe"
```

### Option 4 — Submit to Microsoft for analysis (free, takes 1–3 days)
Submit the `.exe` to https://www.microsoft.com/en-us/wdsi/filesubmission
Microsoft reviews it and adds it to the trusted list. Only works for your specific build — resubmit after each new version.

---

## Building for Windows

```cmd
# Run from the folder containing AllInOneTool.py
build_app_windows.bat
```

Output: `dist\Cornerstone Mailshot\` — zip this entire folder to share.

## Building for macOS

```bash
chmod +x build_app.sh && ./build_app.sh
```

Output: `dist/Cornerstone Mailshot.app`

> For macOS: install `pip3 install pyobjc-framework-Cocoa` for the proper dock icon (removes the Python rocket).
