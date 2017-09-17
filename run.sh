#!/bin/bash

out_dir="results/$(date +%Y_%m_%d_%H_%M_%S)"
if [ ! -d ${out_dir} ]
	then
		mkdir -p ${out_dir}
fi
rm -fr ${out_dir}/*

n=0

case "$(uname -s)" in

   Darwin)
     test_array=(Tensorflow_NHWC Keras_TF MXNet Gluon Chainer)
     ;;

   *)
     test_array=(CNTK Tensorflow_NHWC Keras_CNTK Keras_TF MXNet Gluon Chainer)
     ;;
esac

for i in "${test_array[@]}"
do
	echo Test $n: $i
	echo ""
	rm -f ${i}_CIFAR.py
	ipython nbconvert --to python ${i}_CIFAR.ipynb >/dev/null 2>&1
	log_file="${out_dir}/${i}_CIFAR.log"
	rm -f ${log_file}
	ipython ${i}_CIFAR.py 2>&1 | tee ${log_file}
	let n=n+1
	echo -e "\n\n\n"
done
