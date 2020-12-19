#关闭firewall防火墙

```
systemctl disable --now firewalld
```

#关闭selinux

```
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
```

#配置时间同步

```
yum install -y chrony
systemctl enable --now chronyd
```


### Install latest version of dokcer-ce in centos7 or ubuntu
```
# install docker
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun && systemctl enable --now docker

# install docker with huaweicloud registry mirror
curl -fsSL https://raw.githubusercontent.com/willzhang/shell/master/docker-ce.sh | sh

# install docker-compose
curl -fs
