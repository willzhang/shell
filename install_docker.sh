#!/bin/bash
#install docker-ce
set -e

#指定安装的docker版本
docker_version=docker-ce

#安装依赖软件包
yum install -y yum-utils \
	device-mapper-persistent-data \
	lvm2 \
	git
	
#导入yum源	
yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#安装docker
yum install -y $docker_version

##启动docker服务
systemctl start docker.service && systemctl enable docker.service

##配置阿里云镜像加速
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://uyah70su.mirror.aliyuncs.com"]
}
EOF

#重启docker服务
systemctl daemon-reload && systemctl restart docker.service

#查看docker版本
echo "#########The installation finished! docker version##########"
docker --version
