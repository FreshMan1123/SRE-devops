import sys
def zhuangshiqi(func):
    def qingchaotudousi():
        func()
        print("chuguo")
        print("zhuangpan")
    return qingchaotudousi

@zhuangshiqi
def chaotudou():
    print("切土豆丝")


if __name__ == "__main__":
    chaotudou()