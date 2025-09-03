## K8S核心概念

pod一直pending原因排查：
1. 这种情况首先是查看管理该pod的副本情况,看是不是全部副本都无法启动
2. kubectl descirbe pod看看pod的event,可能是拉取的镜像仓库没权限或者网络不行,要配镜像源
3. kubectl logs pod检查日志，看是不是打包的镜像代码本身就有问题，只是编译打包的时候没显示
4.拉个临时容器进行镜像，查看工作目录，依赖有没有拉够，相关的代码有没有copy进来，或者是镜像的启动CMD命令配置错了，路径有错误。
5. 检查pod配置文件本身，看是不是存在mount挂载目录配置错误，或者是pvc在k8s集群中其实不存在，绑定错误了。
6. 如果配置是initcontainer，那可能得检查一下logs，看是不是一直卡在initcontainer处，pod无法正常启动，可能是initcontainer一直在启动运行阶段，我记得initcontianer运行并关闭后，其余container才能起的

污点机制：
强硬限制:不允许新pod调度，除非有容忍，但不驱逐现有pod
软性限制：优先去其他节点，没其他节点也能来
驱逐限制：不允许没容忍的pod来，同时驱逐当前节点中已存在的没容忍pod

请简述 Kubernetes Pod 的常见状态有哪些？并说明 Pending、Running、Succeeded、Failed、Unknown 这几种状态分别代表什么。
常见状态有running，pendingmsucceed，failed，unknown。runing代表od正常运行。
pending表示有些容器还没正常启动，pod启动中，可能都原因可能有镜像无法正常下拉，集群资源不足，pvc或挂载点配置错误，容忍或者节点调度策略没打好。failed则是无法正常运行，pod退出运行并不再重启。succeed常用于一次性任务，pod完成任务结束生命周期，unknwon表示状态未知。

k8s中为什么要调度pod而不是容器。
因为pod可以协助我们进行多容器编排，比如说我们平时要让不同容器进行通信，那可能得自定义网络进行
容器间的网络配置，相对麻烦，而pod里面的容器共享网络配置，直接通过localhost+端口访问即可。同时也能让多个pod存储空间，方便容器之间的协同操作，或者是设置变车容器，前置容器来进行容器之间的协同操作。同时，在管理上，pod能够很好的进行像是扩容缩容，HPAVPC策略，以及pvc或者是mount策略的一个管理。作为调度最小单元来说，容器太细了，而pod则正好。集群不必关心具体运行了哪些容器，只需要将pod根据特定的调度规则调度到不同的节点上面去。

k8s两种更新策略说一下?
滚动更新和重建更新策略。
滚动更新是先把一部分pod给销毁再重建成新版本的pod，再拉另一部分pod，保证过程中始终有pod能处理流量。其中我们能使用maxunavailabe来设置最多一次销毁多少pod，用maxsurge来设置创建的pod最多可以超过期待副本多少，因为我们滚动更新是先启后销的策略，只有当新版本的pod完全启动能够接收流量之后，旧的pod才会被删除，来保证旧pod不被完全销毁实现平滑过渡。滚动更新缺点是滚动更新中新旧pod出现出现，需要我们应用的api能够向后兼容
重建更新：也就是全部pod销毁再一次重建成新版的

请你详细描述一下，一个来自用户浏览器的 HTTPS 请求（例如 https://api.example.com/users），在进入你的 Kubernetes 集群后，是如何一步步地转发，并最终到达一个运行在 Pod 里的应用程序的？
请尽可能详细地描述这个请求流经的关键组件（比如 Ingress, Service, Kube-proxy 等），以及它们在其中扮演的角色。
首先是DNS解析，连接到负责均衡服务器，需要注意的是，负载均衡服务器上轮询的ip不能是master节点，在现代架构中，我们轮询的更多是node的ip+ingress controller对外暴露的端口，nginx对流量进行转发，发送https请求到达集群后，会被ingress controller通过配置到ingress上的转发规则，进行流量的转发，然后转发到特定的service的clusterip上，而这个clusterip其实是一个虚拟的ip分配给我们service用来作为一个稳定的访问入口，我们的service其实更多是一个声明配置的一个作用，外界流量发往servie时，我们的kube-proxy会根据service的配置来进行设置具体的ipvs网络规则，同时将这个流量拦截，进行真正的流量转发和负载均衡，将流量发送至真是的pod ip处。

随着安全要求的提高，公司要求你在整个 Kubernetes 集群中实施一项策略：禁止任何容器以 root 用户身份运行。你会怎么做？
使用k8s的准入控制策略，该策略用来控制哪些资源可以被创建，哪些资源不可以。通过namespace上配置比如说 不设防，基线策略：使用已知的权限提升，比如说禁用以root身份运行容器，禁用hostpath等。严格策略：该策略是pod硬化的最佳实践，是最严厉的准入控制策略。它的具体配置我们打个标签就行

