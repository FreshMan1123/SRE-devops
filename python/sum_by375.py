import sys
from collections import defaultdict
from email.policy import default


def sum_by3(nums):
    char1=defaultdict(int)
    char2=defaultdict(int)
    for num in str(nums):
        char1[num]+=1
    n=375
    i=1
    while n<100000000:
        for num in str(n):
            char2[num]+=1
        if(char2==char1):
            return n
        else:
            print(char1)
            print(n)
            print(char2)
            print('-----')
            char2=defaultdict(int)
            n+=375


if __name__=="__main__":
    num=int(sys.stdin.readline())
    n=sum_by3(num)
    print(n)