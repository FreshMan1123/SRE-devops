argo cd一般部署在中心节点。
把其余业务集群的kubeconfig放到中心节点即可。

同时需要配置application用来指定要读取的仓库位置和路径
以及要部署的集群以及命名空间

来个简单的部署

第一步：安装 Argo CD 组件.
# 1. 创建一个专门的命名空间
kubectl create namespace argocd

# 2. 从官方 GitHub 仓库应用安装清单
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
执行完这条命令，Argo CD 的所有核心组件就会在 argocd 命名空间中被创建并运行起来

第二步：在argo集群生产密钥对，添加公钥至github，添加私钥到argo cd
# -N "" 表示私钥不需要密码
在argo集群上生成密钥对
ssh-keygen -t rsa -b 4096 -C "argocd@your-company.com" -f ./argocd-deploy-key -N ""

打开argocd-deploy-key.pub公钥，复制公钥给github

## 还需要在argo cd 中添加私钥
创建 repo-secret.yaml 文件: 在本地创建一个名为 repo-secret.yaml 的文件，内容如下。
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-secret
  namespace: argocd
  # 这个 label 是魔法！Argo CD 会自动识别它
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  # 指定仓库类型是 git
  type: git
  # 仓库的 SSH 地址，必须是 SSH 格式！
  url: git@github.com:YOUR_USERNAME/YOUR_REPONAME.git # <-- 修改这里
  # 把你的私钥内容粘贴在这里
  sshPrivateKey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    ... (这里粘贴你的私钥内容) ...
    -----END OPENSSH PRIVATE KEY-----

-------------------------------------
第三步：访问 Argo CD UI 并登录(临时暴露到公网，本步可直接省略)
# 将 argocd-server 的 443 端口映射到你本地的 8080 端口
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443
用户名: admin
密码: 初始密码被自动生成并存储在一个 Secret 中。你可以用以下命令获取：
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
---------------------------------
## 第四步：在argo集群上配置applyaction
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  # 应用名称，会显示在 Argo CD 的 UI 界面上
  name: nginx-test-app
  # Application 资源本身必须创建在 argocd 命名空间中
  namespace: argocd
spec:
  # 应用所属的项目 (Project)，用于权限控制和分组，默认是 'default'
  project: default

  # Git 仓库的源配置
  source:
    # 你的 Git 仓库地址 (SSH)
    repoURL: 'https://github.com/YOUR_USERNAME/YOUR_REPONAME.git' # <-- 请务必修改这里
    # Kubernetes 清单文件 (manifests) 所在的路径，'.' 代表仓库的根目录
    path: .
    # Argo CD 应该跟踪哪个 Git 分支、标签或 Commit ID。HEAD 代表默认分支的最新提交。
    targetRevision: HEAD

  # 部署的目标位置
  destination:
    # 目标 Kubernetes 集群的 API Server 地址。
    # 'https://kubernetes.default.svc' 是一个特殊的魔法地址，代表 Argo CD 所在的这个本地集群。
    server: 'https://kubernetes.default.svc'
    # 你希望把 Nginx 应用部署到哪个命名空间。
    namespace: nginx-test

  # 同步策略
  syncPolicy:
    # 开启自动化同步
    automated:
      # 如果 Git 仓库中的配置被删除了，Argo CD 会自动从集群中删除对应的资源。
      prune: true
      # 如果集群中的实际状态与 Git 中的期望状态不符（比如有人手动修改了 Deployment），Argo CD 会自动把它修正回来。
      selfHeal: true
    # 同步选项
    syncOptions:
    # 如果目标命名空间 (destination.namespace) 不存在，Argo CD 会自动创建它。
    - CreateNamespace=true


第五步:apply
kubectl apply -f application.yaml

至此，argo cd的配置就算完成

安装 Argo CD CLI
# 1. 下载最新版本的 Argo CD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

# 2. 安装到 /usr/local/bin 目录下，这样系统就能随处找到它了
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd

# 3. (可选) 清理下载的文件
rm argocd-linux-amd64
然后，请重新尝试登录命令
argocd login localhost:8080 --username admin --insecure

针对多业务集群来说，我们有额外的配置步骤
1. 添加外部集群的kubeconfig到argocd集群的kubeconfig
切换 kubectl 上下文: 确保你的 kubectl 当前正指向你想添加的那个外部集群。
# 查看你当前的上下文
kubectl config current-context

# 如果需要，切换到目标集群的上下文
kubectl config use-context <你的外部集群的上下文名称>

执行添加命令: argocd cluster add 会读取你当前的 kubectl 上下文，并自动在 Argo CD 中创建一个包含连接信息的 Secret

第二步：查找注册后的 Server 地址
添加成功后，Argo CD 会为这个新集群分配一个地址。你可以用 list 命令查看：
argocd cluster list

第三步：在 application.yaml 中指定目标
现在，你的 application.yaml 就可以精确地指向外部集群了：