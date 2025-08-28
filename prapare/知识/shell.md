# Shell 知识总结
$? - 上一个命令的退出状态码
$$ - 当前Shell进程的PID
$! - 最后一个后台进程的PID
awk 中的语法和c相似，和shell不同
NR 当前行
NF 当前行的字段数量
END块应该在主块外面，不应该嵌套在里面

对字符进行处理，awk里的方法取2到11个字符
substr($1,2,11)

常用的排序组合拳
awk '{print $1}' "XX.log" | sort | uniq -c | sort -nr

sort按照指定列进行排序
sort -k1 表示按第一列进行排序
sort -k1，2 表示按第一列和第二列的组合字段进行排序

awk循环,-F表示分隔符
awk -F':' '{}' "$file_name"

判断文件的行数
wc -l file.txt
-f<script文件> 指明要处理的文件
-n或--quiet仅显示script处理后的结果.

赋值不用$，取值要
比如 num=$num1

让用户输入
read user_name

sed命令
sed -n '2,5d' file.txt 表示删除2，5行
参数：
在sed中，动作前表示要处理的行
a ：新增， a 的后面可以接字串，而这些字串出现在下一行
c ：取代， c 的后面可以接字串
d ：删除
i ：插入， i 的后面可以接字串，而这些字串出现在上一行
p ：打印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行
s ：取代，可以直接进行取代的工作

找出当前系统上消耗CPU最高的 前5个进程。并且只显示pid，cpu利用率和完整命令
sort=-%cpu表示按cpu逆序排序
ps -eo pid,%cpu,cmd --sort=-%cpu | head -5

删除创建时间在指定天数前的文件，-delete表示删除
-ctime+3 表示三天以及三天之前的文件
find -ctime +3 -delete

使用for命令来进行当前目录的遍历
for file in *.log；do....done  也就是对当前目录每个文件都遍历

如果想要在if中使用命令
比如说 if [ -n "$(pgrep $process)" ]
需要用"$()" 表示该这是个命令而非字符串

shell默认全部遍历都是全局变量，设置去局部变量需要用local函数

如何进行浮点数比较
$(echo "$metric > 1.0" | bc) -eq 1

awk 中进行字符裁剪
substr($15,2,20) 表示第15个数里的第2，19个字符，左闭右开

根据进程名判断进程是否存在
pgrep -x 进程名

count是awk的自定义初始化数组，默认可以用任意值做索引，同时该索引的value是0

if中[ -d "$1" ] 判断$1是否是目录

find 中-ctime -x创建x天内的文件，-mtime -x表示x天内有修改

假设有个变量count，想在非awk中对其进行算术运算
$((count+1))

输出重定向中> 和 >> 的区别
>表示覆盖
>>表示追加写入
## 基础语法

把标准输入传给后面的命令作为参数，使用xargs
比如 
# xargs 把从管道收到的文件名列表，变成了 grep 的参数
find ... | xargs grep "ERROR"

grep进行特定文件行的读取
grep -n "error" *.txt 就是读取当前目录下所有行里error的文件
输出格式为： 文件名：出现行：行内容
2.txt:1:error

echo怎么输出变量
echo "超出阈值:${cpus}"

wc命令：用来统计行数，字数，字符数
wc -l file.txt 统计行数
wc -w 统计总字数
wc -c 统计总字符数

-f 表示判断文件是否为非空， ! -f 为空时进入
-d 判断目录是否非空， ! -d 为空是进入

最常用的find参数
# 基本用法
find 目录 -type f          # 找所有文件
find 目录 -name "*.txt"    # 找.txt文件
find 目录 -mtime +7        # 找7天前的文件
find -size +10M -exec ls -lh {} +  #大于10Mb的文件
 
最常用的grep参数
# 基本用法
grep "关键词" 文件          # 查找关键词
grep -c "关键词" 文件       # 统计行数
grep -n "关键词" 文件       # 显示行号
grep -i "关键词" 文件       # 忽略大小写
grep -r "关键词" 目录       # 递归查找

最常用的sort参数
# 基本用法
sort 文件                  # 按字母排序
sort -n 文件               # 按数字排序
sort -r 文件               # 降序排列
sort -nr 文件              # 数字降序


- `cut -d':' -f1` - 取以':'为分隔符后的第一列
- `tr -s ' ' '\n'` - 将所有空格替换为换行符，并压缩连续的换行符，用于将整行拆分成一行一个字母
然后再用sort + uniq -c + sort -nr进行统计
tr -s '' '\n' | sort | uniq -c | sort -nr

查找存在某个指定字符在文件中的行数
grep -c "$char" file
### 变量和参数
- `input_file=$1` - 如 `./xx.sh input`，将input这个文件赋给input_file
- `IFS=` - IFS字符分隔符，将其临时设为空值，用于精准操纵文件
- `(( ))` - 可兼容我们的运算符，同时会自动将我们的变量名转化为对应的$变量，更方便

