import sys
from collections import defaultdict

from sorted import sort


#给定一组非负整数 nums，重新排列每个数的顺序（每个数不可拆分）使之组成一个最大的整数。
#注意：输出结果可能非常大，所以你需要返回一个字符串而不是整数。
#输入：nums = [10,2]
#输出："210"
class Solution(object):
    def largestNumber(self, nums):
        for len_num1 in range(len(nums)-1):
            for len_num2 in range(len_num1+1,len(nums)):
                if str(nums[len_num1])+str(nums[len_num2])<str(nums[len_num2])+str(nums[len_num1]):
                    nums[len_num1],nums[len_num2]=nums[len_num2],nums[len_num1]
        res=""
        for num in nums:
            res+=str(num)
        print(res)
        return res




if __name__=="__main__":
    line=int(sys.stdin.readline().strip())
    for _ in range(line):
        nums=list(map(int,sys.stdin.readline().strip().split(',')))
        sloution=Solution()
        sloution.largestNumber(nums)
