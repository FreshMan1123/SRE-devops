#!/bin/bash
#192.168.1.1 2024-01-01 /index.html
#192.168.1.2 2024-01-01 /login.php
#192.168.1.1 2024-01-01 /home.html
#要求：统计每个IP的访问次数
file=$1
awk '{print $1}' "$file" | sort | uniq -c | sort -nr
