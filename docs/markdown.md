# Markdown Tools

Scripts for working with Markdown files

---

## markdown_to_html.py

### What it does
Converts a Markdown file into HTML.

Supports two modes:
- **Custom parser (default)**  
  - Headings (#, ##, ###)  
  - Bold (**text**)  
  - Italic (*text*)  
- **Full parser (`--full`)**  
  - Uses the `markdown` library  
  - Supports extended features (e.g. tables)

It also does:
- Wraps output in a basic HTML template
- Allows custom output file path
- Simple CLI interface via argparse

---

## Requirements
- Python 3.10+
- `markdown` library (only if using `--full` mode):

```
pip install markdown
```

---

## Usage

```bash
python markdown-to-html.py input.md
```

Optional flags:

```bash
python markdown_to_html.py input.md --output output.html
python markdown_to_html.py input.md --full
```

---

## Output:
- `output.html` (default) → rendered HTML file

---

## Notes:
- Custom parser is intentionally simple and does not fully support Markdown spec
- Regex-based parsing may fail on complex or nested formatting
- --full mode is recommended for more accurate results
- Script was written with AI assistance, and reviewed manually
