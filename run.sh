#!/bin/bash

out_dir="results/$(date +%Y_%m_%d_%H_%M)"
if [ ! -d ${out_dir} ]
	then
		mkdir -p ${out_dir}
fi
rm -fr ${out_dir}/*

n=0
array=(CNTK Tensorflow_NHWC Keras_CNTK Keras_TF MXNet Gluon Chainer)
for i in "${array[@]}"
do
	echo Test $n: $i
	echo ""
	if ! [ -f ${i}_CIFAR.py ]
		then
			ipython nbconvert --to python ${i}_CIFAR.ipynb
	fi
	log_file="${out_dir}/${i}_CIFAR.log"
	rm -f ${log_file}
	ipython ${i}_CIFAR.py 2>&1 | tee ${log_file}
	let n=n+1
	echo -e "\n\n\n"
done
