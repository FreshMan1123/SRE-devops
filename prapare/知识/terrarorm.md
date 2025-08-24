terraform以一个目录为一个配置桶，核心思想：一个目录，一套配置
provider.tf：定义如何连接到你的云服务商。
main.tf：定义要创建什么基础设施。
variables.tf：定义输入变量。
outputs.tf：定义输出值。

参考腾讯云文档：https://cloud.tencent.com/document/product/1653/82868
######
一次简单的配置过程，基于腾讯云平台
1. 下载 Terraform
# 下载最新的 Terraform (这里以一个版本为例，你可以去官网找最新的)
wget https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip

# 解压文件
unzip terraform_1.8.5_linux_amd64.zip


2.移动至bin目录下
# 将 terraform 二进制文件移动到 /usr/local/bin
sudo mv terraform /usr/local/bin/

3.验证安装
terraform --version

4.实操配置
第 1 步：选择云厂商并准备凭证
创建一个 Access Key ID 和 Access Key Secret
首次使用 Terraform 之前，请前往 云 API 密钥页面 申请安全凭证 SecretId 和 SecretKey。若已有可使用的安全凭证，则跳过该步骤。
登录 访问管理控制台，在左侧导航栏，选择访问密钥 > API 密钥管理。
在 API 密钥管理页面，单击新建密钥，即可以创建一对 SecretId/SecretKey。

第二步.静态凭证鉴权
在用户目录下创建 provider.tf 文件，输入如下内容：
my-secret-id 及 my-secret-key 请替换为 获取凭证 中的 SecretId 和 SecretKey。
provider "tencentcloud" {
  secret_id = "my-secret-id"
  secret_key = "my-secret-key"
}

第三步：环境变量鉴权
请将如下信息添加至环境变量配置：
YOUR_SECRET_ID 及 YOUR_SECRET_KEY 请替换为 获取凭证 中的 SecretId 和 SecretKey。
export TENCENTCLOUD_SECRET_ID=YOUR_SECRET_ID
export TENCENTCLOUD_SECRET_KEY=YOUR_SECRET_KEY

第四步，换一下源
在当前主目录下创建.terraformrc 的文件
vim ~/.terraformrc

2. 粘贴镜像源配置
将下面的内容粘贴到 .terraformrc 文件中：
provider_installation {
  network_mirror {
    url = "https://mirrors.tencent.com/terraform/"
    // 限制只有腾讯云相关Provider, 从url中指定镜像源下载
    include = ["registry.terraform.io/tencentcloudstack/*"]   
  }
  direct {
    // 声明除了腾讯云相关Provider, 其它Provider依然从默认官方源下载
    exclude = ["registry.terraform.io/tencentcloudstack/*"]
  }
}

第四步：创建provider以及pvc
你可以把这个文件理解为 Terraform 用来和某个云平台 API 对话的“说明书”。
创建 provider.tf 文件，指定 provider 配置信息。文件内容如下：
terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      # 通过version指定版本
      # version = ">=1.60.18"
    }
  }
}

provider "tencentcloud" {
  region = "ap-guangzhou"
  # secret_id = "my-secret-id"
  # secret_key = "my-secret-key"
}

创建 main.tf 文件，配置腾讯云 Provider 并创建私有网络 VPC。文件内容如下：
resource "tencentcloud_vpc" "foo" {
    name         = "ci-temp-test-updated"
    cidr_block   = "10.0.0.0/16"
    dns_servers  = ["119.29.29.29", "8.8.8.8"]
    is_multicast = false

    tags = {
        "test" = "test"
    }
}



第五步：初始化工作目录并下载插件。
terraform init



执行以下命令，查看执行计划，显示将要创建的资源详情。
terraform plan


执行以下命令，创建资源。
terraform apply

执行完毕后，您可以在腾讯云控制台查看创建的资源。至此资源创建完毕
######
二.资源更新
1.如果需要更新资源，则修改main.tf文件
resource "tencentcloud_vpc" "foo" {
    name         = "ci-temp-test-updated2"
    cidr_block   = "10.0.0.0/16"
    dns_servers  = ["119.29.29.29", "8.8.8.8"]
    is_multicast = false

    tags = {
        "test" = "test"
    }
}

2.再执行plan查看修改的情况
terraform plan


3.在需要更新的目录下执行terraform apply命令，应用更新的数据创建资源


三.资源销毁
您可根据实际需求，执行以下命令销毁资源。
terraform destroy