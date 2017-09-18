#!/bin/bash

cwd=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )

out_dir="${cwd}/logs/$(date +%Y_%m_%d_%H_%M_%S)"
if [ ! -d ${out_dir} ]; then
    mkdir -p ${out_dir}
fi
rm -fr ${out_dir}/*

n=0

declare -a test_array

case "$(uname -s)" in

    Darwin)
     ;;

    *)
    test_array+=(CNTK Keras_CNTK)
    ;;
esac

gpu=$(python -m pip show tensorflow-gpu)
if [ "${gpu}" == "" ]; then
    test_array+=(Tensorflow)
else
    test_array+=(Tensorflow_NHWC)
fi

test_array+=(Keras_TF MXNet Gluon Chainer)

for i in "${test_array[@]}"
do
    echo -e "\n"
    echo Test $n: $i
    echo -e "\n"
    rm -f "${cwd}/${i}_CIFAR.py"
    ipython nbconvert --to python "${cwd}/${i}_CIFAR.ipynb" >/dev/null 2>&1
    log_file="${out_dir}/${i}_CIFAR.log"
    rm -f ${log_file}
    ipython ${i}_CIFAR.py 2>&1 | tee ${log_file}
    let n=n+1
    echo -e "\n"
done
