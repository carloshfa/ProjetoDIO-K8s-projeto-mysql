#!/usr/bin/env bash
# Script para fazer push das imagens Docker para o Docker Hub.
set -euo pipefail

REPO_PREFIX="${1:-${DOCKERHUB_USERNAME:-seu-usuario-dockerhub}}"
TAG="${2:-latest}"

# Verifica se o Docker está disponível no PATH.
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker não encontrado no PATH." >&2
  exit 1
fi

# Valida se o usuário Docker Hub foi definido.
if [[ -z "${DOCKERHUB_USERNAME:-}" ]]; then
  echo "Defina DOCKERHUB_USERNAME antes de enviar as imagens." >&2
  exit 1
fi

# Efetua login no Docker Hub. Se DOCKERHUB_PASSWORD estiver definido, usa login não interativo.
if [[ -n "${DOCKERHUB_PASSWORD:-}" ]]; then
  echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
else
  docker login -u "${DOCKERHUB_USERNAME}"
fi

# Faz push de cada imagem criada para o repositório especificado.
for service in backend frontend database; do
  echo "=> Enviando ${REPO_PREFIX}/${service}:${TAG}"
  docker push "${REPO_PREFIX}/${service}:${TAG}"
done

echo "Push concluído."
