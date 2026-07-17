#!/usr/bin/env bash
# Script de validação para garantir que os arquivos principais do projeto existam e tenham sintaxe válida.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[1/4] Validando scripts shell..."
# Verifica a sintaxe de todos os scripts shell no diretório scripts.
for script in "$ROOT_DIR/scripts"/*.sh; do
  if [[ ! -f "$script" ]]; then
    continue
  fi
  bash -n "$script"
done

echo "[2/4] Validando Dockerfiles..."
# Verifica se cada Dockerfile principal está presente.
for dockerfile in "$ROOT_DIR/backend/Dockerfile" "$ROOT_DIR/frontend/Dockerfile" "$ROOT_DIR/database/Dockerfile"; do
  if [[ -f "$dockerfile" ]]; then
    echo "OK: $(basename "$dockerfile")"
  else
    echo "FALHA: $dockerfile" >&2
    exit 1
  fi
done

echo "[3/4] Validando manifests Kubernetes..."
# Confirma a existência dos manifests Kubernetes usados no deploy.
for manifest in "$ROOT_DIR/deployment.yml" "$ROOT_DIR/services.yml"; do
  if [[ -f "$manifest" ]]; then
    echo "OK: $(basename "$manifest")"
  else
    echo "FALHA: $manifest" >&2
    exit 1
  fi
done

echo "[4/4] Teste concluído com sucesso."
