#输入：head = [3,2,0,-4], pos = 1
#输出：返回索引为 1 的链表节点
#解释：链表中有一个环，其尾部连接到第二个节点。
import sys


class ListNode(object):
     def __init__(self, x):
         self.val = x
         self.next = None

class Solution(object):
    def detectCycle(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        slow=head
        fast=head
        temp=head
        have_round=0
        res=set()
        while fast and fast.next:
            slow=slow.next
            fast=fast.next.next
            if slow==fast:
                have_round=1
                break
        if have_round==0:
          return None
        else:
            while 1==1:
              if temp not in res:
                res.add(temp)
                temp=temp.next
              elif temp in res:
                return temp

if __name__=="__main__":
     case=int(sys.stdin.readline().strip())
     solution = Solution()
     for _ in range(case):
         num=list(map(int,sys.stdin.readline().strip().split(',')))
         pos=int(sys.stdin.readline().strip())
         head=ListNode(-1)
         temp=head
         temp1=head
         for x in range(len(num)):
             x1=ListNode(num[x])
             temp.next=x1
             temp=temp.next
             if x==len(num)-1:
                 for _ in range(pos):
                     temp1=temp1.next
                 temp.next=temp1
         res=solution.detectCycle(head)
         print(res)

