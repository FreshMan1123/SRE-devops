#!/bin/bash
#写一个脚本删除/tmp目录下7天前创建的所有
#.tmp文件，并统计删除了多少个文件。 

file=$(find /tmp -name "*.tmp" -ctime +7 | wc -l)

find /tmp -name ".tmp" -ctime +7 -delete
echo "删除文件数为:$file"