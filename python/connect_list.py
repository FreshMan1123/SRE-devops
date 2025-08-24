import  sys
class ListNode(object):
     def __init__(self, x):
         self.val = x
         self.next = None

class Solution(object):
    def getIntersectionNode(self, headA, headB):
        p=headA
        s=set()
        while p:
            s.add(p)
            p=p.next
        q=headB
        while q:
            if q in s:
                return q
            else:
                q=q.next
        return None

if __name__=="__main__":
    t_case=int(sys.stdin.readline().strip())
    for _ in range(t_case):
        listA=list(map(int,sys.stdin.readline().strip().split(',')))
        listB=list(map(int,sys.stdin.readline().strip().split(',')))
        headA=ListNode(-1)
        headB=ListNode(-1)
        for s in listA:
            temp_A=ListNode(s)
            headA.next=temp_A
        for s in listB:
            temp_B=ListNode(s)
            headB.next=temp_B
        headA=headA.next
        headB=headB.next
        solution=Solution()
        q=solution.getIntersectionNode(headA, headB)
        print(q)