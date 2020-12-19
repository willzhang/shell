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
