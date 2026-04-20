# SoundCloud Tools

Scripts for interacting with SoundCloud

---

## download-soundcloud-playlist.ps1

### What it does
Downloads all tracks from a SoundCloud playlist and saves them as MP3 files.

It also does:
- Embeds metadata + thumbnails
- Prevents duplicate downloads (archive file)
- Generates a log file per run
- Auto-downloads `yt-dlp` if missing

---

## Requirements
- PowerShell 7
- ffmpeg installed in PATH
- Internet connection (duh)

---

## Usage

```powershell
.\download-soundcloud-playlist.ps1
```

You will be prompted for a playlist URL.

---

## Output:
- `downloads/<playlist_name>/` → MP3 files
- `archive.txt` → prevents re-downloading tracks
- `<playlist_name>.log` → download log

---

## Notes:
- Playlist name detection is not always accurate
- Some tracks may fail depending on availability
- Script was written with AI assistance, and reviewed manually
