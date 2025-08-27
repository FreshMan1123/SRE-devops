#!/bin/bash
#综合题 1：日志分析与报告生成
#背景：假设你是一名SRE工程师，需要定期分析服务器上的应用日志，并生成一份错误报告。日志文件都存放在某个目录下，文件名以 .log 结尾。
#INFO: User 'admin' logged in from 192.168.1.10
#ERROR: Failed to connect to database. client_ip=192.168.1.25
#WARN: Disk space is running low.
#ERROR: Null pointer exception at module 'payment'. client_ip=192.168.1.25
#INFO: Request processed successfully.
#ERROR: Timeout while fetching data from API. client_ip=192.168.1.30
#脚本接受一个目录路径作为命令行参数 ($1)。
#检查：
#脚本运行时，参数数量是否正确（必须为1个）。
#传入的参数是否是一个真实存在的目录。
#如果检查失败，则输出错误信息并退出。
#查找与过滤：
#使用 find 命令找出指定目录下所有近7天内被修改过的 .log 文件。
#对于找到的每一个日志文件，统计其中包含 "ERROR" (忽略大小写) 的总行数。
#数据提取与处理：
#从包含 "ERROR" 的行中，使用 awk 或 sed/cut 提取 client_ip= 后面的IP地址。
#统计每个IP地址出现的次数。
#生成报告：
#将统计结果输出到一个名为 error_report.txt 的文件中。
#报告格式为：出现次数 IP地址，例如 2 192.168.1.25。
#报告内容需要按照错误次数进行降序排列。
#最终输出：脚本执行完毕后，在屏幕上打印 error_report.txt 的前5行内容，并显示总共处理了多少个日志文件。
if [ -z $1 ];then
    echo "null"
    exit 1
fi

real_file=$(find $1 --name "*.log" -ctime +7)
count=0
echo "$real_file" | while read -r line;do
    num=$(grep "ERROR" "$line" | wc -l)
    echo "num:""$num"
    awk -F" client_ip=" "{print($2)}" "$line" | sort | uniq -c | sort -nr >  error_report.txt
    head -5  error_report.txt
    count="$count"+1
done



 
