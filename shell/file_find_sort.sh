#!/bin/bash
#题目1：文件统计和排序
#写一个shell脚本，统计当前目录下所有.txt文件中单词出现的频率，
#并按频率从高到低排序输出前10个最常见的单词。要求使用awk、sort、uniq等命令组合。
               
find . -name "*.txt" | while read -r line;do
   cat "$line" |  tr -s ' ' '\n' ;done | sort | uniq -c | sort -nr | head -10