1. 创建持久化的数据卷
docker volume create jenkins_home

2.运行jenkins容器
docker run \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name jenkins-master \
  -d \
  jenkins/jenkins:lts-jdk11
----------------------------
  -d: 后台运行容器 (detached mode)。
-p 8080:8080: 将宿主机的 8080 端口映射到容器的 8080 端口（用于访问 Jenkins UI）。
-p 50000:50000: 将宿主机的 50000 端口映射到容器的 50000 端口（用于 Jenkins Agent 连接 Master）。这个很重要。
-v jenkins_home:/var/jenkins_home: 将我们刚才创建的 jenkins_home 数据卷挂载到容器内的 /var/jenkins_home 目录。这是实现数据持久化的关键。
--name jenkins-master: 给容器起个名字，方便管理。
jenkins/jenkins:lts-jdk11: 使用官方的长期支持版 (LTS) Jenkins 镜像，它内置了 JDK 11。

在log日志文件种获取管理员密码
docker logs jenkins-master

访问8080端口登录

