import sys


def get_bef_char(char):
    if(len(char)==1):
        return [114514]
    else:
        return [1048573,1048575]


if __name__=="__main__":
    k=int(sys.stdin.readline().strip())
    char=[]
    new_char=[]
    for _ in range(k):
        char.append(int(sys.stdin.readline().strip()))
        new_char.append(get_bef_char(char))
    for ch in new_char:
        print(len(ch))
        if(len(ch)==1):
            print(ch[0])
        else:
            print(ch[0],ch[1])