#!/bin/bash
#题目 2: 系统资源监控
#目标: 编写一个系统资源监控脚本。
#脚本接受一个浮点数作为 CPU 使用率的阈值。
#获取当前系统中 CPU 占用率最高的进程。
#判断该进程的 CPU 使用率是否超过了脚本接收到的阈值。
#如果超过，则打印一条包含当前 CPU 使用率的警告信息。

read -r cpus

current_row=$(ps -eo pid,%cpus --sort=-cpus | awk '{if(NR==2){print($2)}}')
if [ $(echo "$current_row>$cpus") | bc -eq 1 ];then
    echo "超过了阈值${cpus}"
    exit1
fi