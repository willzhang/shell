#!/bin/sh
command_exists() {
   command -v "$@" > /dev/null 2>&1
}
get_distribution() {
        lsb_dist=""
        # Every system that we officially support has /etc/os-release
        if [ -r /etc/os-release ]; then
                lsb_dist="$(. /etc/os-release && echo "$ID")"
        fi
        # Returning an empty string here should be alright since the
        # case statements don't act unless you provide an actual value
        echo "$lsb_dist"
}
set -x
if ! command_exists docker; then
  lsb_dist=$( get_distribution )
        lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"
        echo "current system is $lsb_dist"
        case "$lsb_dist" in
                ubuntu|deepin|debian|raspbian|kylin)
                        cp docker.service /lib/systemd/system/docker.service
                ;;
                centos|rhel|ol|sles)
                        cp docker.service /usr/lib/systemd/system/docker.service
                ;;

                *)
                        echo "current system not support"
                        exit 1
                ;;
        esac
  tar --strip-components=1 -xvzf docker-*.tgz -C /usr/bin
  chmod a+x /usr/bin
  [ -d  /etc/docker/ ] || mkdir /etc/docker/  -p
cat > /etc/docker/daemon.json  << eof
{
  "registry-mirrors": [
     "https://bxsfpjcb.mirror.aliyuncs.com"
  ],
  "max-concurrent-downloads": 10,
  "log-driver": "json-file",
  "log-level": "warn",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
    },
  "insecure-registries": ["127.0.0.1"]
}
eof
  systemctl enable  docker.service
  systemctl restart docker.service
fi
# 已经安装了docker并且运行了, 就不去重启.
docker info || systemctl restart docker.service
