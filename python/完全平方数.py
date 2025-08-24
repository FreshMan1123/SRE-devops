class Solution(object):
    def numSquares(self, n):
        """
        :type n: int
        :rtype: int
        """
        nums=[i*i for i in range(1,n+1) if i*i<=n]
        dp=[10000000]*(n+1)
        dp[0]=0
        for num in nums:
            for j in range(num,n+1):
                dp[j]=min(dp[j],dp[j-num]+1)
        return dp[n]
if __name__=="__main__":
    solution=Solution()
    char=solution.numSquares(1)
