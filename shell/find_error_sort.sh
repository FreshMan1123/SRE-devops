#!/bin/bash
file=$1
find "$1" -type f | while read -r line;do
    num=$(grep -c "error" "$line")
    echo "$line:$num Error"
done sort -t':' -k2 -nr