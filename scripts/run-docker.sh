#!/usr/bin/env bash
#vim:filetype=sh:shiftwidth=2:softtabstop=2:expandtab:foldmethod=marker:foldmarker=###{{{,###}}}
#shellcheck disable=2155,2034,2154,2059
set -Eeo pipefail

#######################################
# Script metadata
#######################################
readonly REPO_ROOT="$(git rev-parse --show-toplevel)"
readonly SCRIPT_DIR="${REPO_ROOT}/scripts"
readonly SCRIPT_LIB="${SCRIPT_DIR}/lib.sh"
readonly PROG="$(basename "${BASH_SOURCE[0]}")"
readonly SCRIPT_DESCRIPTION="Build rclonefzf docker image"
readonly RCLONEFZF_DOCKER_TAG="rclonefzf"
readonly RCLONEFZF_DOCKERFILE="${REPO_ROOT}/docker/Dockerfile"
readonly RCLONE_CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/rclone"

#######################################
# Configuration
#######################################
VERBOSE=${VERBOSE:-true}

if [[ -e "${SCRIPT_LIB}" ]]; then
  if ! source "${SCRIPT_LIB}"; then
    die "Unable to source library: ${SCRIPT_LIB}"
  fi
else
  die "Cannot find library file: ${SCRIPT_LIB}"
fi

#######################################
# Functions
#######################################
docker_run() {
  verbose "Running docker image: '${RCLONEFZF_DOCKER_TAG}'"
  if docker run --rm --interactive --tty --volume "${PWD}:/workspace" --volume "${RCLONE_CONFIG_DIR}:/home/dev/.config/rclone:ro" "${RCLONEFZF_DOCKER_TAG}" rclonefzf; then
    success "Ran docker image: '${RCLONEFZF_DOCKER_TAG}'"
  else
    die "Failed to run docker image: '${RCLONEFZF_DOCKER_TAG}'"
  fi
}

#######################################
# Main
#######################################
is_installed "git"
is_installed "docker"

cd_directory "${REPO_ROOT}"
bash "${SCRIPT_DIR}/build-dockerfile.sh"
dir_exists "${RCLONE_CONFIG_DIR}"
if ! file_exists "${RCLONE_CONFIG_DIR}/rclone.conf"; then
  die "Cannot find rclone config file. Please configure rclone remotes on the host system with the command: 'rclone config'"
fi
docker_run

success "All done!"
