import sys


def get_m(n,m):
    if n==0:
        return None
    elif n==1:
        return 1
    m=m%n
    return m

if __name__=="__main__":
    nums=list(map(int,sys.stdin.readline().strip().split()))
    m=get_m(nums[0],nums[1])
    print(m)