#!/bin/bash
#第1题：文件处理和统计综合题
#假设你有一个名为access.log的Web服务器访问日志文件，格式如下：
#192.168.1.100 GET /index.html 200
#192.168.1.101 POST /api/login 200  
#192.168.1.100 GET /about.html 404
#192.168.1.102 GET /index.html 200
#192.168.1.101 GET /index.html 200
#请写一个shell脚本完成以下任务：
#检查文件是否存在，不存在则输出"File not found"并退出
#统计总访问次数（总行数）
#统计每个IP地址的访问次数，按访问次数降序排列
#找出访问次数最多的IP地址

if [ ! -f "access.log" ];then
    echo "File not found"
    exit 1
fi
line=$(wc -l "access.log")
echo "line:"$line   
awk '{print($1)}' "access.log" | sort | uniq -c | sort -nr | head -1 
