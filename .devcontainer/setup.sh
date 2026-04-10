#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

make getlibs && make build -j$(nproc)

if [ -f .vscode/launch.json ]; then
    echo "VS Code launch configuration already exists. Skipping 'make vscode'."
else
    make vscode
    echo "VS Code launch configuration created at .vscode/launch.json"
fi
