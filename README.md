# script-toolbox

A collection of scripts and utilities for personal use.

This repo is primarily a personal toolbox, but may be useful to others.

---

## Structure

Scripts are organised by purpose rather than language:
```
script-toolbox/
├── soundcloud/
├── windows/
├── markdown/
```

- **soundcloud/** - Scripts related to interacting with Soundcloud
- **windows/** - Scripts relevant to windows specifically like hotkeys
- **markdown/** - Scripts relevant to markdown format like markdown to html converter

Some scripts may have multiple implementations in different languages, feel free to use any depending on your preference.

---

## Requirements

Depends on the script:

- PowerShell 7+
- Bash... well, just bash
- Latest python

Specific dependencies (e.g. `ffmpeg`, APIs, etc.) are documented in each script or in `/docs`.

---

## Usage

Run scripts directly. Examples:

```bash
# PowerShell
./soundcloud/download-soundcloud-playlist.ps1
```

Some scripts may require arguments, they may ask for it or they may require you pass it — check the header comments inside each file.

---

## Notes on AI Usage

Some scripts in this repository are:
- Partially generated using AI tools
- Written with AI assistance
- Or refined from AI-generated drafts

All scripts are reviewed and modified before being included, but they may not be perfect.
If you use anything here, review the code and adapt it to your needs.

---

## Disclaimer

These scripts are provided as-is, with no guarantees.
- They may modify files
- Use them at your own risk
- **Always review scripts before running them, especially on important systems.**

---

## Future plans
- Add more utilities as needed
- Improve documentations where necessary

---

## License

[MIT](LICENSE)
