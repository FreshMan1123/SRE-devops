import sys

def fast_sorted(nums):
    if(len(nums)<=1):
        return nums
    middle=nums[len(nums)//2]
    nums_left=[x for x in nums if x<middle]
    nums_middle=[x for x in nums if x==middle]
    nums_right=[x for x in nums if x>middle]
    return fast_sorted(nums_left)+nums_middle+fast_sorted(nums_right)

if __name__=="__main__":
    nums=[3,2,1,5,6,2,31,5,3]
    nums=fast_sorted(nums)
    print(nums)