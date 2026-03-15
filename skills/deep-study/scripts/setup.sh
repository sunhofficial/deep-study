#!/bin/bash
# deep-study skill setup script
# Installs notebooklm-py and verifies authentication

set -e

NOTEBOOKLM_BIN="$HOME/.local/bin/notebooklm"

echo "=== Deep Study Skill Setup ==="

# Step 1: Check if pipx is installed
if ! command -v pipx &>/dev/null; then
    echo "[1/4] Installing pipx..."
    if command -v brew &>/dev/null; then
        brew install pipx 2>&1
    else
        python3 -m pip install --user pipx 2>&1
    fi
    pipx ensurepath 2>&1 || true
else
    echo "[1/4] pipx already installed"
fi

# Step 2: Check if notebooklm-py is installed
if [ -f "$NOTEBOOKLM_BIN" ] || command -v notebooklm &>/dev/null; then
    echo "[2/4] notebooklm-py already installed"
    NOTEBOOKLM_CMD="${NOTEBOOKLM_BIN}"
    if ! [ -f "$NOTEBOOKLM_CMD" ]; then
        NOTEBOOKLM_CMD="$(command -v notebooklm)"
    fi
else
    echo "[2/4] Installing notebooklm-py..."
    pipx install "notebooklm-py[browser]" 2>&1
    NOTEBOOKLM_CMD="$NOTEBOOKLM_BIN"
fi

# Step 3: Install playwright chromium if needed
PIPX_VENV="$HOME/.local/pipx/venvs/notebooklm-py"
if [ -d "$PIPX_VENV" ]; then
    PLAYWRIGHT_BIN="$PIPX_VENV/bin/playwright"
    if [ -f "$PLAYWRIGHT_BIN" ]; then
        echo "[3/4] Ensuring Chromium is installed..."
        "$PLAYWRIGHT_BIN" install chromium 2>&1 || true
    fi
else
    echo "[3/4] Skipping Chromium (non-pipx install)"
fi

# Step 4: Check authentication
echo "[4/4] Checking authentication..."
export PATH="$HOME/.local/bin:$PATH"

AUTH_RESULT=$("$NOTEBOOKLM_CMD" auth check --json 2>&1) || true

if echo "$AUTH_RESULT" | grep -q '"token_fetch": true'; then
    echo ""
    echo "=== Setup Complete ==="
    echo "Authentication: OK"
    "$NOTEBOOKLM_CMD" --version
    exit 0
else
    echo ""
    echo "=== Authentication Required ==="
    echo "NotebookLM is installed but not authenticated."
    echo ""
    echo "Please run this command in your terminal:"
    echo ""
    echo "    notebooklm login"
    echo ""
    echo "Then come back and say 'done' or 'ready'."
    exit 1
fi
