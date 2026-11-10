#!/usr/bin/env python3
import json, glob, os, collections

PRIORITY = ["acc", "f1", "exact_match", "chrf", "bleu"]

CATEGORY = {
    "afrisenti": "classification", "nollysenti": "classification",
    "masakhanews": "classification", "sib": "classification", "injongo": "classification",
    "afrixnli": "nli",
    "belebele": "qa", "afriqa": "qa", "naijarc": "qa",
    "masakhaner": "token", "masakhapos": "token",
    "afrimmlu": "knowledge",
    "afrimgsm": "math",
    "mafand": "mt", "salt": "mt", "flores": "mt",
}

def pick(metrics):
    numeric = {k.split(",")[0]: v for k, v in metrics.items() if isinstance(v, (int, float))}
    for name in PRIORITY:
        if name in numeric:
            v = numeric[name]
            return v * 100 if v <= 1 else v
    for v in numeric.values():
        return v * 100 if v <= 1 else v
    return None

f = max(glob.glob("results_*.json"), key=os.path.getmtime)
d = json.load(open(f))

cat = collections.defaultdict(list)
unmapped = set()
for task, m in d["results"].items():
    v = pick(m)
    if v is None:
        continue
    fam = task.split("_")[0]
    c = CATEGORY.get(fam)
    if c is None:
        unmapped.add(fam)
    else:
        cat[c].append(v)

if unmapped:
    print("!! NICHT gemappt:", sorted(unmapped), "\n")

print("=== per category (0-100) ===")
means = {}
for c in sorted(cat):
    means[c] = sum(cat[c]) / len(cat[c])
    print(f"{c:16s} {means[c]:7.3f}  (n={len(cat[c])})")

overall = sum(means.values()) / len(means)
print(f"\n=== OVERALL === {overall:.3f}")

