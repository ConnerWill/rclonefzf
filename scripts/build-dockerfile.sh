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
docker_build() {
  verbose "Building docker image: '${RCLONEFZF_DOCKER_TAG}' from file: '${RCLONEFZF_DOCKERFILE}'"
  if docker build --tag "${RCLONEFZF_DOCKER_TAG}" --file "${RCLONEFZF_DOCKERFILE}" "${REPO_ROOT}"; then
    success "Built docker image: '${RCLONEFZF_DOCKER_TAG}' from file: '${RCLONEFZF_DOCKERFILE}'"
  else
    die "Failed to build docker image: '${RCLONEFZF_DOCKER_TAG}' from file: '${RCLONEFZF_DOCKERFILE}'"
  fi
}

#######################################
# Main
#######################################
is_installed "git"
is_installed "docker"

cd_directory "${REPO_ROOT}"
docker_build

success "All done!"
