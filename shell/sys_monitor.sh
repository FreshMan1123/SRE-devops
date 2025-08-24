#!/bin/bash
#题目3：服务状态检查
#场景：写一个简单脚本检查nginx服务状态。
#检查nginx进程是否运行
#检查80端口是否监听
#如果服务异常，输出错误信息

monitor=$(lsof -i:80)
if [ -z "$monitor" ];then
    echo "error:80 is null"
fi 

systemctl status nginx
if [ $?==1 ];then
    echo "system is be down"
fi  