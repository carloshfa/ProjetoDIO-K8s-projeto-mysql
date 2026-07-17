#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_PREFIX="${1:-${DOCKERHUB_USERNAME:-seu-usuario-dockerhub}}"
TAG="${2:-latest}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker não encontrado no PATH." >&2
  exit 1
fi

echo "Construindo imagens com o prefixo: ${REPO_PREFIX}"

for service in backend frontend database; do
  echo "=> Construindo ${service}:${TAG}"
  docker build -t "${REPO_PREFIX}/${service}:${TAG}" "${ROOT_DIR}/${service}"
done

echo "Build concluído."