我们ping某个暴露了端口的clusterip或者nodeport能成功吗？为什么？
不行，ping是ICMP协议，无论是cluserip和nodeport，实际上clusterip是分配给它的虚拟ip，并不是一个真实的能响应ICMP的网络设备，而nodeport在底层也会被分配一个clusterip，只是它同步在全部node上打开了相关端口来监控外部流量的进入。

nodeport转发内部外部流量的方式？
1.对于内部流量来说，pod会通过DNS解析 service的clusterip地址，然后转发到ip+端口的位置，kube poxy会进行拦截，根据ipvs建立的网络规则，进行流量转发以及负载均衡
2.对于外部来说，外部客户端转发流量到任意一个节点ip+端口，再被转发到物理网卡，被kubepxy拦截，再进行流量转发以及负载均衡

我想暴露mysql服务，还能用ingress吗？为什么？
不行，因为mysql是tcp，也就是第四层的服务，ingress能读懂解析https请求，但是无法读懂tcp，所以就需要我们用nodeport的service进行暴露，如果需要外部访问，则再加个四层负载均衡（tcp）nginx。
或者也可以使用loadbalance工作负载，这样的话service会申请云厂商分配给一个 负载均衡，该负载均衡有真实的ip来对接进行流量转发到你的service，使用时外部客户端流量指向这个负载均衡的原始ip，以及原始端口即可。

pod内部nslookup解析DNS和node上nslookup解析DNS的区别
区别在于用不用得到coreDNS，codeDNS是专门用来处理pod的域名解析的。当我们在pod里nslookup解析域名的时候，
pod会访问自身内部的/etc/resolvy.conf，这个文件里面指向集群的codeDNS,然后把请求转发到codeDNS，codeDNS再把请求转发到上游服务器拿到ip
而node本身nslookup是使用node自身的/etc/reslovy.conf的，不走coreDNS，直接走的外部DNS，拿到ip

场景：你在一个 Kubernetes 集群中部署了一个新的应用 Pod。这个 Pod 在启动时需要连接一个外部的数据库，比如 rds.aliyuncs.com，但是应用日志显示连接超时，或者 'unknown host'。
你在 Pod 内部尝试 ping rds.aliyuncs.com 也不通。
问题：请问你会从哪些方面开始排查这个问题？请给出你的排查思路和具体步骤。
1.首先是进入到pod里面去，检查pod本身的/etc/reslov.conf配置文件，查看是不是出错
2.进行一个nslookup dns解析，查看dns解析情况
3. 检查pod出战策略，查看是不是没允许pod内部流量访问外部地址
4. 检查coreDNS配置文件，看是不是coreDNS里面ip解析被劫持了，上游DNS配置错了，没给CoreDNS这个pod访问53端口的出站流量
4. 检查coreDNS的资源利用情况，起源不足可能导致被系统腺瘤，丢弃DNS请求
5.检查防火墙策略以及云安全组
6. 最后是检查应用本身，查看tls证书认证情况以及tcp握手情况，以及我们应用本身的环境配置，密钥地址有没有写对


在K8s中，如果Pod因为OOM被杀死，你会在哪些地方看到相关的日志信息？具体的kubectl命令是什么？
kubectl desribe pod podname来看日志
kubectl desribe pod podname --previous查看历史日志
查看node系统日志journalctl -u kublete | grep -i oom

journalctl是什么
是系统的日志查看工具。可以用来查看系统systemed服务的日志
通过journctl -u kubelet 来查看特定服务日志

解释一下 ConfigMap 和 Secret 的作用与区别。
configmap明文存储非敏感数据
secret使用base64编码存储数据，适用私密数据

 Service LoadBalancer 类型
loadbalancer是在nodeport的基础上向云厂商申请独立的公网ip以及负载均衡器。外界通过这个负载均衡器访问，再吧流量转发到ingress controller

假设我们有多个集群，你要怎么配置负载均衡以及DNS呢？
用户->全局DNS，假设有一个统一的对外域名，在DNS服务器处为域名配置多条A记录，分别对应不同集群的负载均衡；全局DNS会有我们进行加权轮询或者地理位置解析，故障转移-》全局DNS决定去哪个集群-》到达对应的负载均衡，负载均衡上有多个node的ip+ingress controller的端口号-》流量通过负载均衡转发到某个node上的ingress contoller-》应用pod

两个集群的pod怎么互相访问
1. 通过nodeport直接暴露pod的端口，通过访问集群node ip+端口的方式进行访问。这是最基础的
2. 配置个公网负载均衡，让pod的流量指向负载均衡的域名，负载均衡会帮我们把流量转发到某个node的ingress controller，再转发到pod上。这是第二种方法
3. 配置私有域名负载均衡，这个麻烦一点，需要在双方集群内codeDNS上都加个内网配置的DNS服务器，把域名解析的ip加到DNS服务器，然后双方再通过连接到负载均衡进行流量转发

四层负载均衡
其实也就是不关心http请求，只负责建立起一个tcp连接，比如说我们对集群多个node设置负载均衡，在流量到达nginx负载均衡时，会选择一个节点来连接，这一层是纯tcp连接，所以是四层

