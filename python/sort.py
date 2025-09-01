import sys


def sinege(s, left, right):
    have_sing_char = 0
    while left>=0 and right<len(s) and s[left]==s[right]:
        have_sing_char += 1
        left -= 1
        right += 1
    return have_sing_char


def double(s, left, right):
    have_double_char = 0
    while left>=0 and right<len(s) and s[left]==s[right]:
            left -= 1
            right += 1
            have_double_char += 1
    return have_double_char


if __name__ == "__main__":
    s=sys.stdin.readline()
    have_dou=0
    for index in range(1,len(s)):
        have_dou+=sinege(s,index-1,index+1)
        have_dou+=double(s,index-2,index+1)
    print(have_dou)