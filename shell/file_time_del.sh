#!/bin/bash
#第3题：文件清理和定时任务
#清理指定目录下7天前创建的.log和.tmp文件
#统计清理前后的文件数量变化
#将清理结果写入cleanup.log（包含时间戳、清理的文件数量）
#设置crontab让该脚本每天凌晨2点自动执行
#如果目录不存在，创建该目录


if [ ! -d "$1" ];then
    mkdir $1
fi  
del_file=$(find "$1" \(-name "*.log" -o "*.tmp"\) --ctime=+7 | wc -l) 
find "$1" \(-name "*.log" -o "*.tmp"\) --ctime=+7 -delete
echo "$(date)删除了$del_file个文件" >> cleanup.log
