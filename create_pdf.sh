#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input.md>"
  exit 1
fi

input="$1"

if [ ! -f "$input" ]; then
  echo "Error: file '$input' not found"
  exit 1
fi

output="${input%.md}.pdf"

pandoc "$input" -o "$output" \
  --pdf-engine=xelatex \
  -V geometry:margin=1in

echo "Created $output"
