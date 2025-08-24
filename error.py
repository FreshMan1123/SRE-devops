#python题：输出一份文件中error的数量
# os 用来判断文件路径是否存在 os.path.exists
import sys
import os
def getError(file_name):
    num=0
    if not os.path.exists(file_name):
        print("文件路径不存在")
    else:
        with open(file_name,'r') as file:
            # 存在更简便的方法
            #for line in file:
                #count = line.count("error")
                #num=num+count
            #-----方法二---------------
            # 直接读取整个文件内容
            content=file.read()
            num=content.count("error")
        print(num)

if __name__=="__main__":
    getError("error_file")
        