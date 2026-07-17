#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[1/4] Validando scripts shell..."
for script in "$ROOT_DIR/scripts"/*.sh; do
  if [[ ! -f "$script" ]]; then
    continue
  fi
  bash -n "$script"
done

echo "[2/4] Validando Dockerfiles..."
for dockerfile in "$ROOT_DIR/backend/Dockerfile" "$ROOT_DIR/frontend/Dockerfile" "$ROOT_DIR/database/Dockerfile"; do
  if [[ -f "$dockerfile" ]]; then
    echo "OK: $(basename "$dockerfile")"
  else
    echo "FALHA: $dockerfile" >&2
    exit 1
  fi
done

echo "[3/4] Validando manifests Kubernetes..."
for manifest in "$ROOT_DIR/deployment.yml" "$ROOT_DIR/services.yml"; do
  if [[ -f "$manifest" ]]; then
    echo "OK: $(basename "$manifest")"
  else
    echo "FALHA: $manifest" >&2
    exit 1
  fi
done

echo "[4/4] Teste concluído com sucesso."
