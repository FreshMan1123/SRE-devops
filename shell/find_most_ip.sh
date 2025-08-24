#日志分析
#场景：nginx访问日志分析，统计访问量最高的前5个IP地址
# 日志格式示例：
#192.168.1.100 - - [13/Aug/2025:17:52:26 +0800] "GET /index.html HTTP/1.1" 200 1024

awk '{
    print($1)
    }' "nginx.log"| sort | uniq -c | sort -nr | head -5 | awk '{print $2}' 