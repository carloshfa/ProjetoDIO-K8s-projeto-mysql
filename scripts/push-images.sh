#!/usr/bin/env bash
set -euo pipefail

REPO_PREFIX="${1:-${DOCKERHUB_USERNAME:-seu-usuario-dockerhub}}"
TAG="${2:-latest}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker não encontrado no PATH." >&2
  exit 1
fi

if [[ -z "${DOCKERHUB_USERNAME:-}" ]]; then
  echo "Defina DOCKERHUB_USERNAME antes de enviar as imagens." >&2
  exit 1
fi

if [[ -n "${DOCKERHUB_PASSWORD:-}" ]]; then
  echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
else
  docker login -u "${DOCKERHUB_USERNAME}"
fi

for service in backend frontend database; do
  echo "=> Enviando ${REPO_PREFIX}/${service}:${TAG}"
  docker push "${REPO_PREFIX}/${service}:${TAG}"
done

echo "Push concluído."
