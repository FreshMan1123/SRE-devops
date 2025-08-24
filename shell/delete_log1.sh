#!/bin/bash
#场景：/tmp目录下有很多临时文件，需要清理3天前的文件。
#找出3天前创建的文件
#显示要删除的文件列表
#统计总共多少个文件，占用多少空间
cd $1
count=$(find ./ -ctime +3 | wc -l)
find ./ -ctime +3 -delete 