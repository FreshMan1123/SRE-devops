#!/bin/bash
#请编写一个 shell 脚本，统计 access.log 文件中访问次数最多的前 5 个 IP 地址，
#并按从多到少的顺序列出它们的访问次数和 IP 地址。
#127.0.0.1 - - [21/Aug/2025:17:50:01 +0800] "GET /index.html HTTP/1.1" 200 150 "-" "curl/7.68.0"
#8.8.8.8 - - [21/Aug/2025:17:50:05 +0800] "GET /api/v1/data HTTP/1.1" 404 28 "-" "Mozilla/5.0"
#127.0.0.1 - - [21/Aug/2025:17:50:08 +0800] "POST /login HTTP/1.1" 200 12 "-" "curl/7.68.0"
#114.114.114.114 - - [21/Aug/2025:17:50:12 +0800] "GET /static/js/main.js HTTP/1.1" 200 8976 "-" "Mozilla/5.0"
#8.8.8.8 - - [21/Aug/2025:17:50:15 +0800] "GET /api/v1/data HTTP/1.1" 404 28 "-" "Mozilla/5.0"
#127.0.0.1 - - [21/Aug/2025:17:50:20 +0800] "GET /favicon.ico HTTP/1.1" 200 150 "-" "curl/7.68.0"

awk 'print($1)' "access.log" | sort | uniq -c | sort -nr | head -5