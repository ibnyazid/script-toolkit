# Windows Utilities

Small scripts for Windows automation (hotkeys, window control, system tweaks).

---

## minimize-edge-windows.ps1

### What it does
Minimizes all open Microsoft Edge windows.

It works by:
- Finding running `msedge` processes
- Getting their window handles
- Calling the Windows API to minimize them

---

## Requirements
- Windows OS
- Microsoft Edge installed
- PowerShell 5.1+ (or 7+)

---

## Usage

```powershell
.\minimize-edge-windows.ps1
```

---

## Notes
- Only affects visible Edge windows (not background processes)
- Some special Edge windows may not be minimized
- Uses Windows API (user32.dll) for window control
- Script was written with AI assistance and manually reviewed
