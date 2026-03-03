#!/usr/bin/env bash
# render.sh — Render a Mermaid .mmd file to PNG.
#
# Usage: render.sh -i <input.mmd> [OPTIONS]
#   -i, --input  PATH   Input .mmd file (required)
#   -o, --output PATH   Output .png file (default: same path as input with .png extension)
#   -w, --width  INT    Image width in pixels (default: 1400)
#   -b, --bg     COLOR  Background colour (default: white)
#
# Examples:
#   render.sh -i /tmp/mermaid-chart/pipeline.mmd
#   render.sh -i /tmp/mermaid-chart/pipeline.mmd -o /tmp/mermaid-chart/pipeline.png -w 1800

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

INPUT=""
OUTPUT=""
WIDTH=1400
BG="white"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--input)
      [[ $# -lt 2 ]] && { echo "Error: --input requires a value" >&2; exit 1; }
      INPUT="$2"; shift 2 ;;
    -o|--output)
      [[ $# -lt 2 ]] && { echo "Error: --output requires a value" >&2; exit 1; }
      OUTPUT="$2"; shift 2 ;;
    -w|--width)
      [[ $# -lt 2 ]] && { echo "Error: --width requires a value" >&2; exit 1; }
      WIDTH="$2"; shift 2 ;;
    -b|--bg)
      [[ $# -lt 2 ]] && { echo "Error: --bg requires a value" >&2; exit 1; }
      BG="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [ -z "$INPUT" ]; then
  echo "Error: --input is required" >&2
  exit 1
fi

if [ ! -f "$INPUT" ]; then
  echo "Error: input file not found: $INPUT" >&2
  exit 1
fi

# Default output: replace/append .png extension
if [ -z "$OUTPUT" ]; then
  OUTPUT="${INPUT%.mmd}.png"
fi

mkdir -p "$(dirname "$OUTPUT")"

# Resolve mmdc
MMDC="$("$SCRIPT_DIR/setup.sh")"

echo "Rendering $INPUT → $OUTPUT (width: ${WIDTH}px)" >&2
"$MMDC" -i "$INPUT" -o "$OUTPUT" -w "$WIDTH" --backgroundColor "$BG"
echo "$OUTPUT"