如果是通过deployment创建的pod想进行一个回滚，应该怎么做
kubectl rollout undo deployment/<deployment_name>

victermetrics 通过什么来实现查询以及存储上的优化
1. 在存储上，victermetrics通过压缩优化算法，来对不同数据类型进行占用空间的压缩，减少占用磁盘的大小。同时，victermetrics采用自研的存储引擎，使用时间戳的方式在磁盘上紧密排布数据，同时后台定期合并，vetermetrics会将小数据块先写入内存，然后不断跟新的数据块合并成大的数据块，最后再定期冲刷到磁盘，这种方式能够定期清理过期数据，也能进一步压缩数据
2. 在查询上，victermetircs将索引以及时间序列数据分开存放，能够避免每次都需要扫描全部数据，减少扫描数据的时间。同时，它设置了多级缓存机制，频繁使用的函数，或者是最终查询，中间计算结果都会被临时缓存，并且频繁访问的索引数据会被缓存到内存中，第二个是读写分离的架构，数据写入，数据存储，数据查询在三个不同的组件上，避免数据写入造成的查询压力 

k8s完整的部署流程，比如说从服务器的上架到磁盘分区系统的安装到k8s的部署流程？

Flannel和Calico的网络模型
flannel模式，其实也就是overlay模式，这种模式会在现有的网络基础层上新增一个虚拟网络层，它会给pod分配对应的虚拟ip，同时将该ip对应的网段进行声明，表示要访问xx网段的应往对应集群走，不同于overlay的是，它这个虚拟不来自弹性网卡。当node a上的pod a要访问node b上的pod b时，pod a就会将流量转发到node a，node a会对流量进行封装，源ip是node a目标地址是node b，封装后在节点网络中传输，到node b后进程进行解封装，转发给pod b
calico模式其实也就是underlay模式，这种模式会给每个pod分配弹性网卡上的真实ip，然后通过BGP边界网关协议进行节点之间的动态学习分发到某某ip的最佳跳数，同样的，node也会宣告对应网段的ip在本node上，当流量进行访问时，会自动往该node上跑，进行节点之间的直接路由

K8S证书有效期是多久，到期了怎么处理
K8S客户端证书的有效期一般是一年时间，根证书的有效期是十年，在根证书有效期间可以进行证书的重新签发。在新版k8s中，将证书续签与集群升级合并到了一起，使用kubectl upgrade就可以自动续期证书

k8s怎么进行集群的升级
首先是需要进行etcd的备份，然后是升级kubeadm包，然后选择主master节点进行节点升级，然后升级kubelet和kubectl，然后升级另外几个master节点，对于工作节点，我们的升级需要谨慎，首先需要驱逐工作节点上的pod，然
后执行升级，升级kubeadm以及kubelet，最后是恢复节点的可调度性，并在其余节点重复升级过程，最后检查集群状态

kubectl和kubelet的区别
kubectl是集群管理工具，用来跟api server进行交互。而kubelete是节点自身的客户端，用来管理本节点上的pod

Kubeadm 是什么？
是k8s官方提供的命令行工具，用来简化k8s集群的初始化安装升级

为什么工作节点 (Worker) 不用升级 Kubectl？
因为kubectl是用来跟api server交互的，一般来说，为了权责分离原则，以及防止黑客侵入，一般不推荐直接从node上使用kubectl来管理集群

驱逐工作节点上的 Pod 是只能在 Master 节点做吗？
可以在master节点或者是配备有对应权限kubeconfig的笔记本上做

根证书CA是什么
根证书是集群证书签发总部，它能够自签名同时也能为集群上各个组件进行签名，集群里的全部组件都认可这个签名

kubeconfig是怎么分配权限的？
首先，集群管理员会通过RBAC规则来给对应的用户绑定对应的权限，然后kubeconfig里面放置的是对应的用户凭证，比如客户端证书或者token

underlay模式下，service被分配的是真实ip吗
不是，仍然是虚拟ip，弹性网卡的真实ip是宝贵的，一般只发给pod

我们项目中经常需要在Pod之间共享数据，能跟我聊聊你在Kubernetes中是怎么处理这类需求的吗？
对于这个，首先我们需要在pod的配置文件上声明使用一个pvc，然后在pod内对应容器上，将pvc存储挂载到容器内的路径，使得容器内能够访问数据块，通过这种方式是心啊pod之间的共享数据

volume有哪些类型
配置或者证书：configmap/secrets
临时缓存, 随pod生命周期死亡，empityDIr
持久化存储:pvc+stroageclass
本地节点目录挂载：hostpath

StatefulSet的滚动更新策略与Deployment有什么关键区别？
有序性和无序性是statefulset和deployment更新的最大区别。statefulset的滚动更新是由大序号向小序号进行滚动更新，同时因为pod有固定的主机名pod名字，同时pvc命名方式是pvc模板+pod名称，所以滚动更新后的pod能够稳定继承pvc，以及对应的主机号。同时statefulset支持按照序号进行更新，设置策略可使序号大于x的先更新，保留一部分小于x的作老版本。而deployment更多的是限制更新中最多未就绪的副本数以及允许超额创建pod的量

