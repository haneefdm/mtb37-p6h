#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY_PATH="${SCRIPT_DIR}/ssh-keys/vscode-experiment-ed25519"
CONFIG_PATH="${HOME}/.ssh/config"

if [[ ! -f "${KEY_PATH}" ]]; then
  echo "ERROR: key not found at ${KEY_PATH}" >&2
  exit 1
fi

mkdir -p "${HOME}/.ssh"
chmod 700 "${HOME}/.ssh"

if [[ ! -f "${CONFIG_PATH}" ]]; then
  touch "${CONFIG_PATH}"
  chmod 600 "${CONFIG_PATH}"
fi

BEGIN_MARK="# BEGIN hello-devcontainer alias"
END_MARK="# END hello-devcontainer alias"

if grep -Fq "${BEGIN_MARK}" "${CONFIG_PATH}"; then
  echo "Alias block already exists in ${CONFIG_PATH}; no changes made."
  exit 0
fi

cat >> "${CONFIG_PATH}" <<EOF

${BEGIN_MARK}
Host hello-devcontainer
  HostName localhost
  Port 2222
  User vscode
  IdentityFile ${KEY_PATH}
  IdentitiesOnly yes
  StrictHostKeyChecking accept-new
${END_MARK}
EOF

chmod 600 "${CONFIG_PATH}"

echo "Added SSH alias 'hello-devcontainer' to ${CONFIG_PATH}."
echo "Test with: ssh hello-devcontainer"
