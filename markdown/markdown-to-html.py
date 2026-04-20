"""
SYNOPSIS
    Convert a Markdown file into HTML using either a custom parser or the markdown library.

DESCRIPTION
    This script reads a Markdown (.md) file and converts it into HTML.

    It supports two modes:
    1. Custom lightweight parser (default)
       - Supports headings (#, ##, ###)
       - Supports bold (**text**)
       - Supports italic (*text*)
       - Wraps output in a basic HTML template

    2. Full parser (--full flag)
       - Uses the external 'markdown' library
       - Supports extended Markdown features (e.g. tables)

    The output is written to an HTML file.

PARAMETERS
    markdown_path
        Path to the input Markdown file.

    --output
        Output file path (default: output.html)

    --full
        Use the full markdown parser instead of the custom implementation.

EXAMPLES
    Basic usage (custom parser):
        python script.py input.md

    Specify output file:
        python script.py input.md --output result.html

    Use full markdown parser:
        python script.py input.md --full

OUTPUTS
    - HTML file written to the specified output path.

INPUTS
    - Markdown file provided via command-line argument.

REQUIREMENTS
    - Python 3.10+ (for type hints like str | None)
    - 'markdown' library (only required if using --full mode):
        pip install markdown

NOTES
    - The custom parser is intentionally simple and does not fully support
      the Markdown specification.
    - Inline parsing is handled via regular expressions and may not correctly
      handle complex nested formatting.
    - Some parts of this script were generated or assisted by AI tools.
"""
import argparse
import re
from pathlib import Path

def convert_heading(line: str) -> str:
    match = re.match(r"^(#{1,3}) (.*)", line)
    if not match:
        return line

    level = len(match.group(1))
    content = match.group(2)

    return f"<h{level}>{content}</h{level}>"

def convert_bolding(line: str) -> str:
    return re.sub(r"\*\*(.*?)\*\*", r"<strong>\1</strong>", line)

def convert_italic(line: str) -> str:
    return re.sub(r"(?<!\*)\*(?!\*)(.*?)\*(?!\*)", r"<em>\1</em>", line)

def parse_markdown(md: str) -> str:
    result = []

    for line in md.split("\n"):
        line = convert_heading(line)
        line = convert_bolding(line)
        line = convert_italic(line)

        result.append(line)

    return "\n".join(result)

def build_html_page(body: str, title="Markdown Preview") -> str:
    return f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>{title}</title>
</head>
<body>
{body}
</body>
</html>
"""

def main():
    parser = argparse.ArgumentParser(description="Convert Markdown to HTML (custom or full parser)")
    parser.add_argument("markdown_path", type=Path)
    parser.add_argument(
        "--output",
        default=Path("output.html"),
        help="Output file path (default: output.html)"
    )
    parser.add_argument("--full", action="store_true", help="Use full markdown parser")

    args = parser.parse_args()

    if not args.markdown_path.exists():
        parser.error(f"File does not exist: {args.markdown_path}")

    with args.markdown_path.open("r", encoding="utf-8") as f:
        raw_content: str = f.read()

    if args.full:
        import markdown
        content = markdown.markdown(
            raw_content,
            extensions=["tables"]
        )
    else:
        content = parse_markdown(raw_content)
        content = build_html_page(content, args.markdown_path.name)

    with args.output.open("w", encoding="utf-8") as f:
        f.write(content)


if __name__ == "__main__":
    main()
