#!/bin/bash
#有一个access.log文件，如何统计访问量最多的前5个IP地址？

awk '{print($1)}' "access.log" | sort | uniq -c | sort -nr | head -5