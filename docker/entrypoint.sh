#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="/workspace"
SCRIPT_NAME="rclonefzf"
RCLONEFZF_PATH="${WORKSPACE}/bin/${SCRIPT_NAME}"

# Ensure script is executable if mounted from host
if [[ -f "${RCLONEFZF_PATH}" ]]; then
  chmod +x "${RCLONEFZF_PATH}" || true
fi

exec "${@}"
