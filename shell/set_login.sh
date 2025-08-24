#!/bin/bash
#有一个包含用户登录记录的文件login.log，格式为：
#2024-01-01 10:30:15 user1 login success
#2024-01-01 10:35:22 user2 login failed
#写脚本统计每个用户的登录成功次数和失败次数。

awk '{
    user=$3
    status=$5
    user[status]++
}END{
    for i in user:
        print(i,i[success],i[failed])
}' "login.log" 