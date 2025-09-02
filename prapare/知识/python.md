# Python 知识总结

## 基础语法知识点

py中的for和while区别很大，
for num in nums会默认遍历这个数组
而while num in nums 只是做这个条件判断，num不会改变，也不会默认遍历数组

str.isdigit()方法判断是不是字符串是不是由数字组成

初始化一个集合（哈希表）。十分省时间，但是里面不能有重复值
num=set()
集合的填充方法
num.add
w


如果定义一个非局部变量（nonlocal）
def del_1(n,d,nums):
    max_char_tracker=0
    def del_num(n,d,nums):
        nonlocal max_char_tracker

针对需要向零取整的除法，python无论是/或者//都不是向零取整，要使用
operator.truediv(b,a)

有key怎么求value
d.get(key)
如何对字典排序,这个是返回的是key的队列，但是用value作为排序方式
list=sorted(dict1,key=dict1.get)

如何拿到递归最后调用的值，如mer为我们要递归的函数，则用return mer
 return mer(intervals[:n]+intervals[n+1:])
 同时我们应该在return后再加个return来做最后一次递归返回值的处理

么时候是引用，什么时候是副本？
引用的情况,也就是赋予list或者是node等对象
直接赋值：b = a (当a是可变对象时)
列表索引：last = merged[-1]

巧妙的数组轮转
num[:]表示清空数组，对数组自身修改
num[-k:]表示取最后k个元素
num[:-k]表示取除最后k个元素之外的元素

字符串倒转
my_string[::-1]

逆序遍历，第一个-1表示遍历到-1时停止，因为左闭右开，其实也就是0
第二个-1表示步长
for i in range(len(nums) - 1, -1, -1):
### 1. defaultdict的使用

```python
from collections import defaultdict

# 创建一个自动初始化的字典，当访问不存在key时会初始化
# 访问new key时，会自动创建一个空列表[]
group = defaultdict(list)

### 2. join()方法详解
```python
# join()是字符串的方法，用于将可迭代对象连接成字符串
# 语法：separator.join(iterable)

# 空字符串join() - 将字符列表连接成字符串
chars = ['a', 'e', 't']
result = ''.join(chars)  # "aet"

# 带分隔符的join()
words = ["hello", "world"]
result = " ".join(words)  # "hello world"

# 在字母异位词中的应用
word = "eat"
sorted_chars = sorted(word)  # ['a', 'e', 't']
sorted_word = ''.join(sorted_chars)  # "aet"
```
```

### 4. 地板除运算符 `//`
```python
# 地板除：向下取整
print(10 // 3)    # 3
print(10 // 2)    # 5
print(-10 // 3)   # -4 (注意负数的情况)

# 与浮点除法的区别
print(10 / 3)     # 3.3333333333333335
print(10 // 3)    # 3
```

### 5. 无穷大表示
```python
# 正无穷大
positive_infinity = float('inf')
print(positive_infinity)  # inf

# 负无穷大
negative_infinity = float('-inf')
print(negative_infinity)  # -inf

# 也可以用math模块
import math
print(math.inf)      # inf
print(-math.inf)     # -inf
```
### 7. 列表推导式和生成器表达式
```python
# 列表推导式
squared_list = [x * x for x in nums]

# 生成器表达式（更节省内存）
squared_generator = (x * x for x in nums)

# 在sorted()中使用生成器表达式
return sorted(x * x for x in nums)
```

### 8. range()函数详解
```python
# range(stop) - 从0开始，到stop-1结束
range(5)  # 0, 1, 2, 3, 4

# range(start, stop) - 左闭右开区间
range(3, 6)  # 3, 4, 5

# range(start, stop, step) - 指定步长
range(0, 10, 2)  # 0, 2, 4, 6, 8
```

### 9. 字符串操作
```python
# 字符串分割
text.split('分隔符')

# 判断字符是否为数字
if not test.isdigit():
    print("不是数字")

# 字符串计数
content.count("error")  # 统计error出现次数
```

## 文件操作

### 文件存在性检查
```python
import os
# 判断指定路径文件是否存在
if os.path.exists(file_name):
    print("文件存在")
else:
    print("文件不存在")
```

