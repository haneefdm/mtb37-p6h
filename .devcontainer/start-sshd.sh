#!/usr/bin/env bash
set -euo pipefail

KEY_DIR="/workspaces/Hello_World/.devcontainer/ssh-keys"
PUB_KEY="${KEY_DIR}/vscode-experiment-ed25519.pub"

mkdir -p /home/vscode/.ssh
chmod 700 /home/vscode/.ssh

touch /home/vscode/.ssh/authorized_keys
chmod 600 /home/vscode/.ssh/authorized_keys

if [[ -f "${PUB_KEY}" ]]; then
    # Add the experiment key once; keep authorized_keys idempotent across starts.
    if ! grep -Fxq "$(cat "${PUB_KEY}")" /home/vscode/.ssh/authorized_keys; then
        cat "${PUB_KEY}" >> /home/vscode/.ssh/authorized_keys
    fi
fi

sudo mkdir -p /run/sshd
if ! pgrep -x sshd >/dev/null; then
    sudo /usr/sbin/sshd
fi
