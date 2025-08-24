##给你一个整数数组 nums ，请你找出一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。
##子数组是数组中的一个连续部分。
##输入：nums = [-2,1,-3,4,-1,2,1,-5,4]
##输出：6
##解释：连续子数组 [4,-1,2,1] 的和最大，为 6 。
class Solution(object):
    def maxSubArray(self, nums):
        for i in range(1,len(nums)):
            #[-2，1，3，-5，6]
            nums[i]=max(nums[i-1]+nums[i],nums[i])
        return max(nums)


if __name__=="__main__":
    solution=Solution()
    nums=input()
    char=solution.maxSubArray(nums)
    print(char)



