import sys

def get_min_x(x,y,m):
    if(x<=m and y<=m):
        return min(x,y)
    elif(x>m and y<=m):
        return x
    else:
        return y

if __name__=="__main__":
    n=list(map(int,sys.stdin.readline().strip().split()))
    all_add=0
    for _ in range(n[0]):
        nums=list(map(int,sys.stdin.readline().strip().split()))
        all_add+=get_min_x(nums[0],nums[1],n[1])
    print(all_add)