我们集群里有些自定义控制器，能说说你对Kubernetes控制器模式的理解吗？
k8s控制器模式是保证集群状态跟我们期望状态一致，它通过控制循环来实现这种模式。首先是观察，观察集群里资源的实际状态，再有是分析，分析实际状态跟期望状态是否相符，最后是执行，执行必要的操作来减少差距



控制器模式中的Informer机制是如何帮助控制器监听资源变化的？
1.初始化阶段：通过list获取全部资源，并存储到缓存
2. 监听阶段，watch api实时监听资源变化，并将变化存储至缓存
3. 将变化发送给控制器处理
4. 控制器，也就是collector比较期望状态和实际状态，执行调谐逻辑

你提到使用Ingress Controller和TLS加密来保证远程写入的安全性，那在数据量很大的情况下，你是如何处理可能出现的网络延迟或写入性能瓶颈的？
1. 提升缓冲区大小，防止后端接收变慢导致的数据被丢弃
2. 增大每个批次发送的样本数量，减少网络请求此时
3. 增加超时时间，进行超时重传
4. 水平垂直扩展ingress controller，扩充ingress controller节点数或者分配资源量
5. 启用http2多路复用
6. 在数据发送前进行过滤聚合，减少不必要的指标
7. 增加专用流量发送代理，比如vmagent，他能实现更高效的转发功能

你刚才提到Service的虚拟IP和负载均衡，那你知道在集群内部是如何通过DNS来解析这些Service名称的吗？
pod向core DNS请求解析service的名称

你提到CoreDNS会解析Service名称，那如果遇到DNS缓存导致服务发现延迟的情况，你会怎么处理？
1. 降低DNS缓存时间
2. 定期重启coreDNS
3. 新增DNS预热机制，在服务启动时提前预热缓存

service的endpoint是什么，怎么通过这个来排查service的情况的
endpoints是在service创建时，k8s自动创建的，记录有能够承载流量的健康pod的真实ip以及端口，kube poxy就通过endpoint来找到对应的流量

怎么判断集群是否死亡
1. 检查api server的相应情况以及延迟
2. 检查etcd组件的存活情况以及延迟
3. 检查node的unready情况，以及互相通信是否可达。节点的资源利用率
4. 检查core DNS的解析情况
5. 检查pod的调度能力

### K8S核心组件

#### Master节点组件
- API Server：集群入口，处理所有REST请求
- etcd：分布式键值存储，保存集群状态
- Controller Manager：控制器管理器，维护集群期望状态
- Scheduler：调度器，决定Pod运行在哪个Node上

#### Node节点组件
- kubelet：节点代理，管理Pod生命周期
- kube-proxy：网络代理，实现Service负载均衡
- Container Runtime：容器运行时(containerd/CRI-O)

#### 附加组件
- DNS：集群内服务发现
- Dashboard：Web管理界面
- Ingress Controller：七层负载均衡

#### 网络组件(CNI)
- Flannel：简单的overlay网络，适合小集群
- Calico：功能丰富，支持网络策略和BGP路由
- Weave：自动发现，支持加密
- Cilium：基于eBPF，高性能安全

Master和Node节点的区别
Master节点（控制平面）
作用： 集群的"大脑"，负责管理和控制整个集群
Node节点（工作节点）
作用： 实际运行Pod的"工人"

K8s调度器：Scheduler是如何工作的？它的两个主要阶段（Filter和Score）分别做什么？
k8s调度器主要有两个阶段，分别是过滤和打分。过滤阶段是遍历全部node，过滤出符合cpu 内存资源要求，同时满足节点亲和性策略的node。而打分阶段则所对过滤出的node进行打分，包括node的利用率和node上是否已经有该pod所需的镜像。调度器倾向于调度到资源更空闲，有该镜像以及符合节点亲和性策略的节点上。

1. etcd 的作用
Kubernetes 的“数据库”：所有 K8s 资源对象（比如 Pod、Service、ConfigMap、节点信息等）都存储在 etcd 里
分布式一致性：etcd 保证多台服务器之间的数据一致，防止数据丢失或冲突
高可用：支持集群部署，节点挂了也不会丢数据

你在项目中如何用Kubernetes做资源管理和调度？
我们主要从资源管理和调度策略两个方面来做：
1. 资源管理：
用Deployment + HPA做自动扩缩容，CPU超过70%扩容，低于30%缩容
设置ResourceQuota限制命名空间资源使用上限
用LimitRange给Pod设置默认的资源限制
2. 调度策略：
NodeAffinity确保Pod调度到特定节点（比如GPU节点）
PodAntiAffinity避免同类Pod跑在同一节点，提高可用性
Taint/Toleration处理节点污点，比如专用节点
3. 监控和优化：
Prometheus监控资源利用率
写程序调用云厂商API采集数据
根据监控数据调整调度策略"

