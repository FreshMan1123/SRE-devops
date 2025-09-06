class Solution(object):
    def subsets(self, nums):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        temp=[]
        end_num=[]
        def backtrack(index,temp):
            if index==len(nums):
                return
            end_num.append(temp[:])
            for num in range(index,len(nums)):
                temp.append(nums[num])
                backtrack(index+1,temp)
                temp.pop()
        backtrack(0,temp)
        return end_num

if __name__=="__main__":
    solution=Solution()
    solution.subsets([1,2,3])