### 条件判断
- `-z` - 表示zero，为空判断，当字符串是空时为真
- `-n` - 表示no-zero，为非空判断，当字符串是非空时为真
- `-e` - 文件存在判断
- 在条件判断中，应该给变量加上双引号，如 `if [ -n "$line" ]`

## 文件操作

### 读取文件
- `read [选项] 变量名`
- `read -r line` - 表示预防反斜杠被解释成转义字符，同时从输入源读取一行来存储到line
- `while IFS= read -r line || [ -n "$line" ]; do` - 读取文件的完整语法

### 文件内容查看
- `head -5 $input_file` - 查看并输出文件前五行
- `tail -5 $input_file` - 查看文件并输出后五行
- `sed -n "5,20p" $input_file` - 查看文件并输出第5到20行

### 文件统计
- `wc -l nowcoder.txt` - wc (word count) 是一个计数工具
  - `-l` 参数指定只计算行数
  - 输出格式为：行数 文件名，例如：15 nowcoder.txt

## 文本处理

### 字符串操作
- `cut -d':' -f1` - 取以':'为分隔符后的第一列
- `tr -s ' ' '\n'` - 将所有空格替换为换行符，并压缩连续的换行符
- `(( ${#line} < 8 ))` - 取字符串长度，`${#line}` 是特殊参数扩展，需要使用`${#line}`把它解析成命令

### 文本过滤和排序
- `uniq -c` - 梳理相邻重复的单词项，输出格式：数字 字符
- `uniq -d` - 只显示重复行
- `sort` - 排序
- `sort -n` - 按数字排序

## 网络工具

### 端口扫描
- `nc -z -w1 "$ip" "$port"` - 端口扫描工具，例如：`nc -z -w1 192.168.1.1 80`
- `! nc -z -w1` - 表示将结果反转，扫描返回错误时进入if

请简述在 Shell 脚本中，局部变量和全局变量的区别是什么？如何在函数内定义局部变量
局部变量是指作用在局部的函数作用域中的变量， 函数外不可访问。shell默认全部变量都是全局变量。想在函数内部定义局部变量需要用local方法
---

## 实际应用示例

### 1. 输出文件行数
```bash
#!/bin/bash
if [ ! -e nowcoder.txt ]; then
    echo "bucunzai"
    return
fi
line=$(wc -l nowcoder.txt | awk '{print $1}') 
echo $line
exit
```

### 2. 端口扫描脚本
```bash
#!/bin/bash
input_file=$1
if [ ! -e "$input_file" ]; then
    echo "error"
    exit 1
fi
while IFS= read -r line || [ -n "$line" ]; do
    ip=$(echo "$line" | cut -d':' -f1)
    port=$(echo "$line" | cut -d':' -f2)
    if ! nc -z -w1 "$ip" "$port" &>/dev/null; then
        echo "$line"
    fi
done < "$input_file"
exit 0
```

### 3. 输出7的倍数
```bash
#!/bin/bash
num=0
while (( num<=500 )); do
    if (( num%7==0 )); then
        echo $num
    fi
    ((num++))
done 
exit 0
```

### 4. 输出第5行内容
```bash
#!/bin/bash
if [ ! -e $nowcoder ]; then
    echo "666"
    exit 1
fi
sed -n "5,5p" $nowcoder
exit 0
```

### 5. 输出空行行号
```bash
#!/bin/bash
if [ ! -e "nowcoder.txt" ]; then
    echo "666"
    exit 1
fi
num=1
while IFS= read -r line || [ ! -n $line ]; do
    if [ -z $line ]; then
        echo "$num"
    fi
    ((num++))
done < "nowcoder.txt"
exit 0
```

### 6. 去掉空行
```bash
#!/bin/bash
if [ ! -e $nowcoder ]; then
    echo "366"
    exit 1
fi
while IFS= read -r line || [ -n "$line" ]; do
    if [ -n "$line" ]; then
        echo "$line"
    fi
done < nowcoder.txt
exit
```

### 7. 统计字母数小于8的单词
```bash
#!/bin/bash
if [ ! -e $nowcoder ]; then
    echo "666"
    exit 1
fi
cat "nowcoder.txt" | tr -s ' ' '\n' | while read -r line; do
    if (( ${#line} < 8 )); then
        echo "$line"
    fi
done
exit 0
```

### 8. 统计内存百分比总和
```bash
#!/bin/bash
cat "nowcoder.txt" | awk 'NR > 1 {sum+=$4} END {print sum}'
exit 0
```

### 9. 统计单词出现次数
```bash
#!/bin/bash
cat "nowcoder.txt" | tr -s ' ' '\n' | sort | uniq -c | sort -n | awk {'print $2 $1'}
```

### 10. 检查重复列并排序
```bash
#!/bin/bash
cat "nowcoder.txt" | awk '{print $2}' | sort | uniq -cd | sort -n
```

---


给定一个包含电话号码列表（一行一个电话号码）的文本文件 file.txt，写一个单行 bash 脚本输出所有有效的电话号码。

你可以假设一个有效的电话号码必须满足以下两种格式： (xxx) xxx-xxxx 或 xxx-xxx-xxxx。（x 表示一个数字）

