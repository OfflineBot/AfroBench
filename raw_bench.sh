#!/bin/bash


case "$1" in 
	0.8B) ACTIVE="McGill-NLP/AfriqueQwen3.5-0.8B-50Langs" ;;
	4B) ACTIVE="McGill-NLP/AfriqueQwen3.5-4B-50Langs-Instruct-v1" ;;
	9B) ACTIVE="McGill-NLP/AfriqueQwen3.5-9B-50Langs-Instruct-v1" ;;
	14B) ACTIVE="McGill-NLP/AfriqueQwen-14B" ;;
	27B) ACTIVE="Qwen/Qwen3.5-27B" ;;
	*) echo "Arg 1 requires: $0 <0.8B|4B|9B|14B|27B> [smoke|raw|smoke_offline|raw_offline]"; exit 1 ;;
esac

case "$2" in
	smoke_offline)
		LIMIT="--limit 2"; OUT="results/smoke/$(basename $ACTIVE)";
		export HF_HUB_OFFLINE=1; export HF_DATASETS_OFFLINE=1; ;;
	smoke) 
		LIMIT="--limit 2"; OUT="results/smoke/$(basename $ACTIVE)"; ;;
	raw_offline) 
		LIMIT=""; 
		OUT="results/full/$(basename $ACTIVE)"
		export HF_HUB_OFFLINE=1; export HF_DATASETS_OFFLINE=1; ;;
	raw)
		LIMIT=""; 
		OUT="results/full/$(basename $ACTIVE)" ;;

	*) echo "Arg 2 requires: $0 $1 [smoke|offline]"; exit 1 ;;
esac

mkdir -p results/cache

lm_eval --model hf \
	--model_args pretrained=$ACTIVE,dtype=bfloat16 \
	--tasks afrobench \
	--batch_size 32 \
	--gen_kwargs do_sample=False \
	--use_cache results/cache/$(basename $ACTIVE) \
	$LIMIT --output_path $OUT