像k8s的话，他要管理docker的话，一般会通过什么方式来管理呢
"K8s通过Pod来管理Docker容器。Pod是K8s的最小调度单元，一个Pod可以包含一个或多个容器。Deployment负责管理Pod的生命周期，包括创建、更新、删除、扩缩容等。"

像蓝绿部署，还有这个滚动部署，这块你了解吗？
蓝绿部署是维护两个独立的环境，蓝环境是当前生产环境，绿环境是准备切换的新环境。只有蓝环境是真正的生产环境，绿环境是预发布环境。"
滚动部署是逐步更新Pod，先更新一部分，再更新下一部分，保证服务不中断。"

pod创建的流程，涉及了哪些组件
首先是kubectl发送创建请求给api server，由api server进行用户准入控制，检测用户是否有创建pod以及访问集群的权限。无误则将pod信息给传递存储到etcd中，此时pod仍是pending状态。再次Scheduler会进行pod的一个调度，根据污点容忍/节点选择器策略将pod调度到特定节点
随后就到了工作节点，工作节点上的kubelet会读取pod的详细配置，然后发送信息给CRI容器运行时，容器运行时会进行镜像的下拉以及创建容器，随后CNI会为pod分配网络资源.最后是把kubelet将信息穿会给api server,api server再传给etct,此时我们就可以通过kubectl来看到pod的状态了.

假设你们的Kubernetes集群使用的是Calico CNI，现在发现同一个Node上的两个Pod可以互相通信，但是不同Node上的Pod无法互相访问。
1.第一种可能是Calico使用underlay的BGP模式，然而我们对路由表的声明没生效，路由器不知道还有node之间能访问，需要检查calico组件健康状态以及邻居关系。也有可能是我们networkpolicy策略配置，禁止了不同node之间pod的访问，第三种是检查防火墙或者云安全组策略，看是不是GBP端口179被禁用了。
2.第二种可能是calico使用overlay的IPIP模式，这种模式的话我怀疑是kube poxy组件有问题导致node对pod数据包的转发失效了，无法正常互相访问

k8s的Webhook是干啥的，工作原理是什么，咋用。
webhook是准入控制器，允许在api server处理资源请求的周期中，添加入自己的逻辑关卡。分为1.变更型准入，当api server检测到某个pod被发起创建请求时，会自动为其打上标签等。2.校验型准入，检测资源是否符合某自定义策略，决定放行还是拒绝
工作原理：
1.用户发送创建请求到达api server
2. api server进行认证处理
3. 存入etcd前，apiserver检查是否有注册的webconfigureconfiguration关注这个请求，如果触发变更型准入，则会将请求对象打包并传到你自己配置的webhook服务器。修改后将对象返回给api server
4. 检查是否有校验型webhookconfiguretion关注这个请求，若有则将其发送到你的校验webhook server上，根据自定义逻辑进行判断并返回是否准入

pod里的容器之间如果想实现共享数据应该怎么做
设置volumes挂载，可以用empityDir临时存储或者hostpath挂载宿主机目录，再或者是配置configmap以及secret配置文件共享

kube poxy有哪两种模式，区别是什么
有iptabels和ipvs两种模式，iptables是生成大量的规则，按照对应的规则进行流量转发。ipvs则是每个serivce维护一个表，流量到时直接查表选择对应的后端pod转发流量

iptables按照对应的规则进行流量转发是什么意思
就是当流量到达时，iptables会对流量的目的ip和port进行 迭代的规则匹配，当匹配上后则将目的ip改为port的ip，由内核把包发给对应pod

什么时候适合用iptables，什么时候使用用ipvs
集群小， serivce少则用iptables，集群大service多就用ipvs，因为ipvs是相对来说性能更好的模式

如何防止污点被意外清除？
使用污点控制器来管理污点

假设说service暴露了端口80，那可以配置它往两个端口发送流量吗
不可以，映射规则是唯一的

k8s回滚怎么做，可以回滚到某个特定的版本吗
kubectl rollout实现回滚，可以使用--to-version来指定对应的版本

underlay模式下CNI分配的ip，究竟是网卡的ip，还是CNI网络插件的ip
云下分配的是ip池的ip，云上分配的是VPC子网的ip

pod里的容器之间是怎么实现网络共享的
pod有一个pause基础设施容器，pod里面的所有容器共享pause的网络命名空间，共享ip已经端口范围，并通过localhost+端口号实现网络通信



我们项目中经常需要在Pod之间共享数据，能跟我聊聊你在Kubernetes中是怎么处理这类需求的吗？

你刚才提到使用PVC，那在实际项目中你更倾向于选择哪种Volume类型来满足这种共享需求？为什么？

我很好奇StatefulSet是怎么保证存储卷和Pod的对应关系的，能说说你的理解吗？

如果手动删除一个StatefulSet管理的Pod，新创建的Pod会如何继承原有的存储卷？

StatefulSet的滚动更新策略与Deployment有什么关键区别？

我们集群里有些自定义控制器，能说说你对Kubernetes控制器模式的理解吗？

控制器模式中的Informer机制是如何帮助控制器监听资源变化的？

