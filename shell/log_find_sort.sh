#!/bin/bash
#第1题：日志分析和统计
#接收一个日志文件路径作为参数
#统计该日志文件中包含"ERROR"关键词的行数
#找出访问频率最高的前5个IP地址（假设IP在每行的第一个字段）
#如果文件不存在，输出"File not found"并退出

if [ ! -f "$1" ];then
    echo "file not found"
    exit 1
fi

line=$(cat $1 | grep "ERROR" | wc -l)
echo "行数为""$line"

awk '{print($1)}' "$1" | sort | uniq -c | sort -nr | head -5