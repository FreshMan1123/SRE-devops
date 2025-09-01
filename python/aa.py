import sys

def eat_candy(happy,candy,now_happy):
    have_all=0
    for c in candy:
        have_all+=c
    if(have_all-len(candy)>=happy):

if __name__=="__main__":
    s=sys.stdin.readline().strip().split()
    num=list(map(int,sys.stdin.readline().strip().split()))
    print(2)