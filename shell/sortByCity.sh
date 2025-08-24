#/bin/bash
awk -F':' '{
    print $1

}' "users.txt" | sort | uniq -c | sort -nr | awk '{ pinrt $2 $1 }'