#!/bin/bash
#第2题：系统监控脚本
#每10秒检查一次CPU使用率
#当CPU使用率超过80.0%时，记录当前时间和CPU值到monitor.log文件
#同时找出当前消耗CPU最高的前3个进程（显示PID、CPU%、命令）
#脚本应该能够在后台持续运行
#使用bc命令进行浮点数比较
while true;do
cpus=$(top -bn1 | grep "Cpu(s)" | awk '{print($2)}' | cut -d'%' -f1)
time=$(date)
if [ $(echo "$cpus>80.0" | bc) -eq 1 ];then
    echo "超过了阈值"
    echo "$cpus" "$time" >> monitor.log 
fi
ps -eo pid,%cpu,cmd --sort=-%cpu | head -4

sleep 10
done