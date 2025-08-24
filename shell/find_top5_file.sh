#!/bin/bash
#查找系统中占用最大的5个文件

find . -type f -exec du -h {} + | sort -hr | head -5