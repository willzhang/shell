
## example1
监测/dev/vda2文件系统，空间使用大于85%时清理日志目录下日志文件


```shell
disk_clean.sh
```
#!/bin/bash
fs=/dev/vda2
max_used=$(df -h | grep $fs |awk -F'[ %]+' '{print $5}')
val=85
log_path=/home/tools-admin/base/logs
if [ "$max_used" -gt "$val" ]
then
  find $log_path/ -mtime +15 -type f -name "log.log.*" | xargs rm -f
fi
```

定时任务，每周五晚23:23执行
```shell
[root@CMCC_wai shell]# crontab -l
23 23 * * 5 root /data/shell/base_logs_clean.sh
```


## example2

监控/data目录使用情况，大于85%则删除该目录下20天以前的数据

脚本示例
```
mkdir -p /data/disk_clean/

touch /data/disk_clean/disk_clean.sh

chmod +x /data/disk_clean/disk_clean.sh
```

```
#!/bin/bash
exec &>/data/disk_clean/clean.log
clean_dir=/data/test/
use_limit=85
use_radio=`df -h | grep -w "/" | awk '{print $5}' | cut -f 1 -d "%"`
if [ $use_radio -gt $use_limit ]
then
  echo -e "before_clean: \n$(df -h | grep -w "/")"
  find $clean_dir -mtime +20 -type f -name "*.txt" | xargs rm -rf
  echo -e "after_clean: \n$(df -h | grep -w "/")"
fi
```
定时任务：
每分钟执行一次
```
[root@localhost test]# crontab -e
23 23 * * 5 /data/test/test.sh

[root@localhost test]# crontab -l
*/1 * * * * /data/test/test.sh
```
测试方法：
```
fallocate -l 20G bigfile
touch -d "7/1/2019" test.txt
```
