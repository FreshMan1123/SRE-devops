#题目 4: 配置文件内容替换与格式化
#目标: 编写一个脚本来处理 key=value 格式的配置文件。
#config.txt 示例:
#status=active
#user=root
#comment=temp
#delete_me=true
#port=8080
#要求:
#对 config.txt 文件进行处理（建议先备份），删除所有注释行（以 # 开头）和包含 delete_me 的行。
#读取处理后的文件，并以 配置项: "key", 配置值: "value" 的格式输出每一行。

if [ ! -f "config.txt" ];then
    echo "failed"
    exit 1
fi
cp  config.txt config.txt.bak
touch temp.txt
awk '{
    if(! ($0 ~ /^\#/ || $0 ~ /delete/)){
        print($0)
    }
}' "config.txt" > “temp.txt”