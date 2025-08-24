#!/bin/bash
#任务：当前目录下有大量的 .txt 文件，请写一个Shell脚本，将所有 .txt 文件的后缀名批量修改为 .log
##对于for来说，shell会自动帮我们遍历获取当前目录下所有*.txt，莫名有点像python的for。
##${file%.log}表示获取file参数的值，但是从.txt处把它截取，返回其.txt前面的值
for file in *.txt;do
    mv "$file" "${file%.txt}.log"
done