### 文件读取
```python
# 读取指定路径的文件
with open(file_name, 'r') as file:
    # 可以用 for line in file 进行遍历
    for line in file:
        print(line)
    
    # 或者读取整个文件
    content = file.read()
    error_count = content.count("error")
```

## 算法思想

### 滑动窗口思想
滑动窗口是一种重要的算法思想，适用于解决子数组/子字符串相关的问题。

**核心思想：**
- 使用两个指针（left和right）维护一个窗口
- 根据条件扩展或收缩窗口
- 在窗口满足条件时更新答案

**适用场景：**
- 寻找满足条件的最短/最长子数组
- 统计满足条件的子数组个数
- 字符串匹配问题

---

## 算法题目详解

### 1. 股票买卖问题

#### 题目描述
假设你有一个数组prices，长度为n，其中prices[i]是股票在第i天的价格，请根据这个价格数组，返回买卖股票能获得的最大收益

#### 约束条件
1. 你可以买入一次股票和卖出一次股票，并非每天都可以买入或卖出一次，总共只能买入和卖出一次，且买入必须在卖出的前面的某一天
2. 如果不能获取到任何利润，请返回0
3. 假设买入卖出均无手续费

#### 代码实现
```python
import sys

def self_buy(prices):
    max_get = 0
    min_price = prices[0]
    for price in prices:
        max_get = max(max_get, price - min_price)
        min_price = min(price, min_price)
    print(max_get)

if __name__ == "__main__":
    # 读取数组长度
    n = int(input())
    # 读取股票价格
    prices = list(map(int, input().split()))
    # 调用函数计算最大利润
    self_buy(prices)
```

#### 解题思路
- 遍历数组，维护一个最小价格变量
- 对于每个价格，计算当前价格与最小价格的差值
- 更新最大利润和最小价格
- 时间复杂度：O(n)，空间复杂度：O(1)

---

### 2. 跳台阶问题

#### 题目描述
一只青蛙一次可以跳上1级台阶，也可以跳上2级。求该青蛙跳上一个 n 级的台阶总共有多少种跳法（先后次序不同算不同的结果在在）。

#### 代码实现
```python
class Solution:
    def jumpFloor(self, number: int) -> int:
        # 针对边界值进行处理
        if number <= 2:
            return number
        else:
            a = 1
            b = 2
            for _ in range(3, number + 1):
                a, b = b, a + b
            return b
```

#### 解题思路
- 这是一个斐波那契数列问题
- f(n) = f(n-1) + f(n-2)
- 边界条件：f(1) = 1, f(2) = 2
- 使用迭代而不是递归，避免栈溢出

#### 扩展：可以跳1、2、3级台阶
```python
class Solution:
    def jumpFloor(self, number: int) -> int:
        if number <= 2:
            return number
        elif number == 3:
            return 4
        a = 1
        b = 2
        c = 4
        for _ in range(4, number + 1):
            a, b, c = b, c, a + b + c
        return c
```

---

### 3. IP地址验证

#### 题目描述
判断给定的IP地址是否合法

#### 代码实现
```python
from os import error
import re
from re import split
import sys

def error_ip(ip):
    num = 0
    result_ip = ip.split('.')
    if len(result_ip) != 4:
        print("NO")
        return
    for ip_word in result_ip:
        if not ip_word:
            print("NO")
            return
        if int(ip_word) < 0 or int(ip_word) > 255:
            print("NO") 
            return 0
        if not ip_word.isdigit():
            print("NO")
            return 0
        if len(ip_word) > 1 and ip_word[0] == '0':
            print("NO")
            return 0
    print("YES")
```

#### 解题思路
- 使用split('.')分割IP地址
- 检查分割后的数组长度是否为4
- 检查每个部分是否为数字
- 检查数字范围是否在0-255之间
- 检查是否有前导零

---

### 4. 二分查找

#### 题目描述
在有序数组中查找目标值，返回其索引，如果不存在返回-1

#### 代码实现
```python
class Solution(object):
    def search(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: int
        """
        right = len(nums) - 1
        left = 0
        while left <= right:
            middle = (right + left) // 2
            if nums[middle] > target:
                right = middle - 1
            elif nums[middle] == target:
                return middle
            else:
                left = middle + 1
        return -1
```

