#!/bin/bash
#题目： 写一个shell脚本，统计指定目录下所有.log文件的行数，并按照行数从大到小排序输出。
#要求：
#脚本接受一个目录路径作为参数
#输出格式：文件名:行数
#如果没有找到.log文件，输出"No log files found"
# 计算指定文件行数的方法，wc -l < $line
# 有一部分命令可以用管道符作标准输入
touch line_file
log_file=$(find "$1" -name "*.log")
if [ -z $log_file ];then
    echo "NO LOG FILES FOUND"
    exit 1
while read -r line;do
    log_line=$(wc -l < $line)
    echo "$log_line $line" >> "$line_file" 
done < "$log_file"
sort -nr "$line_file"
awk '' '{
    print $2":"$1
}'  "$line_file"

