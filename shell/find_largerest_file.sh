#!/bin/bash
#题目： 写一个脚本，找出 /var/log 目录下大于 10MB 的文件，并按文件大小从大到小排序显示。
#显示文件大小（人类可读格式）
#显示文件路径
#按大小降序排列

cd /var/log

find -size +10M | sort -k2 -nr 
