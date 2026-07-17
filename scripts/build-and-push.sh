#!/usr/bin/env bash
# Script para construir e enviar imagens Docker em sequência.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_PREFIX="${1:-${DOCKERHUB_USERNAME:-seu-usuario-dockerhub}}"
TAG="${2:-latest}"

# Executa a construção de imagens e, em seguida, o push para o Docker Hub.
"${ROOT_DIR}/scripts/build-images.sh" "${REPO_PREFIX}" "${TAG}"
"${ROOT_DIR}/scripts/push-images.sh" "${REPO_PREFIX}" "${TAG}"
