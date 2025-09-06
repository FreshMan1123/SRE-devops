#!/bin/bash
#写一个端口扫描脚本，要求：
#从文件中读取IP:PORT列表（每行一个，格式如192.168.1.1:80）
#使用nc命令检测每个端口的连通性
#将无法连通的IP:PORT输出到failed_ports.txt
#将成功连通的输出到success_ports.txt
#最后统计成功率并显示（格式：成功X个，失败Y个，成功率Z%）

while read -r line;do
    ip=$(cut -d':' -f1)
    port=$(cut -d':' -f2)
    nc -z -w1 "$ip" "$port"
    if [ $? -eq 1];then
        echo "$line" >> failed_ports.txt
    else
        echo "$line" >> success_ports.txt
    fi  
done < "$1"

failed=$(cat "failed_ports.txt" | wc -l)
success=$(cat "success_ports.txt" | wc -l)
sus=$success/(($failed)+$success)*100
echo "成功:'$success'个，失败'$falied'个,成功率:'$sus'%"