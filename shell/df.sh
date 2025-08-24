#!/bin/bash
#题目3：磁盘清理脚本（面试版）
#要求： 写一个脚本清理指定目录下的老旧文件
#具体要求：
#检查当前磁盘使用率
#如果使用率超过80%，删除指定目录下7天前的.log文件
#清理后再次显示磁盘使用率
#输出清理了多少个文件
# 获取磁盘使用率百分比（去掉%号）
used=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
echo "当前磁盘使用率: ${used}%"

if [ $used -gt 80 ]; then
    echo "开始清理..."
    # 统计要删除的文件数量
    count=$(find /tmp -name "*.log" -mtime +7 | wc -l)
    # 删除7天前的.log文件
    find /tmp -name "*.log" -mtime +7 -delete
    echo "清理了 $count 个文件"
    
    # 再次检查磁盘使用率
    used_after=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo "清理后磁盘使用率: ${used_after}%"
else
    echo "磁盘使用率正常，无需清理"
fi