#### 解题思路
- 使用左右指针维护搜索区间
- 计算中间位置，与目标值比较
- 根据比较结果调整搜索区间
- 时间复杂度：O(log n)，空间复杂度：O(1)

---

### 5. 快速排序

#### 题目描述
实现快速排序算法

#### 代码实现
```python
def sort(self, nums):
    if len(nums) <= 1:
        return nums
    sort_middle = nums[len(nums) // 2]
    left = [x for x in nums if x < sort_middle]
    middle = [x for x in nums if x == sort_middle]
    right = [x for x in nums if x > sort_middle]
    return self.sort(left) + middle + self.sort(right)
```

#### 解题思路
- 选择基准元素（这里选择中间元素）
- 将数组分为三部分：小于基准、等于基准、大于基准
- 递归排序左右两部分
- 时间复杂度：平均O(nlogn)，最坏O(n²)
- 空间复杂度：O(n)

---

### 6. 有序数组的平方

#### 题目描述
给你一个按非递减顺序排序的整数数组 nums，返回每个数字的平方组成的新数组，要求也按非递减顺序排序。

**输入：** nums = [-4,-1,0,3,10]
**输出：** [0,1,9,16,100]

#### 代码实现
```python
class Solution(object):
    def sortedSquares(self, nums):
        return sorted(x * x for x in nums)
```

#### 解题思路
- 使用生成器表达式对每个元素平方
- 使用Python内置的sorted()函数排序
- 利用了Python的简洁语法特性
- 时间复杂度：O(nlogn)，空间复杂度：O(n)

---

### 7. 长度最小的子数组

#### 题目描述
给定一个含有 n 个正整数的数组和一个正整数 target。找出该数组中满足其总和大于等于 target 的长度最小的子数组，并返回其长度。如果不存在符合条件的子数组，返回 0。

**输入：** target = 7, nums = [2,3,1,2,4,3]
**输出：** 2
**解释：** 子数组 [4,3] 是该条件下的长度最小的子数组。

#### 代码实现
```python
class Solution(object):
    def minSubArrayLen(self, target, nums):
        """
        :type target: int
        :type nums: List[int]
        :rtype: int
        """
        left = 0
        all_num = 0
        min_needNum = len(nums)
        have = 0
        for right in range(len(nums)):
            all_num += nums[right]
            while all_num >= target:
                have = 1
                min_needNum = min(min_needNum, right - left + 1)
                all_num -= nums[left]
                left += 1
        all_in_num = 0
        if have == 0:
            return 0
        return min_needNum
```

#### 解题思路
**滑动窗口思想：**
- 当求得和值 < 目标值时，right索引就一直右移
- 当出现和值大于目标值的情况时，left索引就左移
- 同步更新最小子数组长度

**算法特点：**
- 这个算法会遍历到所有可以满足的窗口
- 因为我们有min取最小子数组的操作，所以哪怕符合条件的窗口被我们略过去了，后续还可以在主进程中找到这个最小值返回
- 时间复杂度：O(n)，空间复杂度：O(1)



给你一个字符串数组，请你将 字母异位词 组合在一起。可以按任意顺序返回结果列表。

from collections import defaultdict
class Solution(object):
    def groupAnagrams(self, strs):
        #创建一个自动初始化的字典，当访问不存在key时会初始化。访问new key时，会自动创建一个空列表[]
        group=defaultdict(list)
        for str in strs:
            #sorted 返回的是排序后的列表,比如说["a","b","c"].使用字符串方法join,自动迭代可迭代数据到指定字符里面
            sorted_str=''.join(sorted(str))
            # 用append的原因主要是group里面的value是列表，如[“abb”]，用append往列表后面扩展值
            group[sorted_str].append(str)
            #group.values()作用是列出字典里的所有key，value。需要转为list，转为list之后原key不再使用，改为01234索引
        return list(group.values())


很巧妙的的一种解法
采用排序后的 字符串作为key，在遍历指定数组后，可以将排序后的字符作为key，初始字符作为value进行定向传入




给定一个数组 nums，编写一个函数将所有 0 移动到数组的末尾，同时保持非零元素的相对顺序。

请注意 ，必须在不复制数组的情况下原地对数组进行操作。
class Solution(object):
    def moveZeroes(self, nums):
        for num in nums:
            if(num==0):
                nums.remove(num)
                nums.append(num)

