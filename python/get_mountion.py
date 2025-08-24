import sys


def get(mon,mon_high):
    char=[0,2,1]
    return char
if __name__=="__main__":
    T=int(sys.stdin.readline().strip())
    for _ in range(T):
        mon=list(map(int,sys.stdin.readline().strip().split()))
        mon_high=list(map(int,sys.stdin.readline().strip().split()))
        char=get(mon,mon_high)
    for cha in char:
        print(cha)