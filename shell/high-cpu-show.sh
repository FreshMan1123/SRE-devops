#!/bin/bash  
#任务: 编写一个 shell 脚本，该脚本需要：
#查找当前系统中 CPU 使用率超过 50% 的所有进程。
#输出这些进程的 PID、CPU使用率、以及对应的命令。
#按 CPU 使用率从高到低排序。
#如果找不到符合条件的进程，则输出 "No high CPU usage process found."


解析：一个ps -eo 控制输出，加个sort进行cpu排序，最后来个awk进行文本处理

ps -eo pid,%cpu,cmd --sort=-$cpu | awk 'NR>1 && $2>50'