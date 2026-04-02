#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

# Find TARGET from common.mk (multi-core projects) or Makefile (single-core)
if [ -f "common.mk" ]; then
    TARGET=$(grep -E '^TARGET\s*=' common.mk | head -1 | sed 's/TARGET\s*=\s*//' | tr -d '[:space:]')
elif [ -f "Makefile" ]; then
    TARGET=$(grep -E '^TARGET\s*=' Makefile | head -1 | sed 's/TARGET\s*=\s*//' | tr -d '[:space:]')
else
    echo "ERROR: Cannot find Makefile or common.mk" && exit 1
fi


# [ -z "$TARGET" ] && echo "ERROR: Could not determine TARGET" && exit 1
# echo "Found TARGET: $TARGET"

# # Strip APP_ prefix to get the BSP name expected by library-manager-cli
# BSP_NAME="${TARGET#APP_}"

# # The BSP directory gets TARGET_ prepended to the full TARGET value
# BSP_DIR="bsps/TARGET_${TARGET}"

# if [ -d "$BSP_DIR" ]; then
#     echo "BSP already exists: $BSP_DIR — skipping library-manager-cli"
# else
#     echo "Adding BSP: $BSP_NAME"
#     /opt/Tools/ModusToolbox/tools_3.7/library-manager/bin/library-manager-cli \
#         --add-bsp-name "$BSP_NAME" \
#         --project .
# fi

make getlibs && make vscode && make build -j$(nproc)
