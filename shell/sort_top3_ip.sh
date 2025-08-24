#!/bin/bash

awk '{
    print $1

}' "access.log" | sort | uniq -c | sort -nr | head -3