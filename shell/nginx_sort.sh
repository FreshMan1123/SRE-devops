#!/bin/bash
#127.0.0.1 zhangsan
#192.168.1.100 lisi  
#127.0.0.1 wangwu
#192.168.1.200 zhangsan
#统计访问次数最多的前10个IP
#统计每个用户名出现的次数

awk '{
    print($1)
}' "nginx.log" | sort | uniq -c | sort -nr | head -10

awk '{
    print($2)
}' "nginx.log" | sort | uniq -c 