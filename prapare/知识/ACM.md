多个值，形如3，2，1，3，4.最后会处理成列表
nums = list(map(int, sys.stdin.readline().strip().split()))
假如是字符串(A A S C V)
items = sys.stdin.readline().strip().split()

一行输入，单个值
n = int(sys.stdin.readline().strip())
如果是字符串(ABC)
s = sys.stdin.readline().strip()

输入的是字典，元组，列表等
line = sys.stdin.readline().strip()
data = ast.literal_eval(line)

处理多个测试用例组
if __name__ == "__main__":
    # 1. 读总用例数 T
    t_cases = int(sys.stdin.readline().strip())
    for _ in range(t_cases):
        line_for_n = sys.stdin.readline().strip()
        while not line_for_n:
            line_for_n = sys.stdin.readline().strip()
        # --- 可动态调整的部分，具体处理测试用例 ------------------------
        n = int(sys.stdin.readline().strip())
        nums = list(map(int, sys.stdin.readline().strip().split()))
        # ------------------------------------------------------------
        # 调用核心函数
        solve(n, nums)

创建n+1列，m+1行的二维数组        
dp=[[0]*(n+1) for _ in range(m+1)]