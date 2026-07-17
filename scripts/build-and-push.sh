#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_PREFIX="${1:-${DOCKERHUB_USERNAME:-seu-usuario-dockerhub}}"
TAG="${2:-latest}"

"${ROOT_DIR}/scripts/build-images.sh" "${REPO_PREFIX}" "${TAG}"
"${ROOT_DIR}/scripts/push-images.sh" "${REPO_PREFIX}" "${TAG}"
