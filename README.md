# devops-netology

### 1)
### vagrant @ vagrant: $ ps -e | grep node_exporter
>4336? 00:00:00 node_exporter 
### vagrant @ vagrant: $ systemctl stop node_exporter 
>==== AUTHENTICATION FOR org.freedesktop.systemd1.manage-units 
=== Stopping 'node_exporter.service' requires authentication. Authenticate as: vagrant ,,, (vagrant) Password: 
==== AUTHENTICATION DONE === 
### vagrant @ vagrant: $ ps -e | grep node_exporter 
### vagrant @ vagrant: $ systemctl start node_exporter 
>==== AUTHENTICATION FOR org.freedesktop.systemd1.manage-units 
=== Authentication is required to run 'node_exporter.service'. Authenticate as: vagrant ,,, (vagrant) Password: ==== AUTHENTICATION DONE === 
### vagrant @ vagrant: $ ps -e | grep node_exporter 7055? 00:00:00 node_exporter 
### vagrant @ vagrant: $ $ sudo nano /etc/systemd/system/node_exporter.service 
```editorconfig
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
Group=node_exporter
EnvironmentFile=-/etc/sysconfig/node_exporter
ExecStart=/usr/local/bin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
```
### vagrant @ vagrant: /etc/systemd/system $ sudo cat /proc/7055/Environment 
>LANG=en_US.UTF-8LANGUAGE=en_US:PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
INVOCATION_ID=0fcb24d52895405c875cbb9cbc28d3ffJOURNAL_STREAM=9:35758MYVAR=some_value

### 2)
>CPU:
>>    node_cpu_seconds_total{cpu="0",mode="idle"} 2238.49
    node_cpu_seconds_total{cpu="0",mode="system"} 16.72
    node_cpu_seconds_total{cpu="0",mode="user"} 6.86
    process_cpu_seconds_total
    
>Memory:
>>    node_memory_MemAvailable_bytes 
    node_memory_MemFree_bytes
    node_memory_MemTotal_bytes
    
>Disk(если несколько дисков то для каждого):
>>    node_disk_io_time_seconds_total{device="sda"} 
    node_disk_read_bytes_total{device="sda"} 
    node_disk_read_time_seconds_total{device="sda"} 
    node_disk_write_time_seconds_total{device="sda"}
    
>Network(так же для каждого активного адаптера):
>>    node_network_receive_errs_total{device="eth0"} 
    node_network_receive_bytes_total{device="eth0"} 
    node_network_transmit_bytes_total{device="eth0"}
    node_network_transmit_errs_total{device="eth0"}
 ### 3)
Приложил скриншот
 ### 4)
Приложил скриншот, да возможно с помощью команды dmesg | grep virtual
 ### 5) 
### vagrant@vagrant:~$ /sbin/sysctl -n fs.nr_open
1048576
Это максимальное число открытых дескрипторов для ядра
Число задается кратное 1024, в данном случае =1024*1024. 

Макс предел :
### vagrant@vagrant:~$ cat /proc/sys/fs/file-max
>9223372036854775807

### vagrant@vagrant:~$ ulimit -Sn
1024
мягкий лимит (так же ulimit -n)на пользователя

### vagrant@vagrant:~$ ulimit -Hn
1048576
жесткий лимит на пользователя (не может быть увеличен, только уменьшен)

### 6)
### root@vagrant:~# ps -e |grep sleep
 >  1953 pts/2    00:00:00 sleep
   
### root@vagrant:~# nsenter --target 1953 --pid --mount

### root@vagrant:/# ps
>    PID TTY          TIME CMD
      2 pts/0    00:00:00 bash
     11 pts/0    00:00:00 ps
> 
## 7)
Это рекурсия, процесс запускающий самого себя.
Если установить ulimit -u 50 - число процессов будет ограниченно 50 для пользоователя. 


