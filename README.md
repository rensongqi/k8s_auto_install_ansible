# 1 Ansible auto install k8s

目前暂时只支持单master节点安装

需要注意k8s每个节点的配置都需要满足官方最低配置

# 2 Ansible configuration

## 2.1 配置hosts形如
```
[master]
192.168.0.30 node_name=master

[node]
192.168.0.31 node_name=node01
192.168.0.32 node_name=node02
```

## 2.2 配置全局变量，主要配置k8s版本等信息
```
# vim /etc/ansible/group_vars/all.yml

# k8s version [1.18.3/1.19.4/...]
# 支持大多数版本
k8s_version: '1.19.4'

# network plugin [flannel/calico]
network_plugin: 'flannel'

# 集群网络规划
service_cidr: '10.96.0.0/12'
pod_cidr: '10.244.0.0/16'

# 集群IP规划，master暂时只支持一个，node可以有多个
hosts:
  master:
    - '192.168.0.30'
  node:
    - '192.168.0.31'
    - '192.168.0.32'
```

## 2.3 配置ssh免密认证

(1) 生成ssh-key
```
# 一直回车即可，不加-t则默认生成rsa密钥
ssh-keygen -t [rsa/dsa]
```
(2) 拷贝公钥至目标主机，需要输入一次目标主机的密码用于校验，验证完成后后续都不需要二次验证
```
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.30
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.31
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.32
```
(3) 修改ansible配置文件，于`/etc/ansible/ansible.cfg`文件中更改
```
private_key_file = /root/.ssh/id_rsa
```

## 2.4 开始安装
```
ansible-playbook k8s_single_master_install.yml
```

## 2.5 可以指定playbook的tag来操作不同的role
```
ansible-playbook k8s_single_master_install.yml --tags initial
```

# 3 注意事项

1. 此playbook使用前提是网络环境干净，即网络无限制，无ACL
2. 目前只支持单master多node安装，后续会加上多master安装
3. 安装时间受网络环境限制
