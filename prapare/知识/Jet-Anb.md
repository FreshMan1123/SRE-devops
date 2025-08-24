jetkins
Jenkins的基本工作流程
开发者提交代码到Git仓库（如GitHub、GitLab）
Jenkins监听到代码变更（通过webhook或定时拉取）
1. Webhook触发（推荐，实时）
原理：代码托管平台（如GitHub、GitLab、Gitee等）在代码有变更（如push、merge）时，自动向Jenkins发送一个HTTP请求（Webhook），Jenkins收到后立即触发构建。
优点：实时、及时、资源消耗低。
配置方法：
在Jenkins的Job配置中，勾选"构建触发器"里的"GitHub hook trigger for GITScm polling"或"Build when a change is pushed to GitLab"等。
在代码仓库的Web界面（如GitHub/GitLab项目设置）添加Webhook，URL填写Jenkins的接口地址（如http://jenkins服务器地址/github-webhook/）。
保存后，每次代码有变更，仓库会自动通知Jenkins，Jenkins立即拉取代码并构建。
自动拉取最新代码
执行构建脚本（如Maven、npm、Shell等）
运行自动化测试
生成构建产物（如jar包、镜像等）
自动部署到服务器或云平台
通知开发者（如邮件、钉钉、企业微信等）

 pipeline {
      agent any
      stages {
          stage('拉取代码') {
              steps {
                  git credentialsId: 'git-凭据ID', url: 'git@xxx.com:xx/xx.git', branch: 'main'
              }
          }
          stage('编译打包') {
              steps {
                  sh 'mvn clean package'
              }
          }
          stage('部署') {
              steps {
                  sh '''
                  scp target/xx.jar user@目标服务器:/opt/xx/
                  ssh user@目标服务器 'systemctl restart xx'
                  '''
              }
          }
      }
  }

# **Ansible从零搭建与入门全流程**

## 1. 环境准备
- 一台作为"控制节点"（管理端）的Linux服务器（如CentOS/Ubuntu），只需在这台机器上安装Ansible。
- 多台被管理的目标服务器（被控端），只需能通过SSH访问，无需安装任何客户端。

## 2. 安装Ansible

### CentOS/RHEL
```bash
sudo yum install epel-release -y
sudo yum install ansible -y
```

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install ansible -y
```

### 验证安装
```bash
ansible --version
```

## 3. 配置免密SSH登录
- 控制节点生成SSH密钥（如果没有）：
  ```bash
  ssh-keygen -t rsa
  ```
- 将公钥拷贝到所有被控服务器：
  ```bash
  ssh-copy-id user@目标服务器IP
  ```
- 测试免密登录：
  ```bash
  ssh user@目标服务器IP
  ```

## 4. 编写主机清单（Inventory）
- 新建一个`hosts`文件，内容示例：
  ``` 
  [webservers]
  192.168.1.101
  192.168.1.102

  [dbservers]
  192.168.1.201
  ```
- 可以分组，便于批量管理。

## 5. Ansible常用命令测试
- 批量ping所有主机
  ```bash
  ansible all -i hosts -m ping
  ```
- 在webservers组批量执行命令
  ```bash
  ansible webservers -i hosts -m shell -a "uptime"
  ```

## 6. 编写并执行Playbook
- 新建`deploy_nginx.yml`：
  ```yaml
  - hosts: webservers
    tasks:
      - name: 安装nginx
        yum:
          name: nginx
          state: present

      - name: 启动nginx
        service:
          name: nginx
          state: started
  ```
- 执行Playbook：
  ```bash
  ansible-playbook -i hosts deploy_nginx.yml
  ```

## 7. 常见问题与优化
- SSH连接失败：检查防火墙、密钥、主机名等。
- 权限问题：可用`-u user`指定远程用户名，或用`become: yes`提升为root。
- YAML格式错误：注意缩进和冒号。

## 8. 面试自述万能句式
> 我可以从零搭建Ansible，包括安装、配置免密SSH、编写主机清单、批量执行命令、编写Playbook实现自动化部署等。熟悉Ansible的无代理架构和常用模块，能高效完成批量运维和自动化部署任务。

---