你刚才提到使用Remote Write将数据发送到中心集群的VictoriaMetrics，能具体说说你是如何配置Prometheus的远程写入功能的吗？

你提到使用NodePort暴露VictoriaMetrics服务，那有没有考虑过在这种架构下如何保证远程写入链路的可靠性和安全性？

你提到使用Ingress Controller和TLS加密来保证远程写入的安全性，那在数据量很大的情况下，你是如何处理可能出现的网络延迟或写入性能瓶颈的？

我很好奇Kubernetes的服务发现机制是怎么工作的，能详细说说吗？

你刚才提到Service的虚拟IP和负载均衡，那你知道在集群内部是如何通过DNS来解析这些Service名称的吗？

你提到CoreDNS会解析Service名称，那如果遇到DNS缓存导致服务发现延迟的情况，你会怎么处理？

我们遇到过Service流量异常的情况，能说说你会怎么排查这类问题吗？

除了查看日志，你会怎么检查Service的Endpoint状态来确认后端Pod是否正常？

### CNI网络插件对比

#### CNI（Container Network Interface）
**定义**
- CNI是一套容器网络接口标准，由CNCF维护
- 作用：为Kubernetes等容器平台提供网络插件的统一接口规范，方便不同网络方案（如Calico、Flannel等）无缝集成
- 本身不是网络方案，而是一个"插件标准"，具体的网络实现要靠各种CNI插件

#### Calico
**类型**：CNI插件之一，功能非常强大

**主要特点**
- 支持三层（L3）路由，基于BGP协议实现Pod间通信
- 支持网络策略（NetworkPolicy），可做细粒度安全控制
- 性能高，适合大规模集群和多租户场景
- 支持纯三层网络（无Overlay）、也支持IPIP/VXLAN等Overlay模式

**适用场景**：对网络安全、隔离、性能有较高要求的生产环境

#### Flannel
**类型**：CNI插件之一，主打"简单易用"

**主要特点**
- 只提供基础的Pod网络互通（L2/L3），不支持网络策略
- 实现方式多样，常用VXLAN、host-gw等模式
- 配置简单，资源消耗低，适合小型或入门级K8S集群

**适用场景**：对网络安全、隔离要求不高，追求部署简单的场景

#### 面试答题万能句式
> "CNI是K8S的容器网络接口标准，定义了网络插件的规范。Calico和Flannel都是CNI插件，Calico支持三层路由和网络安全策略，适合生产环境；Flannel只提供基础网络互通，配置简单，适合小型集群。实际生产中，Calico用得更多，Flannel适合入门和测试。"


deployment的作用
“Deployment是K8s里最常用的控制器，用来管理无状态Pod。它能自动维护Pod副本数，支持滚动更新、回滚、自动重建等，还能配合HPA/VPA实现自动扩缩容，是保证应用高可用的核心机制。”

pod 可以有多个进程吗
 "Pod可以有多个进程。一个Pod可以包含一个或多个容器，每个容器内部可以有多个进程。比如Nginx容器，除了主进程外，还有多个worker进程；MySQL容器除了主进程外，还可能有维护进程。这是正常的，因为一个应用通常需要多个进程协作。Kubernetes的设计原则是'一个容器一个主应用'，而不是'一个容器一个进程'。"

pod创建的过程调用了哪些组件


你个人觉得k8s这个技术真的提高了你的工作效率，或者提高了部门的工作效率吗？

### K8S与Docker的关系

#### 联系
**容器技术本质相同**
- 无论是K8S还是Docker，底层用的都是Linux的cgroups、namespace等技术实现资源隔离和进程封装
- 容器镜像格式、运行机制基本一致
- K8S最初就是基于Docker容器运行时开发的

**早期K8S集群**
- 节点上的容器都是通过Docker引擎启动和管理的
- K8S调度Pod，Pod里的每个容器本质上就是一个Docker容器

**镜像生态完全兼容**
- K8S拉取、运行的镜像格式和Docker完全一致，都是OCI标准镜像

#### 区别
**定位不同**
- Docker：是一个单机容器引擎，负责容器的构建、运行、管理
- K8S：是一个容器编排平台，负责多节点集群中容器的调度、伸缩、健康检查、服务发现等

**容器运行时的变化**
- 早期K8S直接调用Docker作为容器运行时（CRI接口）
- K8S 1.20+ 开始弃用Docker，推荐使用containerd、CRI-O等更轻量的容器运行时
- 但K8S运行的容器和Docker容器本质上没区别，只是底层调用的引擎不同

**管理对象不同**
- Docker直接管理容器（docker run、docker ps等）
- K8S管理的是Pod（Pod可以包含一个或多个容器），通过YAML定义，自动调度和管理

**功能范围不同**
- Docker只解决容器本地生命周期管理
- K8S解决集群级别的自动化部署、弹性伸缩、负载均衡、服务发现、滚动升级等

