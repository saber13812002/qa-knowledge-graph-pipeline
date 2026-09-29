QA Knowledge Graph Pipeline
===========================

Pipeline for converting raw OCR JSON (books) into a Neo4j knowledge graph
compatible with the mesbahv2 schema.

FEATURES
--------
- Chunk extraction: one Chunk per book page
- Embeddings: Qwen3-Embedding-4B (2560-dim)
- LLM entity/relation extraction: Qwen2.5-7B-Instruct via vLLM
- Neo4j dump export ready for neo4j-admin database load
- Resume-safe with hashed cache

REQUIREMENTS
------------
- NVIDIA GPU (>= 16 GB VRAM)
- Docker + nvidia-container-toolkit
- ~30 GB disk for models, ~50 GB for outputs

QUICKSTART
----------
cp .env.example .env
bash scripts/run.sh up
bash scripts/run.sh step1
bash scripts/run.sh step2
bash scripts/run.sh step3
bash scripts/run.sh step4
bash scripts/run.sh step5
bash scripts/run.sh step6

STRUCTURE
---------
input/   raw JSON (not in git)
output/  per-run artifacts (not in git)
scripts/ pipeline steps
configs/ YAML configs
docs/    schema documentation
