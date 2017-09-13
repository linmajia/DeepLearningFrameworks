#!/bin/bash

out_dir="results/$1_$2"
if [ ! -d ${out_dir} ]
	then
		mkdir -p ${out_dir}
fi
rm -fr ${out_dir}/*

if [ "$1" == "gpu" ]
	then
		c=0
		visible_devices=""
		while [ $c -lt $2 ]; do
			visible_devices="${visible_devices} ${c}"
			let c=c+1
		done
		CUDA_VISIBLE_DEVICES="${visible_devices}"
		export CUDA_VISIBLE_DEVICES
fi

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
