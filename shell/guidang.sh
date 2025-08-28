#题目 3: 文件清理与归档
#目标: 编写一个文件清理与归档脚本。
#脚本需要确保一个名为 archive 的归档目录存在于当前工作目录下，如果不存在就自动创建。
#找出当前目录中所有修改时间超过30天并且文件大小超过20MB的文件。
#将所有找到的文件移动到 archive 目录，并打印出被移动的文件名。
mdkir archive
find . -mtime +30 -size +20M | while read -r line;do echo "$line";mv $line archive done

