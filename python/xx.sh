#!/bin/bash
file=$1
if [ -z "$file" ];then
  exit 1
wc -l "$file" | awk '{print $1}')