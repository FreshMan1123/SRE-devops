import sys


class Solution(object):
    def subarraySum(self, nums, k):
        add_eq_k=0
        for i in range(len(nums)):
            current=nums[i]
            if(current==k):
                add_eq_k+=1
            for j in range(i+1,len(nums)):
                current+=nums[j]
                if (current == k):
                    add_eq_k += 1

        return add_eq_k


if __name__=="__main__":
    nums=list(map(int,sys.stdin.readline().strip().split(',')))
    k=int(sys.stdin.readline().strip())
    solution=Solution()
    add=solution.subarraySum(nums,k)
    print(add)