#python中列表常用的方法，
remove()删除第一个值为x的元素
append()在末尾添加第一个值为x的元素


给定一个长度为 n 的整数数组 height 。有 n 条垂线，第 i 条线的两个端点是 (i, 0) 和 (i, height[i]) 。

找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。

返回容器可以储存的最大水量。

class Solution(object):
    def maxArea(self, height):
        """
        :type height: List[int]
        :rtype: int
        """
        if(len(height)<=1):
            return 0
        max_size=0
        size=0
        left=0
        right=len(height)-1
        while left!=right:
            size=min(height[left],height[right])*(right-left)
            max_size=max(max_size,size)
            if height[left]<height[right]:
                left+=1
            elif height[left]>height[right]:
                right-=1
            else:
                left+=1
        return max_size
一开始用的是双循环遍历，以当前元素a为起点，遍历其后的元素求面积，但是这样时间复杂度太高了。
后采用双指针，left指针指向最左边，right指向最右边，当left指向的元素＜右边指向的元素时，左指针右移
当右大于左边时，右指针左移，相同时随便一个指针移动。本质上来说就是一个概率性问题

1. 移动较高那边的板子
    移动后板子比原来高，但因为容水量看的是最低的板，水量下降
    移动后板子比原来低，下降

2. 移动较低那边的板子
    移动后板子比原来高，水量可能上升可能下降
    板子比原来低，一定下降。
我们做的就是只投概率，只做水量可能上升的方向，来减少我们需要排查的结果



给你一个整数数组 nums ，判断是否存在三元组 [nums[i], nums[j], nums[k]]
 满足 i != j、i != k 且 j != k ，同时还满足 nums[i] + nums[j] + nums[k] == 0 。
请你返回所有和为 0 且不重复的三元组。
输入：nums = [-1,0,1,2,-1,-4]
输出：[[-1,-1,2],[-1,0,1]]
解释：
nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0 。
nums[1] + nums[2] + nums[4] = 0 + 1 + (-1) = 0 。
nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0 。
不同的三元组是 [-1,0,1] 和 [-1,-1,2] 。
注意，输出的顺序和三元组的顺序并不重要。

理解：
1.先sorted进行数组排序，再进行数组遍历
2.如果第一个数大于0（递增数组），那么不可能和三数和等于0
，直接跳到下一次遍历
2.对第一个数进行去重，当i>0，同时num[i]==num[i-1]时，也要跳到下一次遍历
2.对left取i+1，对right取数组长度-1，相当于取当前值为底的左右两个区间
2.如果三数和等于0，那么需要分别做left和right的循环，循环掉重复的数
3.如果小于0说明left小了，left++
4.大于0说明right小了,right--
class Solution(object):
    def threeSum(self, nums):
        if(len(nums)<=3):
            if(nums[0]+nums[1]+nums[2]==0):
                return [nums]
            return []
        nums=sorted(nums)
        all_nums=[]
        for num_i in range(len(nums)):
            if(nums[num_i]>0):
                break
            if(num_i>0 and nums[num_i]==nums[num_i-1]):
                continue
            left=num_i+1
            right=len(nums)-1
            while(left<right):
                if(nums[num_i]+nums[left]+nums[right]==0):
                    print nums[num_i],nums[left],nums[right]
                    all_n ums.append([nums[num_i],nums[left],nums[right]])
                    while(left < right and nums[left]==nums[left+1]):
                        left+=1
                    while(left < right and nums[right]==nums[right-1]):
                        right-=1
                    left+=1
                    right-=1
                elif(nums[num_i]+nums[left]+nums[right]>0):
                    right-=1
                else:
                    left+=1
        return all_nums

无重复字符的最长子串
给定一个字符串 s ，请你找出其中不含有重复字符的 最长 子串 的长度。
输入: s = "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。

