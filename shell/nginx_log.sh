#有一个nginx访问日志文件access.log，格式如下：
#192.168.1.1 - - [10/Oct/2023:13:55:36 +0800] "GET /api/users HTTP/1.1" 200 1234
#192.168.1.2 - - [10/Oct/2023:13:55:37 +0800] "POST /api/login HTTP/1.1" 404 567
#192.168.1.1 - - [10/Oct/2023:13:55:38 +0800] "GET /api/orders HTTP/1.1" 500 890
#要求：写一个Shell脚本统计：
#访问量最多的前5个IP地址
#返回状态码为4xx和5xx的请求数量
#访问量最多的前3个API接口

awk '{
    print($1)
}' "access.log" | sort | uniq -c | sort -nr | head -5 

awk 'BEGIN{
    4xx=0
    5xx=0
}{
    
if($8 ~ /^[4]{1}[0-9]{2}$/){
    4xx+=1   
}
else if($8 ~ /^[5]{1}[0-9]{2}$/){
    5xx+=1   
}
}END{
    print("4XX:"4xx)
    print("5XX:"5xx)
}' “access.log”

awk '{
    print($6)
}' "access.log" | sort | uniq -c | sort -nr | head -3

