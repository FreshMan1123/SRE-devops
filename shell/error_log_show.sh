#!/bin/bash
#2023-10-10 14:30:15 ERROR Database connection failed
#2023-10-10 14:30:16 WARN Memory usage high
#2023-10-10 14:30:17 ERROR Disk space low
#统计ERROR级别的日志条数
#统计WARN级别的日志条数
#找出最近10条ERROR日志

awk 'BEGIN{
    ERROR=0
    WARN=0
}{
    if($3=="ERROR"){
        ERROR+=1
    }
    else if($3=="WARN"){
        WARN+=1
    }
}
END{
    print("ERROR:"ERROR)
    print("WARN:"WARN)
}' "unsuccess.log"

awk '{
    if($3=="ERROR"){
        print($0)
    }
}' "unsuccess.log" | sort -k1 -nr |head -10