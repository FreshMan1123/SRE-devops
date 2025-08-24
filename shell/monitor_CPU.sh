#!/bin/bash
while true;do
    metric=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    if [ $(echo "$metric > 1" | bc) -eq 1 ];then
        echo "CPU利用率${metric}"
    fi
    sleep 10
done


# bc是linux中进行带浮点数判断的方法
# echo "1.00 > 1" | bc 即可对比，但为真时返回1，为假返回0，但需要注意 
# 需要一个-eq来进行真值判断