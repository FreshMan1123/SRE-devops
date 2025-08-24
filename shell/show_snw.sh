#!/bin/bash
#写一个脚本统计/var/log/nginx/access.log中每个小时的访问量，并按访问量降序排列。
# （提示：日志格式通常是 IP - - [时间] "请求" 状态码 大小）

awk '{hour=substr($4,5,6) count[hour]++} END{ for h in count{print(h,count[h])}}' "/var/log/nginx/access.log"