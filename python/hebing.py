class Solution(object):
    def merge(self, intervals):
        """
        :type intervals: List[List[int]]
        :rtype: List[List[int]]
        """
        def mer(intervals):
            if len(intervals) <= 1:
                return intervals
            intervals.sort()
            have_same=0
            for n in range(1, len(intervals)):
                if n == len(intervals):
                    break
                if intervals[n][0] <= intervals[n - 1][1]:
                    if intervals[n][1] > intervals[n - 1][1]:
                        intervals[n - 1][1] = intervals[n][1]
                    have_same=1
                    mer(intervals[:n] + intervals[n + 1:])
                    print(intervals)

            return intervals

        inter = mer(intervals)
        return inter
if __name__=="__main__":
    solution=Solution()
    solution.merge([[1,3],[2,6],[8,10],[15,18]])