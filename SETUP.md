
# After Clone

add other submodules (harness)
```sh
git submodule update --init --recursive
```

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
uv pip install 'datasets==3.4.1'
uv pip install -U huggingface_hub
uv pip install 'transformers>=5.0'
hf auth login
```
