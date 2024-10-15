#!/bin/bash

VERSION=1_trans_128_cx

ROOT="./"
#LoadTrace_ROOT="./SampleData/LoadTraces"
LoadTrace_ROOT="/home/lwj/TransFetch/traces"
# OUTPUT_ROOT="./res"
OUTPUT_ROOT="/home/lwj/TransFetch/res"

Python_ROOT=$ROOT"/TransFetch"

# TRAIN=2
# VAL=1
# TEST=2
# SKIP=0

TRAIN=5
VAL=5
TEST=5
SKIP=1

TRAIN_WARM=$TRAIN
TRAIN_TOTAL=$(($TRAIN + $VAL)) 

TEST_WARM=$TRAIN_WARM
TEST_TOTAL=$(($TRAIN+$TEST)) 

#app_list=(410.bwaves-s0.txt.xz)
app_list=(654.roms-s7.txt)
# app_list=(cc-14.txt.xz)


echo "TRAIN/VAL/TEST/SKIP: "$TRAIN"/"$VAL"/"$TEST"/"$SKIP

mkdir $OUTPUT_ROOT
mkdir $OUTPUT_ROOT/$VERSION
mkdir $OUTPUT_ROOT/$VERSION/train

#for app1 in `ls $LoadTrace_ROOT`; do
for app1 in ${app_list[*]}; do
	echo $app1
	file_path=$LoadTrace_ROOT/${app1}
    model_path="$OUTPUT_ROOT/$VERSION/train/${app1}.model.pth"
	#app2=${app1%%.txt*}.trace.xz

	echo "lwj: model_path"$model_path
	# python ./TransFetch/train.py  /home/lwj/TransFetch/traces/654.roms-s7.txt.xz ./res/1_trans_128_cx/train/654.roms-s7.txt.xz.model.pth 2 3 0
	# python ./TransFetch/generate.py  /home/lwj/TransFetch/traces/654.roms-s7.txt.xz ./res/1_trans_128_cx/train/654.roms-s7.txt.xz.model.pth 2 4 0
    python $Python_ROOT/train.py  $file_path  $model_path $TRAIN_WARM $TRAIN_TOTAL $SKIP
    python $Python_ROOT/generate.py  $file_path  $model_path $TEST_WARM $TEST_TOTAL $SKIP
    
	echo "done for app "$app1
done

