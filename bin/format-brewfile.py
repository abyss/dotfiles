#!/usr/bin/env python3
"""Format Brewfile with aligned comments within each section or file-wide."""

import argparse
import sys
from pathlib import Path

COMMENT_SPACING = 4  # Number of spaces between content and comment


def get_max_len(lines):
    """Get max content length from lines with comments."""
    return max((len(l.rstrip().partition('#')[0].rstrip())
                for l in lines if '#' in l), default=0)


def format_line(line, max_len):
    """Format a single line with aligned comment."""
    content, sep, comment = line.rstrip().partition('#')
    content = content.rstrip()
    if sep and content:
        return f"{content.ljust(max_len)}{' ' * COMMENT_SPACING}#{comment}\n"
    return f"{line.rstrip()}\n"


def format_brewfile(content, file_wide=False):
    """Format entire Brewfile content."""
    lines = content.splitlines(keepends=True)

    if file_wide:
        non_headers = [l for l in lines if l.strip() and not l.startswith('#')]
        max_len = get_max_len(non_headers)
        return ''.join(format_line(l, max_len) if l.strip() and not l.startswith('#')
                      else l for l in lines)

    # Section-based formatting
    result, section = [], []
    for line in lines:
        if not line.strip() or line.startswith('#'):
            if section:
                result.extend(format_line(l, get_max_len(section)) for l in section)
                section = []
            result.append(line)
        else:
            section.append(line)

    if section:
        result.extend(format_line(l, get_max_len(section)) for l in section)

    return ''.join(result)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Format Brewfile with aligned comments')
    parser.add_argument('brewfile', help='Path to Brewfile')
    parser.add_argument('--file-wide', action='store_true',
                        help='Align all comments in the file (default: align by section)')
    args = parser.parse_args()

    path = Path(args.brewfile)

    if not path.exists():
        sys.exit(f"Error: {path} not found")

    path.write_text(format_brewfile(path.read_text(), file_wide=args.file_wide))
    print(f"Formatted {path}{' (file-wide)' if args.file_wide else ''}")
