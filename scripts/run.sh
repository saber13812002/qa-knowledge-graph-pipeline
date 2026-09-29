#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

CMD="${1:-help}"
shift || true

case "$CMD" in
  up)         docker compose up -d vllm pipeline ;;
  down)       docker compose down ;;
  down-all)   docker compose --profile build down ;;
  logs)       docker compose logs -f "${1:-vllm}" ;;
  shell)      docker compose exec pipeline bash ;;
  vllm-test)  curl -s http://localhost:8001/v1/models | jq ;;
  build)      docker compose build pipeline ;;
  step1)      docker compose exec pipeline python /work/scripts/01_extract_chunks.py "$@" ;;
  step2)      docker compose exec pipeline python /work/scripts/02_embed_chunks.py "$@" ;;
  step3)      docker compose exec pipeline python /work/scripts/03_llm_extract.py "$@" ;;
  step4)      docker compose exec pipeline python /work/scripts/04_embed_tokens.py "$@" ;;
  step5)      docker compose exec pipeline python /work/scripts/05_export_csv.py "$@" ;;
  step6)      bash scripts/06_build_dump.sh "$@" ;;
  status)     docker compose ps ;;
  *) echo "Usage: $0 {up|down|down-all|logs|shell|vllm-test|build|step1..step6|status}" ; exit 1 ;;
esac

