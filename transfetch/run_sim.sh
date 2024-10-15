#!/bin/bash

#VERSION=1_trans_3_trans_context_f1_64_16

VERSION=3_trans_128_cx

cd ./ChampSim

ROOT="../"
# ChampSimTrace_ROOT="../SampleData/ChampSimTraces"
ChampSimTrace_ROOT="/home/lwj/TransFetch/traces"
# OUTPUT_ROOT="../res"
OUTPUT_ROOT="/home/lwj/TransFetch/res"


OUTPUT_PATH=$OUTPUT_ROOT/$VERSION/sim
Gen_reports_path=$OUTPUT_ROOT/$VERSION/sim/reports
PrefFile_ROOT=$OUTPUT_ROOT/$VERSION/train
Gen_eval_path=$OUTPUT_PATH

# app_list=(410.bwaves-s0.txt.xz)
app_list=(654.roms-s7.txt)
# app_list=(cc-14.txt.xz)


mkdir $OUTPUT_PATH
mkdir $Gen_reports_path

#cd $ChampSim_path
#python ./$ChampSim_path/ml_prefetch_sim.py build
#./ml_prefetch_sim.py build

WARM=51
SIM=50


#for app1 in `ls $ChampSimTrace_ROOT`; do
for app1 in ${app_list[*]}; do
	if [[ ${app1:0:1} -eq 6 ]]
	then
    	app2=${app1%%.txt*}.trace.xz
    else
    	app2=${app1%%.txt*}.trace.gz
    fi
    echo ${app2}

    # 打印 111
    # echo 111

    # 打印完整路径
    # echo "${ChampSimTrace_ROOT}/${app2}"

    # ./ml_prefetch_sim.py run /home/lwj/TransFetch/traces/654.roms-s7.trace.xz --num-prefetch-warmup-instructions 51 --num-instructions 50 
    # --results-dir ../res/1_trans_128_cx/sim/reports --prefetch TransFetch/res/1_trans_128_cx/train/654.roms-s7.trace.xz.model.pth.prefetch_file.csv
    echo "there run start"
    ./ml_prefetch_sim.py run $ChampSimTrace_ROOT/$app2 --num-prefetch-warmup-instructions $WARM --num-instructions $SIM --results-dir $Gen_reports_path --prefetch $PrefFile_ROOT/${app1}.model.pth.prefetch_file.csv 
    # --no-base
    echo "there run end"

done

echo "there eval start"
./ml_prefetch_sim.py eval --results-dir $Gen_reports_path --output-file $Gen_eval_path/eval.csv
echo "there eval end"

echo "Done for "${app1}