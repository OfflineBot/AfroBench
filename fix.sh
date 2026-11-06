#!/bin/bash
set -e

HARNESS=~/AfroBench/AfroBench/lm-evaluation-harness
TASKS=$HARNESS/lm_eval/tasks/afrobench

echo "Resetting task files"
cd "$HARNESS"
git checkout -- lm_eval/tasks/afrobench/masakhapos lm_eval/tasks/afrobench/mafand lm_eval/tasks/afrobench/nollysenti

echo "Fixing masakhapos"
python3 -c "import pathlib,sys; b=sys.argv[1]; [pathlib.Path(b,f'prompt_{p}','utils.py').write_text(pathlib.Path(b,f'prompt_{p}','utils.py').read_text().replace('return [pos_tag_map[tag] for tag in doc[\"upos\"]]','return \" \".join(pos_tag_map[tag] for tag in doc[\"upos\"])').replace('flattened_preds):\n        # Ensure','flattened_preds):\n        gold = gold.split()\n        # Ensure')) for p in range(1,6)]; print('fertig')" "$TASKS/masakhapos"

echo "Fixing mafand"
cd "$TASKS/mafand"
sed -i '/sentence: /s/",$/"/' prompt_*/*/utils.py

echo "Fixing nollysenti"
cd "$TASKS/nollysenti"
for d in prompt_1 prompt_2 prompt_3 prompt_4 prompt_5; do
    cat >> "$d/utils.py" <<'EOF'


def process_docs(dataset):
    def _norm(doc):
        review = next((v for k, v in doc.items() if k.endswith("_review")), doc.get("review", ""))
        doc["review"] = review
        doc["label"] = 0 if str(doc.get("sentiment", "")).strip().lower() == "positive" else 1
        return doc
    return dataset.map(_norm)
EOF
    sed -i '/output_type: multiple_choice/a process_docs: !function utils.process_docs' "$d/nollysenti"
done

echo "Done"
