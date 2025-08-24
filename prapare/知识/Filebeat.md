Filebeat 是一个轻量级的日志数据收集器。你可以把它想象成一个勤劳的“快递员”，它的唯一工作就是跑到你的服务器上，把指定的日志文件（比如 Nginx 的访问日志、应用的错误日志）打包好，然后高效、可靠地发送到指定的“仓库”（通常是 Elasticsearch 或 Logstash）。

使用docker的方式来启动filebeat

# 1. 先在宿主机上创建配置文件和数据目录
mkdir -p /my/filebeat/config
mkdir -p /my/filebeat/data


# 2. 创建你的 filebeat.yml 文件，并放入 /my/filebeat/config/
sudo bash -c "cat > /my/filebeat/config/filebeat.yml" <<'EOF'
# ============================== Filebeat 配置文件 (修正版) ===============================
#
# 核心改动：禁用了手动的 filebeat.inputs，完全依赖模块进行日志采集，避免冲突。
#

# ============================== 模块(Modules)配置 =================================
# 告诉 Filebeat 在哪里可以找到模块的配置文件 (例如 system.yml, nginx.yml)。
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  # 关闭 reload, 避免因配置动态重载导致重复启动 input 或其他问题。
  reload.enabled: false

# ============================== 输入(Inputs)配置 =================================
#
# !!!重要!!!
# 当使用模块时，应禁用此处的全局输入，因为模块会自己管理输入。
# 同时启用两者会引起冲突，导致 Filebeat 无法正常启动采集器。
#
filebeat.inputs:
- type: log
  # 禁用全局默认输入。
  enabled: false
  paths:
    - /var/log/*.log

# ============================== 处理器(Processors)配置 =============================
processors:
  - add_host_metadata: ~
  - add_docker_metadata: ~

# ============================== 输出(Output)配置 =================================
output.elasticsearch:
  # 确认这是你的 Elasticsearch 容器地址。
  hosts: ["172.17.0.1:9200"]

# ============================== Kibana 配置 =====================================
# 用于 filebeat setup 命令加载仪表盘。
setup.kibana:
  # 确认这是你的 Kibana 容器地址。
  host: "172.17.0.1:5601"
EOF

# 3. 运行 Docker 容器
docker run \
  --name filebeat \
  --user root \
  --volume="/my/filebeat/config/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro" \
  --volume="/var/log:/var/log:ro" \
  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
  --volume="/my/filebeat/data:/usr/share/filebeat/data:rw" \
  docker.elastic.co/beats/filebeat:7.17.0 filebeat -e -strict.perms=false

第五部分：使用模块（Modules）—— 标准化部署流程

在生产环境中，我们推荐使用模块（Modules）来采集标准应用的日志，这是最稳定和高效的方式。以下是经过验证的、从零开始的正确部署步骤。

### 第一步：在宿主机创建配置文件目录

我们需要一个地方存放所有的配置文件。

```bash
# 创建主配置目录和模块配置子目录
mkdir -p /my/filebeat/config/modules.d

# 创建用于持久化 Filebeat 状态的数据目录
mkdir -p /my/filebeat/data
```

### 第二步：创建核心配置文件 `filebeat.yml`

这个文件告诉 Filebeat 去哪里找模块配置、把数据发到哪里。

```bash
sudo bash -c "cat > /my/filebeat/config/filebeat.yml" <<'EOF'
# ============================== Filebeat 核心配置文件 ===============================
filebeat.config.modules:
  # 启用模块功能，并指向模块配置目录
  path: ${path.config}/modules.d/*.yml
  # 关闭动态重载，更稳定
  reload.enabled: false

# !!!重要!!! 禁用全局输入，完全交由模块管理
filebeat.inputs:
- type: log
  enabled: false

# 添加 Docker 元数据
processors:
  - add_docker_metadata: ~

# 配置 Elasticsearch 输出地址
output.elasticsearch:
  hosts: ["172.17.0.1:9200"]

# 配置 Kibana 地址，用于 filebeat setup 加载仪表盘
setup.kibana:
  host: "172.17.0.1:5601"
EOF
```

### 第三步：在宿主机上“启用”模块

我们不进入容器操作，而是直接在宿主机上创建模块的配置文件。这里以启用 `system` 模块为例。

```bash
sudo bash -c "cat > /my/filebeat/config/modules.d/system.yml" <<'EOF'
# Module: system
# 启用 system 模块
- module: system
  # 采集系统日志 (/var/log/syslog)
  syslog:
    enabled: true
  # 采集认证与安全日志 (/var/log/auth.log)
  auth:
    enabled: true
EOF
```

### 第四步：清理环境并运行 Filebeat 容器

在启动前，最好清理掉旧的容器和可能损坏的状态数据。

```bash
# 停止并删除旧容器
docker stop filebeat
docker rm filebeat

# 清理旧的状态文件
sudo rm -rf /my/filebeat/data/*

# 使用正确的卷挂载，启动新容器
docker run -d \
  --name filebeat \
  --user root \
  --volume="/my/filebeat/config/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro" \
  --volume="/my/filebeat/config/modules.d:/usr/share/filebeat/modules.d:ro" \
  --volume="/my/filebeat/data:/usr/share/filebeat/data:rw" \
  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  --volume="/var/log:/var/log:ro" \
  docker.elastic.co/beats/filebeat:7.17.0 \
  filebeat -e -strict.perms=false
```

### 第五步：加载模块资源（仅首次需要）

模块自带的 Kibana 仪表盘和 Elasticsearch 索引模板需要被加载进去。

```bash
docker exec filebeat filebeat setup -e \
  -E output.elasticsearch.hosts='172.17.0.1:9200' \
  -E setup.kibana.host='172.17.0.1:5601'
```

执行完以上步骤，你的 EFK 日志系统就能稳定地采集和展示系统日志了。
注意: 这个 setup 命令只需要运行一次。它会连接到 ES 和 Kibana，把模块所需的资源（仪表盘、索引模板等）安装好。
你需要确保你的 Kibana 容器正在运行，并且 Filebeat 容器可以访问它（这里我们假设 Kibana 运行在宿主机的 5601 端口）。
4. 重启 Filebeat 为了让启用的模块生效，需要重启 Filebeat 容器。

bash
docker restart filebeat
现在，Filebeat 就会开始按照 system 模块的配置去采集系统日志，并且当你之后配置好 Kibana，就能直接使用 system 模块自带的仪表盘了。 