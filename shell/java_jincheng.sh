#!/bin/bash
#场景：服务器上运行着多个Java进程，需要找出占用内存最多的Java进程。
#找出所有Java进程
#按内存使用量排序
#显示进程ID、内存使用量和启动命令
ps -eo pid,%mem,cmd --sort=-%mem | grep "java"