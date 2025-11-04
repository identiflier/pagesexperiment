#!/usr/bin/env bash
set -euo pipefail

# Ensure emcc is available (Emscripten)
if ! command -v emcc >/dev/null 2>&1; then
  echo "emcc not found. Please install and activate Emscripten (emsdk)." >&2
  exit 1
fi

# Paths
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/src"
WEB="$ROOT/web"

echo "Building math.cpp → $WEB/math.js + math.wasm"
emcc "$SRC/math.cpp" -O3 -s WASM=1 \
  -s MODULARIZE=1 \
  -s EXPORTED_FUNCTIONS='["_add","_fib"]' \
  -s EXPORTED_RUNTIME_METHODS='["cwrap","ccall"]' \
  -s ENVIRONMENT=web \
  -s ALLOW_MEMORY_GROWTH=1 \
  -o "$WEB/math.js"

echo "Done."
echo
echo "To test locally:"
echo "  1) Install a static server, e.g. Python's: python3 -m http.server 8000 --directory \"$WEB\""
echo "  2) Open http://localhost:8000/ in your browser"
echo
echo "To deploy on GitHub Pages:"
echo "  - Put the contents of $WEB/ in your repo's 'docs/' folder (or use the root)"
echo "  - Enable Pages (Settings → Pages) and select the 'docs/' directory as the source"
