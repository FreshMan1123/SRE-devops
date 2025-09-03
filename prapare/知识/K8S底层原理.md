说说k8s的watch机制
watch机制其实也就是有变化就主动发送信息通知，避免轮询造成的资源浪费。
示例：
Deployment Controller → API Server → etcd
                     ↑             ↑
              HTTP watch      etcd watch
              监听Deployment    监听/registry/deployments/
客户端到api server建立http watch，使用长连接，api server与etcd同样也建立watch，api server是etcd客户端，外界服务由api server向etcd交互。
watch机制使得k8s能实时监听资源变化，当watch建立，同时数据发生变化时，api server会向etcd写入数据，etcd通知api server数据有变化了，然后再向api server推送数据，api server推送给客户端

客户端与apiserver的watch长连接可能会因为网络问题中断。当客户端重新发起watch时，它如何确保自己没有错过在连接中断期间发生的任何资源变更事件？
通过resourceVersion来实现的，resourceVersion是全局记录etcd数据修改的版本号。当api server向客户端发送修改事件时，会随着附送一个resource version，假设此时客户端断联，则会从客户端最后一个接收到的resource version进行重传

说说k8s的manager collector是怎么维护集群期望状态的
通过list-watch机制维护集群期望状态，首先是启动时获取全量数据，使用list来向api server获取当前所有pod的状态并记录。然后是持续的增量数据，会往api server建立watch，然后持续监听集群状态的变化，当出现与期望状态不同时，进行矫正

manager collector怎么矫正集群状态的
通过调谐循环来矫正集群状态，首先是会跟api server建立watch，然后当有pod发生变化时，会往manager collector推送事件，manager collector接收到之后通过api server查询 etcd对应事件的期望状态以及集群最新的当前状态，并进行对比，若不符合则进行矫正

你提到了调谐循环，那么Controller是如何避免重复调谐的？如果多个Controller同时处理同一个资源会怎样？
1.controller操作具有幂等性，多次执行结果相同
2.每个资源通常只有一个controller负责管理

重新复述一个一个deployment创建的过程吧
首先是 kubectl向api server发送创建请求，api server进行鉴权，并把数据存到etcd，然后manager collecotr接收到集群期望状态变化，发现与当前状态不一致，则拉起一个新的deployment，并通过拉起多个副本，将数据存到etcd中。然后因为scheduler watch 了api server，所以其会检测到变化并进行调度，调度到节点后，由kubele发送给容器运行时，容器运行时拉镜像开端口挂存储，再由CNI分配ip地址，最后kubelete将数据发给api server，api server再保存到etcd，此时就可以通过kubectl get deployment找到对应的deployment了

manager controller 有几种
deployment collertor，statefulset controller，daemonset controller，node controller，service controller等等，凡是需要维护期望状态的其实都有controller

说说k8s的etcd数据机制
1. 版本控制，etcd会为全部数据变更分配统一的一套版本号，并基于这个版本号实现增量更新以及历史版本查询回滚
2. 强一致性，基于raft算法保证数据的一致性
3. 租约特性，TTL过期自动删除
4. 高可用性，一般三或五个节点部署
5. 支持事务，支持事务特性


raft算法是什么
数据一致性算法，有一个leader和多个follower，leader将数据往follower写入，当多数follower确认后提交返回client。当leader宕机时，follower会进行选举，选出新的leader


CSI插件是什么
用于连接k8s和各个存储系统的容器存储接口标准

Volume生命周期
1. 供应，管理员创建pv
2. 绑定，pvc绑定特定的pv
3. 使用
4. 释放，删除pvc后，pv所处的状态
5. 回收，有不同的回收策略，1.保留数据手动清理 2.删除数据并删除pv 3.删除数据并回收复用pv

pv的多种访问模式分别有哪些，代表什么
1. ReadWriteOnce ，只可以被一个节点上的pod以读写方式挂载
2. ReadOnlyMany，允许被多个节点上的pod以只读方式挂载
3. readwritemany，允许被多个节点上的pod以读写方式挂载

多副本情况下，是pvc根据模板名称加pod名称创建pvc并绑定pv吗
在deployment下，多个副本共用一个pvc。statefulset下，多个副本c根据模板名称加pod名称创建pvc并绑定pv