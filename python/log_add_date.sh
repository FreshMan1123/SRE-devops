#/bin/bash
#批量重命名文件,重命名指定目录
#要求：给所有文件加上日期前缀，变成20240101_file1.txt
file_path=$1
date=$date
cd $file_path
find -type f | awk -F'/' '{mv $2 "$date_$2" }'