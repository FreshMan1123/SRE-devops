import re


class Solution(object):
    def validIPAddress(self, queryIP):
        if (re.match("^[1-9]{1}[0-9]{0,2}\.[0-9]{0,3}\.[0-9]{0,3}$",queryIP)):
            print("IPv4")
            return "IPv4"
        elif(re.match("^.{4}\:.{4}\:.{4}\:.{4}\:.{4}\:.{4}\:.{4}\:.{4}$",queryIP)):
            print("IPv6")
            return "Ipv6"
        print("Neither")
        return "Neither"

if __name__=="__main__":
    ip="192.168.1.00"
    solution=Solution()
    solution.validIPAddress(ip)

