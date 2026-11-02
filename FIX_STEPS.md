
# Fix for nollysenti

```sh
/home/cosmic-lilac-maple/AfroBench/AfroBench/lm-evaluation-harness/lm_eval/tasks/afrobench/nollysenti/custom_script.sh
```

# Fix for afrobench/masakhapos

```sh
python3 -c "import pathlib,sys; b=sys.argv[1]; [pathlib.Path(b,f'prompt_{p}','utils.py').write_text(pathlib.Path(b,f'prompt_{p}','utils.py').read_text().replace('return [pos_tag_map[tag] for tag in doc[\"upos\"]]','return \" \".join(pos_tag_map[tag] for tag in doc[\"upos\"])').replace('flattened_preds):\n # Ensure','flattened_preds):\n        gold = gold.split()\n        # Ensure')) for p in range(1,6)]; print('fertig')" ~/AfroBench/AfroBench/lm-evaluation-harness/lm_eval/tasks/afrobench/masakhapos
```

# BUG:
string is interpreted as tuple. reason: extra comma?
```sh
cd ~/AfroBench/AfroBench/lm-evaluation-harness/lm_eval/tasks/afrobench/mafand
sed -i '/sentence: /s/",$/"/' prompt_*/*/utils.py
```
