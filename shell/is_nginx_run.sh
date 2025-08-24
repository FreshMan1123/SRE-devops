#!/bin/bash
#写一个脚本检查nginx进程是否运行，如果没有运行则启动它。

res=$(pgrep -x "nginx")
if [ -z "$res" ];then
    systemctl start nginx
fi
