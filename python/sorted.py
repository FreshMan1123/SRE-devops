#题目描述
#对于字符串 "aa vv cc 1 2 0 av ac 23",需要你将里面的数字给提取出来,然后将排序后的字符串放到末尾
#比如输出 "aa vv cc av ac 0 1 2 23"

import sys  
def sort(Testfile):
    num_char=""
    other_char=""
    for char_i in range(len(Testfile)):
        if(Testfile[char_i].isdigit()):
            num_char=num_char+Testfile[char_i]
        else:
            other_char+=Testfile[char_i]
        
    Testfile=other_char+" ".join(sorted(num_char))
    print(Testfile)

if __name__ =="__main__":
    Test="aa vv cc 1 2 0 av ac 23"
    sort(Test)