#### 面试答题万能句式
> K8S中的容器和Docker容器本质上是一样的，都是基于Linux内核的隔离技术，镜像格式也完全兼容。区别在于，Docker是单机容器引擎，负责容器的构建和运行，而K8S是容器编排平台，负责集群中容器的调度和管理。K8S早期直接用Docker作为容器运行时，后来逐步转向containerd等更轻量的运行时，但K8S运行的容器和Docker容器本质没有区别。

### K8S vs Docker 优势对比

#### K8S管理的优势

**自动化部署与扩缩容**
- K8S可以根据负载自动扩展或缩减容器实例数量，提升资源利用率和系统弹性

**服务发现与负载均衡**
- K8S内置服务发现机制，自动为服务分配访问地址，并实现流量的负载均衡

**自愈能力**
- 容器异常退出后，K8S会自动重启、替换，保证服务高可用

**滚动更新与回滚**
- 支持无缝升级应用，发现问题可一键回滚，降低发布风险

**统一资源调度与管理**
- 可以统一管理多台服务器上的资源，自动调度容器到合适的节点

**声明式配置与版本管理**
- 通过YAML文件声明集群状态，方便配置管理和版本控制

**多租户与安全隔离**
- 支持命名空间、RBAC等机制，实现多团队/多项目安全隔离

#### 回滚机制实现

**回滚的原理**
- K8S的Deployment在每次更新（比如升级镜像、修改配置）时，都会自动保存一个"历史版本"
- 这些历史版本包括了Pod模板的所有关键信息（如镜像、环境变量、启动参数等）
- 如果新版本有问题，可以让Deployment回退到之前的某个版本，K8S会自动帮你把Pod替换成老版本的配置

**回滚的操作**
```bash
# 查看历史版本
kubectl rollout history deployment/你的deployment名

# 一键回滚到上一个版本
kubectl rollout undo deployment/你的deployment名

# 回滚到指定版本
kubectl rollout undo deployment/你的deployment名 --to-revision=版本号
```

### 工作负载类型对比

#### Deployment vs StatefulSet

**Deployment特性**
- Pod命名：随机后缀 (web-abc123)
- 启动顺序：并行启动
- 存储：共享存储或无状态
- 网络标识：无固定标识
- 扩缩容：随机删除Pod
- 适用场景：无状态应用 (nginx, api)

**StatefulSet特性**
- Pod命名：有序编号 (web-0, web-1)
- 启动顺序：顺序启动 (0→1→2)
- 存储：每个Pod独立持久存储
- 网络标识：稳定的DNS名称
- 扩缩容：按序号倒序删除
- 适用场景：有状态应用 (数据库, 消息队列)

**使用场景**
- Deployment：Web服务器、API服务、微服务
- StatefulSet：MySQL、Redis、Kafka、Elasticsearch

#### 其他工作负载类型

deployment和deamonset的区别。
 "Deployment适合无状态应用，可以控制副本数量，支持扩缩容和滚动更新。DaemonSet在每个节点上运行一个Pod，适合日志收集、监控代理等系统级服务，Pod数量由节点数量决定。"
 
**DaemonSet**
- 确保每个节点上都运行一个Pod
- 常用于日志、监控等场景

**Job**
- 一次性任务，保证任务成功完成

**CronJob**
- 定时任务，周期性运行Job

**ReplicaSet、Pod**
- 基础的副本控制和最小部署单元

#### 有状态和无状态区别

**有状态服务（Stateful）**
- 指服务需要持久化数据或有唯一标识
- 重启后需保持原有状态
- 比如数据库、用户账号等

**无状态服务（Stateless）**
- 不依赖本地持久化数据
- 重启后不会影响业务
- 比如大多数Web应用

statefulset分配序号的机制说一下
好的，对于statefulset来说，我们使用其创建特定个数副本时，它就会开始动态维护序号。比如说我们原先有个pod 0挂掉了，它就检测到pod0的位置处有空缺，就会创建新的pod来继承我们pod0的位置，就相当于序号只是一个逻辑身份机制。

statefulset为了维护“有状态性”，使用了哪些方法
1.一是序号机制，statefulset为每个pod分配了唯一的序号，当扩缩容或者驱逐删除迁移pod时，都会根据
序号来进行处理。维护了pod操作的有序性
2.二是固定主机号机制，每个pod的主机号都是固定的，同时会动态解析DNS该主机号到你当前pod的一个临时ip，对用户来说无感
3.三是存储卷固定机制，因为对于statefulset来说，pvc会根据pvc名+pod名来创建pvc，pvc再绑定我们的pv，但因为我们的pod的的名字是有不变序号的，所以当重新绑定pvc时，新创建的pod就会继承我们的pv，形成数据

CPU1000m代表一个CPU核心
cpu500m代表0.5个CPU核心


说说k8s中NodePort和CluserIP的区别
NodePort：集群外可访问
ClusterIP：集群内可访问

Qos等级：
尽力而为级，所有容器都没设置request和limits，资源不足时优先被祛除
突发级，至少一个容器设置了request和limits，且request<limites，内存不足时可能会被驱逐
保证级，limits=request，资源紧张时最后被驱逐，获得完全的资源保障