解题思路:滑动窗口法，右指针在所指元素不存在于have_dif_char中时一直右移，当存在于longest中时，走一个while循环，先算当前的最长子串，让左指针左移，同时将删去have_dif_char数组第一个值。记得边界条件处理，当num=0或者=1时。以及到最后都没有出现重复时，需要在代码最后再max一遍最长子串
class Solution(object):
    def lengthOfLongestSubstring(self, s):
        """
        :type s: str
        :rtype: int
        """
        if len(s)==0:
            return 0
        elif len(s)==1:
            return 1
        left=0
        have_dif_char=[]
        longest_char=0
        for right in s:                
            while right in have_dif_char: 
                longest_char=max(longest_char,len(have_dif_char))
                del have_dif_char[0]
                left+=1
            if(right not in have_dif_char):
                print have_dif_char
                have_dif_char.append(right)
        longest_char=max(longest_char,len(have_dif_char))
        return longest_char


438. 找到字符串中所有字母异位词
给定两个字符串 s 和 p，找到 s 中所有 p 的 异位词 的子串，返回这些子串的起始索引。不考虑答案输出的顺序。
输入: s = "cbaebabacd", p = "abc"
输出: [0,6]
解释:
起始索引等于 0 的子串是 "cba", 它是 "abc" 的异位词。
起始索引等于 6 的子串是 "bac", 它是 "abc" 的异位词。
解题思路:采用定长滑动窗口+counter取词频进行比较。需要注意的是
    def findAnagrams(self, s, p):
        char=[]
        if(len(s)<len(p)):
            return []
        ##题目给的词频
        p_window=Counter(p)
        ##我们的初始窗口词频
        window=Counter(s[:len(p)])
        ##边界值，当i=0，即取索引为第一个时。
        if(p_window==window):
            char.append(0)
        ##因为前面有了边界值，所以我们这里可以从1你爱上
        for i in range(1,len(s)-len(p)+1):
        ##这一步有点难以理解。可以这么看，我们把长度为len(p)的窗口转化为了计词频后的字典
        ##当我们滑动下一个窗口时，需要对上一个窗口的初始索引的值进行-1，也就是把上一个值踢出去
            window[s[i-1]]-=1
        ##再删去为0的索引
            if(window[s[i-1]]==0):
                del window[s[i-1]]
        ##最后是把新索引，也就是当前窗口初始索引+p的长度-1
            window[s[i+len(p)-1]]+=1
        ##对字典取等
            if(window==p_window):
                char.append(i)
        return char

有效的括号
给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串 s ，判断字符串是否有效。

有效字符串需满足：

左括号必须用相同类型的右括号闭合。
左括号必须以正确的顺序闭合。
每个右括号都有一个对应的相同类型的左括号。
示例 1：

输入：s = "()"

输出：true

示例 2：

输入：s = "()[]{}"

输出：true

示例 3：

输入：s = "(]"

输出：false

示例 4：

输入：s = "([])"

输出：true

示例 5：

输入：s = "([)]"

输出：false

解题思路：其实也就是一个栈，试想一下，我们最右边的左括号，是不是希望最先匹配到的是与它相对应的右括号，也就是最左边的左括号需要最先被匹配，由此就可以联想到我们的栈了，后进先出。这题需要注意边界条件，以及字典的key不能是list，而python的pop方法放回的是一个list，所以我们字典的key反而应该是右符号而不是左符号

class Stack:
    def __init__(self):
        self.items=[]
    def push(self,num):
        self.items.append(num)
    def pop(self):
        if len(self.items)==0:
            print "error,size is 0"
            return False
        char_a=self.items.pop()
        print char_a
        return char_a
    def size(self):
        return len(self.items)


class Solution(object):
    def isValid(self, s):
        """
        :type s: str
        :rtype: bool
        """
        if len(s)<=1:
            print("false")
            return False
        if(s[0]=="}" or s[0]==")" or s[0]=="]"):
            return False
        stack = Stack()
        dict1={")":"(","}":"{","]":"["}
        for char in s:
            if(char=="(" or char=="{" or char=="["):
                stack.push(char)
            else:
                char_a=stack.pop()  
                if(dict1[char]!=char_a):
                    print("false")
                    return False
        if(stack.size()>0):
            print("false")
            return False
        else:
            print("true")
            return True


反转链表:
思路：需要有一个前驱节点作为我们遍历当前节点的前驱，一个临时temp来存放当前节点的next
class Solution(object):
    def reverseList(self, head):
       pre=None
       current=head
       while current:
        #临时存放
          temp=current.next
        #当前节点指向前驱，不再直接关注链表
          current.next=pre
        #将前驱后移
          pre=current
        将当前节点后移
          current=temp 
       #当current=null时遍历结束，此时pre就作为我们链表的头结点
       return pre


