#!/bin/bash
# One-command local launcher (Linux / macOS / WSL2).
# Installs everything on first run, then starts the server and prints the URL.
#
#   bash start_local.sh            # port 18888
#   PORT=9000 bash start_local.sh  # custom port

set -eu

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="$ROOT_DIR/server"
VENV_DIR="${VENV_DIR:-$SERVER_DIR/.venv}"
PORT="${PORT:-18888}"
PY_VERSION=3.10
STAMP="$VENV_DIR/.deps_installed"

info() { echo -e "\033[32m[start_local] $*\033[0m"; }
die()  { echo -e "\033[31m[start_local] ERROR: $*\033[0m" >&2; exit 1; }

# 1. Python 3.10 (torch 2.0.1 / onnxruntime pins do not support 3.12+)
if [ ! -x "$VENV_DIR/bin/python" ]; then
    if command -v "python$PY_VERSION" >/dev/null 2>&1; then
        PYTHON="python$PY_VERSION"
    else
        command -v uv >/dev/null 2>&1 || { info "installing uv"; python3 -m pip install --user -q uv; }
        info "installing Python $PY_VERSION via uv"
        uv python install "$PY_VERSION" >/dev/null
        PYTHON="$(uv python find "$PY_VERSION")"
    fi
    info "creating virtualenv at $VENV_DIR"
    "$PYTHON" -m venv "$VENV_DIR"
fi
PIP="$VENV_DIR/bin/pip"
PYBIN="$VENV_DIR/bin/python"

# 2. System audio library needed by the sounddevice package
if [ "$(uname)" = "Linux" ] && ! ldconfig -p 2>/dev/null | grep -q libportaudio; then
    info "installing libportaudio2 (needs sudo)"
    sudo apt-get update -qq && sudo apt-get install -y -qq libportaudio2 \
        || die "could not install libportaudio2. Run: sudo apt-get install libportaudio2"
fi

# 3. Python dependencies (re-run only when requirements.txt changes)
REQ_HASH="$(cat "$SERVER_DIR/requirements.txt" | sha256sum | cut -d' ' -f1)"
if [ ! -f "$STAMP" ] || [ "$(cat "$STAMP")" != "$REQ_HASH" ]; then
    info "installing dependencies (first run takes a while)"
    "$PIP" install -q --upgrade "pip<24" wheel "setuptools<70"
    "$PIP" install -q numpy==1.23.5
    "$PIP" install -q pyworld==0.3.3 --no-build-isolation
    "$PIP" install -q -r "$SERVER_DIR/requirements.txt"
    echo "$REQ_HASH" > "$STAMP"
fi

# 4. Start the server (it also serves the web UI)
cd "$SERVER_DIR"
info "starting server on port $PORT"
info "open http://localhost:$PORT/ in Chrome"
exec "$PYBIN" MMVCServerSIO.py -p "$PORT"
