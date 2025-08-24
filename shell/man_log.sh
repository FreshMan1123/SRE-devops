#!/bin/bash
#写一个脚本统计当前目录下所有 .log 文件的总行数。
num_all=0
for file in "*.log";do
    num=$(wc -l "$file" | cut -d' ' -f1)
    num_all=$((num+num_all))
done

echo "$num_all"