最长回文子串
解题思路：还是 挺巧妙的，由回文的定义可知，回文应该是中心对称的，由尔引发了我们的题解----找个中心点，然后对
左右进行扩展判断，当左右相等时，左边左移，右边右移，有点像变长滑动窗口。
需要注意的是，我们的中心点可能是只有单个字符，也可能是两个字符作为中心点，需要分类讨论，但我们其实也可以直接不管奇偶中心，都算一遍求最大值即可
```
class Solution(object):
   ##中心扩展算法
    def center_arroud(self,s,left,right):
        ##当左右都没到边界且相等时，往左右两边扩展
        while(left>=0 and right<len(s) and s[left]==s[right]):
            left-=1
            right+=1
        return right-left-1
    def longestPalindrome(self, s):
        """
        :type s: str
        :rtype: str
        """
        ##边界条件的处理
        if(len(s)<=1):
            return s
        if(len(s)==2 and s[0]==s[1]):
            return s
        ##这俩是总的最长回文串的起始位置
        start=0
        end=0
        ##当前这个节点为中心的最大子串
        current_loggest_len=0
        ##总的最大子串
        all_loggest_len=0
        for i in range(len(s)):
        ##很精髓的一步，直接对其计算，就不用再奇偶摆开挖情况
            i_one=self.center_arroud(s,i,i)
            i_two=self.center_arroud(s,i,i+1)
        ##求最大子串
            current_loggest_len=max(i_one,i_two)
            if(current_loggest_len>all_loggest_len):
                all_loggest_len=current_loggest_len
        ##个人认为下面这两步是最精髓的，没见过很难想出来这种方法，我们能不用奇偶摆开挖情况的原因也在这两步，能够统一进行处理
        ##当我们有 a a b a a 时，肉眼可见中心是b，且为奇，那我们用i=2，减去(5-1）//2，刚好是我们的0，而##i=2，加上(5)//2=4符合条件
        ##脑子转得快的朋友可能发现了，偶数的情况怎么办？
        ##这就是精髓所在，对于偶情况 a a b b a a 来说，我们肉眼可见中心是bb，此时i=2，2-(6-1)//2=0
        ##而2+(6)//2=5,感受到精髓在哪了么？
        ## 奇偶数不影响开始位置，终止位置会影响，因为我们的i=2，它后面还有一个3要计入其中，因而要多给它加个##1.
                start=i-(current_loggest_len-1)//2
                end=i+(current_loggest_len)//2
        return s[start:end+1]
```


环形链表
思路：一个快慢指针，快指针每次都两步，慢指针每次走一步，如果有环总会相遇。最巧妙的点在于循环条件的判断，当快指针存在且快指针的next不为none时，说明快指针走不到尽头，有环则循环，循环则进判断，相等则为true。如果退出循环则返回false

class Solution(object):
    def hasCycle(self, head):
        """
        :type head: ListNode
        :rtype: bool
        """
        one_step=head
        two_step=head
        while two_step is not None and two_step.next is not None:
            one_step=one_step.next
            two_step=two_step.next.next
            if(one_step==two_step):
                return True
        return False






编写一个函数来查找字符串数组中的最长公共前缀。
如果不存在公共前缀，返回空字符串 ""。
解题思路：初始化一个same_char取strs[0]，然后对strs进行一个遍历，当遍历到same_char长度小于str长度时，切片same_char[:len(str)]。然后再对str里面的字符进行一个遍历，使用公共变量i来进行比较，当出现不相等 same_char[i]！=str[i]说明公共前缀结束，砍掉same_char i后面的，然后退出str的遍历，遍历下一个sr

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



