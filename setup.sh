#!/bin/bash
set -e

echo "== setup uv =="
command -v uv >/dev/null || pip install --user uv
export PATH="$HOME/.local/bin:$PATH" 
echo "== venv (Python 3.12) =="
uv venv --python 3.12
source .venv/bin/activate

echo "== harness + dependencies =="
uv pip install -e ./lm-evaluation-harness
uv pip install -U huggingface_hub
uv pip install 'datasets==3.4.1'
uv pip install 'transformers>=5.0'

echo "== setup kernel =="
uv pip install flash-linear-attention
uv pip install causal-conv1d || echo ">> causal-conv1d Build failed (nvcc/torch CUDA-Mismatch) - skipping it..."

echo "== HuggingFace Login =="
hf auth login

echo "== AfroBench Task-Fixes =="
./fix.sh

source .venv/bin/activate
echo "done"
