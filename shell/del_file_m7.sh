#!/bin/bash

##场景：删除/tmp目录下所有7天前创建的.log文件，但要先列出这些文件让用户确认。 要求：写一个安全的删除脚本。

del_file=$(find /tmp -name "*.log" -ctime +7) 
echo "$del_file"
read -p "action:" action

if [ "$action" == "yes" ];then
   echo "$del_file" | while read -r line;do
                        rm -f "$line"
                      done 
fi