给你一个整数数组 nums ，请你找出一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。
子数组是数组中的一个连续部分。
输入：nums = [-2,1,-3,4,-1,2,1,-5,4]
输出：6
解释：连续子数组 [4,-1,2,1] 的和最大，为 6 。
解题思路：这题有个很巧妙的贪心解法，我们为从1起的每个位置，计算它当前所处位置的最佳子数和。而且还有容易，为什么，因为比如说我们有个i的位置要求最佳字数和，而我们前面的i-1已经是最佳了，那我们需要判断的就是 [i-1]+[i]和[i]本身哪个更大，如果[i]更大，则说明i自身就是个最佳的子树和，而如果相加之后更大呢？则用相加的来放到i的位置作为最佳字数和存储。最后我们再直接return max[最佳子树和]数组即可。
class Solution(object):
    def maxSubArray(self, nums):
        for i in range(1,len(nums)):
            #[-2，1，3，-5，6]
            nums[i]=max(nums[i-1]+nums[i],nums[i])
        return max(nums)


全排列
给定一个不含重复数字的数组 nums ，返回其 所有可能的全排列 。你可以 按任意顺序 返回答案。
输入：nums = [1,2,3]
输出：[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
解题思路：回溯算法，具体见代码吧，需要注意一点是 num.append(a)表示的是将存放a这个的变量列表的地址放入num中，也就是num中的值会随a的值改变，所以得用num.append(a[：])这个表示拷贝副本进去

class Solution(object):
    def permute(self, nums):
        ##一个全局变量，作为存放临时排列
        temp=[]
        def backtrack(nums,temp):
            if(nums==[]):
                ##当nums遍历完，而且res中没重复的
                if temp not in res:
                ##这个就是我们说的拷贝副本
                    res.append(temp[:])
        
            else:
            ##精髓处1
                for i in range(len(nums)):
            ##取nums中的值加到temp临时排列
                    temp.append(nums[i])
            ##一个子调用，将剔去当前变量i的nums以及全局变量temp加入。
                    backtrack(nums[:i]+nums[i+1:],temp)
            if(temp==[]):
                return
            temp.pop() 
        res=[]
        backtrack(nums,temp)
        return res


将两个升序链表合并为一个新的 升序 链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。 
思路：摘出来再接一个sorted，然后直接创建个新链表就行
重点在于链表的扩充不会写，我们需要新建一个node，然后再把node作为上一个node的next，跟c语言有差别
class Solution(object):
    def mergeTwoLists(self, list1, list2):
        new_num=[]
        while(list1!=None):
            new_num.append(list1.val)
            list1=list1.next
        while(list2!=None):
            new_num.append(list2.val)
            list2=list2.next
        new_num=sorted(new_num)
        new_list=ListNode(-1)
        temp=new_list
        for i in new_num:
            new_node=ListNode(i)
            temp.next=new_node
            temp=temp.next
        new_list=new_list.next
        return new_list
 
 最长公共子序列
 给定两个字符串 text1 和 text2，返回这两个字符串的最长 公共子序列 的长度。如果不存在 公共子序列 ，返回 0 。
 输入：text1 = "abcde", text2 = "ace" 
输出：3  
解释：最长公共子序列是 "ace" ，它的长度为 3 。

解题思路：动态规划，采用备忘录自底向上的方法解



给你一个整数数组 nums 和一个整数 k ，请你统计并返回 该数组中和为 k 的子数组的个数 。
子数组是数组中元素的连续非空序列。
输入：nums = [1,1,1], k = 2
输出：2
解题思路：初次遍历的同时，用哈希表记录下当前前缀和的出现次数，并求temp=当前前缀和减去k，当前子数组个数+哈希表中temp出现的次数。当当前前缀和=k时，子数组个数+1
import sys


class Solution(object):
    def subarraySum(self, nums, k):
        add_eq_k=0
        prefix_sum_map = defaultdict(int)
        current_add=0
        for num in range(len(nums)):
            current_add+=nums[num]
            if(current_add==k):
                add_eq_k+=1
            temp=current_add-k
            if temp in prefix_sum_map:
                add_eq_k+=prefix_sum_map.get(temp)
            prefix_sum_map[current_add]+=1
        return add_eq_k




给定一个整数数组 nums，将数组中的元素向右轮转 k 个位置，其中 k 是非负数。

解题思路：很巧妙的数组轮转解法，使用num[-k:]取到最后k个元素，num[:-K]取到除最后k个元素之外的元素，进行两个模块的分割，并交换两个模块的位置
class Solution(object):
    def rotate(self, nums, k):
        n = len(nums)
        k %= n
        nums[:] = nums[-k:] + nums[:-k]

