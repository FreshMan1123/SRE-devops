class Stack:
    def __init__(self):
        self.items=[]
    def push(self,num):
        self.items.append(num)
    def pop(self):
        if len(self.items)==0:
            print("error,size is 0")
            return False
        char_a=self.items.pop()
        return char_a
    def size(self):
        return len(self.items)


class Solution(object):
    def isValid(self, s):
        """
        :type s: str
        :rtype: bool
        """
        if len(s)<=1:
            print("false")
            return False
        if(s[0]=="}" or s[0]==")" or s[0]=="]"):
            return False
        stack = Stack()
        dict1={")":"(","}":"{","]":"["}
        for char in s:
            if(char=="(" or char=="{" or char=="["):
                stack.push(char)
            else:
                char_a=stack.pop()
                if(dict1[char]!=char_a):
                    print("false")
                    return False
        if(stack.size()>0):
            print("false")
            return False
        else:
            print("true")
            return True


if __name__=="__main__":
    num=input()
    solution=Solution()
    solution.isValid(num)