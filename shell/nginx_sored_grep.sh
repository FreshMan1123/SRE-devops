#!/bin/bash
#目标: 编写一个脚本
#脚本接受一个目录路径作为参数 ($1)。
#如果参数未提供或目录不存在，则退出。
#使用 find 查找该目录下所有在过去 7 天内被修改过的 .log 文件。
#对找到的每个文件，使用过滤出包含 "ERROR" 的行
#提取错误信息（假设错误信息是冒号后的部分，如 ERROR: Connection refused，提取 Connection refused）。
#最后，统计每种错误信息的出现次数
#并按次数从高到低 显示排名前 3 的错误。

if [ ! -d "$1" ];then
    echo "failed"
    exit 1
fi

find $1 --name="*.log" -mtime -7 | grep -i "ERROR" | awk -F"ERROR:" "{print($1)}" | sort | uniq -c | sort -nr | head -3