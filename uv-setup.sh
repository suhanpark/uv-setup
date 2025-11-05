#!/bin/bash
# setup-uv: initialize a uv project using the parent dir context, skipping if already initialized

set -euo pipefail

# Capture original working directory
ORIG_DIR=$(pwd)
echo "Current working directory: $ORIG_DIR"

# Determine project directory name
if [ -n "${1-}" ]; then
    DIR_NAME="$1"
else
    DIR_NAME=$(basename "$ORIG_DIR")
fi
echo "Using directory name: $DIR_NAME"

# Determine Python Version
if [ -n "${v-}" ]; then
    PYTHON_VERSION="$v"
else
    PYTHON_VERSION="3.11"
fi
echo "Using Python version: $PYTHON_VERSION"

# Compute parent and target paths
PARENT_DIR=$(dirname "$ORIG_DIR")
TARGET_DIR="$PARENT_DIR/$DIR_NAME"

# Skip init if already initialized
if [ -d "$TARGET_DIR" ] && [ -f "$TARGET_DIR/pyproject.toml" ]; then
    echo "⚠️  Project already initialized in $TARGET_DIR — skipping uv init."
    cd "$TARGET_DIR"
else
    echo "Changing to parent directory: $PARENT_DIR"
    cd "$PARENT_DIR"

    echo "Initializing uv project in: $DIR_NAME"
    uv init "$DIR_NAME"

    echo "Changing to initialized directory: $TARGET_DIR"
    cd "$TARGET_DIR"
fi

# Define the virtual environment directory
VENV_DIR=".venv"

# Check if the .venv directory exists
if [ -d "$VENV_DIR" ]; then
    echo "✅ Virtual environment already exists. Activating..."
else
    echo "🚀 Creating a new virtual environment..."
    uv venv --python "$PYTHON_VERSION"
fi

# Activate the virtual environment
if [ -f "$VENV_DIR/bin/activate" ]; then
    echo "🔧 Activating virtual environment..."
    # shellcheck disable=SC1091
    source "$VENV_DIR/bin/activate"
    echo "✅ Virtual environment activated."
else
    echo "❌ Could not find activation script. Something went wrong."
    exit 1
fi

# If requirements.txt exists in the ORIGINAL directory, install dependencies
REQ_FILE="$ORIG_DIR/requirements.txt"
if [ -f "$REQ_FILE" ]; then
    echo "requirements.txt found at $REQ_FILE. Installing dependencies..."
    uv add -r "$REQ_FILE"
else
    echo "No requirements.txt found in $ORIG_DIR"
fi

# Sync the environment
echo "Running uv sync..."
uv sync

echo "✅ Setup complete in: $TARGET_DIR"