为什么需要Pod这个概念，而不是直接管理容器？
多个容器可以作为一个整体被一起协同调度管理，实现生命周期。pod有变车容器和初始化容器等容器，方便进行容器编排，同时，一个pod内的容器共享ip和端口，方便进行容器间的通信。

Service是如何实现负载均衡的？
通过podselector实现选择pod进行流量转发

### 资源创建流程

#### 整体流程
如果是通过deployment声明式创建的话，deployment控制器会根据我们的定义副本数创建删除pod，会拉取容器里的对应镜像，如果存在volume挂载，或者是pvc/tls的话，会实现对应的pvc/tls与挂载，k8s会帮我自动完成PVC的绑定与挂载。然后kubelet会帮我们执行健康检查。

### 外部流量路径

#### 腾讯云平台流量路径
1. 在我们腾讯云平台上，腾讯云平台提供云LB负载均衡，能够把流量转发到ingress controller上
2. ingress controller实现了我们ingress的转发规则
3. 需要注意的是，现在腾讯云平台有直通机制，可以不用走ingress controller到service的路程，直接从ingress controller，直接转发流量到对应的pod

#### 非腾讯云平台流量路径
如果不是腾讯云平台，那就是流量转发ingress controller，再转发到service，service再转发到我们的pod

#### Gateway API
新版k8s还有个gateway，相当于是ingress的增强版。

**Gateway概念**
- Gateway就像是K8S集群的"流量大门"
- 它监听80端口（或443等），接收外部进入集群的流量
- Gateway本身不直接决定流量转发到哪个Service或Pod，而是把流量交给HTTPRoute（或TCPRoute等）来做具体的路由分发

**HTTPRoute作用**
- HTTPRoute里定义了"哪些请求（如路径、主机名）转发到哪些后端服务（Service）"

**流量路径**
```
[外部流量] 
     ↓
[Gateway 监听80端口]
     ↓
[HTTPRoute 匹配路由规则]
     ↓
[后端 Service/Pod]
```

### K8S面试要点

k8spod拉不起应该怎么排查
1. 先用 get pod 看看副本状态对不对，再用describe 排查一下是不是容器镜像下拉失败了，可能需要换镜像源或者换镜像
2. 再用 log pod 查看pod日志,可能是我们镜像代码就存在着错误,但没有报错,所以拉不起
3. 再用-o yaml 查看实际的配置文件,看看是不是volume和PVC挂载失败了， 比如 PVC对应的PV实际上不存在导致绑定失效，或者路径不存在。
4. 再看看集群剩余的CPU/内存资源，当它们不够，达不到pod的request需求时，pod会启动失败。
5. 查看存储还够不够，存储不够可能会导致拉不起。

#### Namespace资源隔离

**作用**
- 逻辑分组：将集群资源划分为不同的虚拟集群
- 资源隔离：不同namespace的资源名称可以重复
- 权限控制：结合RBAC实现细粒度权限管理
- 资源配额：通过ResourceQuota限制namespace资源使用

**重要澄清**
- 网络隔离：默认情况下，不同namespace的Pod可以互相访问，需要NetworkPolicy来实现真正的网络隔离
- 调度控制：Namespace本身不控制Pod调度位置，需要nodeSelector、亲和性等机制

#### K8S健康检查(Probe)

**三种探针类型**
livenessProbe（存活探针）
作用：检测容器是否正常运行
失败后果：重启容器
使用场景：检测应用是否死锁或无响应
readinessProbe（就绪探针）
作用：检测容器是否准备好接收流量
失败后果：从 Service 的 Endpoints 中移除
使用场景：检测应用是否完成初始化
startupProbe（启动探针）
作用：检测容器是否完成启动
失败后果：如果失败，其他探针不会启动
使用场景：给慢启动应用更多时间

在Kubernetes中，Liveness Probe（存活探针）和 Readiness Probe（就绪探针）有什么核心区别？请分别描述一个最适合使用它们的典型场景。另外，你了解 Startup Probe（启动探针）吗？它解决了什么问题？
它们的核心区别是探测失败后的操作。对于存活探针来说，比如说你出现了进程的死锁，存活探针多次探测失败之后，就会重启我们的容器，作为一个解决问题的操作。对于就绪探针来说，它是为了应对于应用初始化的场景，比方说你有一个java的pod，，需要将大量数据存到缓存中，这时候如果有流量涌进来，实际上此时pod是还不可以进行正常运转的，我们的就绪探针失败时就会帮我们先停止将流量转发到这个pod上面去，准备好处理业务的pod才能接收到流量。启动探针则是作为我们的一个为慢启动容器提供探针的一个方式，避免一些慢启动的容器被存活探针误判为已经死去而不断重启导致的业务失效。


在Kubernetes中，什么是Namespace？它的作用是什么？请说明默认情况下K8s集群中有哪些系统Namespace？
namespace是k8s中用来进行资源管理，资源隔离，权限控制的一种机制。默认的系统namespace有default，kube-proxy，kube-system等，kube-pubilc等。
