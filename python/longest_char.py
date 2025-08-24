class Solution(object):
    def longestCommonPrefix(self, strs):
        if(len(strs)==0):
            return ""
        elif (len(strs) == 1):
            return strs[0]
        same_char = strs[0]
        for x_num in range(1, len(strs)):
            if(len(same_char)>len(strs[x_num])):
                same_char=same_char[:len(strs[x_num])]
            for i in range(len(strs[x_num])):
                if (i > len(same_char)-1):
                    break
                if (same_char[i] != strs[x_num][i]):
                    same_char = same_char[:i]
                    continue
        return same_char

if __name__=="__main__":
    solution=Solution()
    str=["aacc","aacbb","aacc"]
    char=solution.longestCommonPrefix(str)
    print(char)