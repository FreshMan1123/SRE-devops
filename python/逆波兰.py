import sys


class Solution(object):
    def evalRPN(self, tokens):
        """
        :type tokens: List[str]
        :rtype: int
        """
        if tokens[0] in "+-*/":
            return None
        char=[]
        for num in tokens:
            print(char)
            if num=="+" or num=="-" or num=="*" or num=="/":
                a=int(char.pop())
                b=int(char.pop())
                if num=="+":
                    char.append(a+b)
                elif num=="-":
                    char.append(b-a)
                elif num=="*":
                    char.append(a*b)
                elif num=="/":
                    print("-------")
                    print(b)
                    print(a)
                    char.append(b/a)
            else:
                char.append(num)
        return char[0]
if __name__=="__main__":
    char_get=list(map(str,sys.stdin.readline().strip().split(',')))
    solution=Solution()
    char=solution.evalRPN(char_get)
    print(char)