你也可以假设每行前后没有多余的空格字符。
awk '{
    if ($1 ~ /^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$/ || $1 ~ /^[1-9]{1}[0-9]{2}-[1-9]{1}[0-9]{2}-[1-9]{1}[0-9]{3}$/){
        print($1)
    }
}' "file.txt"

给定一个文件 file.txt，转置它的内容。

你可以假设每行列数相同，并且每个字段由 ' ' 分隔。
#!/bin/bash
awk '{
    for (i=1;i<=NF;i++){
        if(NR==1){
            row[i]=$i
        }
        else{
            row[i]=row[i] " " $i 
        }
    }
}
END{
    for(i=1;i<=NF;i++){
         print(row[i])
    }
}' "file.txt"


shell命令 删除给定目录下的已".log" 为结尾的文件，要求只能用一条指令

## 今天学习的shell知识

### 1. 定时任务 (crontab)

#### 基本语法
```bash
# 编辑crontab
crontab -e

# 查看当前crontab
crontab -l

# 删除当前用户的crontab
crontab -r

# 从标准输入导入crontab
echo "20 18 2 8 * ./hello.sh" | crontab -
```

#### 时间格式
```
分钟 小时 日期 月份 星期 命令
```

#### 常用示例
```bash
# 每天凌晨2点执行
0 2 * * * /path/to/script.sh

# 每小时执行一次
0 * * * * /path/to/script.sh

# 每周一凌晨3点执行
0 3 * * 1 /path/to/script.sh

# 每5分钟执行一次
*/5 * * * * /path/to/script.sh
```

#### 特殊字符
- `*` - 表示任意值
- `,` - 表示多个值（如：1,3,5）
- `-` - 表示范围（如：1-5）
- `/` - 表示间隔（如：*/5表示每5个单位）

### 2. 文件行数统计

#### wc命令
```bash
# 统计文件行数
wc -l filename

# 只显示行数，不显示文件名
wc -l < filename

# 统计多个文件
wc -l file1.txt file2.txt

# 结合find使用
find /path -name "*.log" -exec wc -l {} \;
```

### 3. 文本搜索 (grep)

#### 基本语法
```bash
grep [选项] 模式 文件名
```

#### 常用选项
```bash
grep -i pattern file    # 忽略大小写
grep -v pattern file    # 反向匹配
grep -n pattern file    # 显示行号
grep -c pattern file    # 只显示匹配行数
grep -r pattern dir     # 递归搜索
grep -f pattern_file target_file  # 从文件读取模式
```

#### 实际应用
```bash
# 用echo输出作为搜索模式
echo "aa" | grep -f - target_file

# 搜索多个文件
grep "pattern" *.log

# 结合管道使用
ps aux | grep nginx
```

### 4. 文件排序 (sort)

#### 基本用法
```bash
sort file              # 正序排序
sort -r file           # 逆序排序
sort -n file           # 按数字排序
sort -nr file          # 按数字逆序排序
sort -t: -k2 file      # 按第2列排序，分隔符为冒号
```

### 5. 管道和重定向

#### 管道符 (|)
```bash
# 将前一个命令的输出作为后一个命令的输入
echo "content" | grep "pattern"
cat file | wc -l
```

#### 重定向
```bash
echo "content" > file    # 覆盖写入
echo "content" >> file   # 追加写入
echo "content" | file    # 错误！这不是重定向语法
```

### 6. 实际脚本示例

#### 统计.log文件行数并排序
```bash
#!/bin/bash
# 统计指定目录下所有.log文件的行数，按行数从大到小排序

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Directory $1 does not exist"
    exit 1
fi

# 查找所有.log文件并统计行数
find "$1" -name "*.log" -exec wc -l {} + 2>/dev/null | \
    awk 'NR>1 {print $2 ":" $1}' | \
    sort -t: -k2 -nr || echo "No log files found"
```

#### 删除.log文件
```bash
#!/bin/bash
# 删除指定目录下所有.log文件

find "$1" -name "*.log" -delete
```

### 7. 重要注意事项

#### 变量引用
```bash
# 正确写法
if [ -z "$variable" ]; then
    echo "$variable"
fi

# 错误写法
if [ -z $variable ]; then
    echo $variable
fi
```

#### 文件存在性检查
```bash
# 检查文件是否存在
if [ -f "$file" ]; then
    echo "File exists"
fi

# 检查目录是否存在
if [ -d "$dir" ]; then
    echo "Directory exists"
fi
```

#### 参数检查
```bash
# 检查参数数量
if [ $# -ne 1 ]; then
    echo "Usage: $0 <parameter>"
    exit 1
fi
```


#!/bin/bash
while true;do
    metric=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    if [ $(echo "$metric > 1" | bc) -eq 1 ];then
        echo "CPU利用率${metric}"
    fi
    sleep 10
done


# bc是linux中进行带浮点数判断的方法
# echo "1.00 > 1" | bc 即可对比，但为真时返回1，为假返回0，但需要注意 
# 需要一个-eq来进行真值判断