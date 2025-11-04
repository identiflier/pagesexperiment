# C++ → WebAssembly (Emscripten) Starter for GitHub Pages

This is a minimal, no-dependency starter that compiles a small C++ file to WebAssembly and runs it on a static site (GitHub Pages).

## Requirements

- Emscripten SDK (emsdk)
- A simple static HTTP server for local testing

### Install Emscripten

**macOS / Linux / WSL:**

```bash
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh       # add to your shell profile to persist
```

**Windows (PowerShell):**

```powershell
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
.\emsdk install latest
.\emsdk activate latest
.\emsdk_env.ps1             # run each session or add to profile
```

## Build

```bash
./build.sh
```

Outputs: `web/math.js` + `web/math.wasm`

## Run locally

```bash
python3 -m http.server 8000 --directory web
# then open http://localhost:8000/
```

## Deploy to GitHub Pages

Option A (recommended): place everything in your repo and move `web/` → `docs/`.  
Then in **Settings → Pages**, set Source: **Deploy from a branch**, Branch: `main`, Folder: `/docs`.

Or keep `web/` at repo root and configure Pages to serve from root.

This project already includes a `.nojekyll` to prevent GitHub Pages from interfering with wasm assets.

## Tips

- Exported C functions must be listed in `-s EXPORTED_FUNCTIONS='["_name"]'` and defined with `extern "C"` to avoid C++ name mangling.
- To call from JS, use `cwrap('name', returnType, [argTypes...])`.
- Build types:
  - Debug: replace `-O3` with `-O0 -g4 --source-map-base /` to generate source maps.
  - Release: keep `-O3`, consider `-flto` for smaller code (requires LLVM LTO support).
- File I/O: Use `--preload-file mydata@/data` and fetch from `/data/...` in the virtual FS.
- Threads: Pthreads need cross-origin isolation headers (COOP/COEP) which GitHub Pages doesn't set, so **pthreads won't work** here.
- Avoid secrets: Everything runs in the browser. Do not embed API keys or private logic.
