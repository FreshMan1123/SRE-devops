#!/bin/bash
#要求： 写 一个脚本检查某个进程是否运行，如果不运行就输出提示信息。
#具体要求：
#接受一个进程名作为参数
##如果运行，输出 "进程 xxx 正在运行"
#如果不运行，输出 "进程 xxx 未运行"

process=$1
if [ -n "$(pgrep $process)" ]; then
    echo "进程:$process 正在运行"
    exit
fi  
    echo "进程:$process 未运行"

