
# After Clone


not sure if required this way
```sh
pip install uv
```

possible sideeffect of the user pip install
```sh
export PATH="$HOME/.local/bin:$PATH"
python3 -m uv venv --python 3.12
```

correct setup
```sh
source .venv/bin/activate
uv pip install -e ./lm-evaluation-harness/
uv pip install -U huggingface_hub
uv pip install 'datasets==3.4.1'
uv pip install 'transformers>=5.0'
hf auth login
```

```
cd lm-evaluation-harness
git fetch origin
git checkout main
git pull
cd ..
uv pip install -e ./lm-evaluation-harness
uv pip install flash-linear-attention causal-conv1d
```

run the ./FIX_\*.md
to fix afrobench errors

