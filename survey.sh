#!/bin/bash
MODEL="McGill-NLP/AfriqueQwen3.5-0.8B-50Langs"

TASKS=(
adr_tasks
afrimgsm_cot_tasks
afrixnli_tasks
afrobench_xqa_tasks
afrobench_sentiment_tasks
afrobench_MT_tasks
afrobench_TC_tasks
afrobench_mmlu_tasks
injongointent_tasks
masakhaner_tasks
masakhapos_tasks
RC_tasks
uhura_arc_easy_tasks
xlsum_tasks
)

mkdir -p results/survey
: > results/survey/summary.txt

for T in "${TASKS[@]}"; do
	echo ">>> teste $T ..."
	if lm_eval --model hf \
		--model_args pretrained=$MODEL,dtype=bfloat16 \
		--tasks "$T" --batch_size 1 --limit 2 \
		--gen_kwargs do_sample=False \
		--output_path results/survey/$T > results/survey/$T.log 2>&1; then
			echo "OK   $T" | tee -a results/survey/summary.txt
		else
			ERR=$(grep -oE "[A-Za-z0-9_.]*Error: .*" results/survey/$T.log | tail -1)
			echo "FAIL $T  ->  $ERR" | tee -a results/survey/summary.txt
	fi
done

echo
echo "===== ERGEBNIS ====="
cat results/survey/summary.txt
