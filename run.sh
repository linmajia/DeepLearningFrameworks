#!/bin/bash

n=0
array=(CNTK Tensorflow_NHWC Keras_CNTK Keras_TF MXNet Gluon Chainer)
for i in "${array[@]}"
do
	echo Test $n: $i
	echo ""
	rm -f ${i}_CIFAR.log
	if ! [ -f ${i}_CIFAR.py ]
		then
			ipython nbconvert --to python ${i}_CIFAR.ipynb
	fi
	ipython ${i}_CIFAR.py 2>&1 | tee ${i}_CIFAR.log
	let n=n+1
	echo -e "\n\n\n"
done
