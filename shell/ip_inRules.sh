#!/bin/bash

input_file=$1

awk -F '.' '{
    if (NF != 4){
        print $0
        print "NO"
        next
    }
    for(i=1;i<=4;i++){
        if($i !~ /^[0-9]{1,3}$/ || $i<0 || $i>255 ){
            print "NO"
            print $1"."$2"."$3"."$4
            next
        }
        if(length($i)>1&&substr($i,1,1)=="0"){
            print "NO"
            print $1"."$2"."$3"."$4
            next
        }
    }

    print "YES"


}' "$input_file"