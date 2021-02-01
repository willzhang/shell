
监测/dev/vda2文件系统，空间使用大于85%时清理目录下日志文件


```shell
# cat base_logs_clean.sh 
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
```
[root@CMCC_wai shell]# crontab -l
23 23 * * 5 root /data/shell/base_logs_clean.sh
```
