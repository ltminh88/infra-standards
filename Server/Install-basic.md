#Ubuntu
## Add group admin
```
sudo groupadd admin
```
## Add user and group deploy
```
sudo useradd -m -d /home/deploy deploy  -s /bin/bash -G admin
```
##If you don't want to add user deploy group admin, you can config file sudoer (Staging is ok not in production)
```
sudo vim /etc/sudoer
```
Add this
```
deploy  ALL=(ALL)
```
if you don't want to type password. you can add this
```
deploy  ALL=(ALL)  NOPASSWD: ALL
```
## Update newest
```
sudo apt-get update
```
## Install  fail2ban
```
sudo apt-get install fail2ban
```

##Check openfile. This config is very importance, because User's openfile is 1024
Maximum number of open file
```
cat /proc/sys/fs/file-max
```
To see the hard and soft values, issue the command as follows:
```
ulimit -Hn
ulimit -Sn
```
To fix it, you can add new variable to kernel
```
vim /etc/sysctl.conf
```
Add this
```
fs.file-max =65536
```
User deploy level file descriptors (FD) limits
```
vim  /etc/security/limits.conf
```
Add this
```
deploy soft nofile 65536
deploy hard nofile 65536
```
Set user open max process
```
vi /etc/security/limits.d/90-nproc.conf
```
add line
```
	deploy soft nproc 65535
	deploy hard nproc 65535
	deploy soft nofile 65535
  deploy hard nofile 65535
```
### REBOOT SERVER TO MAKE ALL CONFIG RUNNING WELL

## Check firewall
Check port open
```
iptables -L
```
###If you are use staging, AWS, Azure or another cloud serivce you can disable it
```
/etc/init.d/ufw stop
chkconfig ufw off
```
### If you are use VPS, DO NOT STOP IPTABLES open port you want to public. In this guide i will open port 22,80,443
```
iptables -I INPUT 5 -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT 5 -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT 5 -i eth0 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
```
Save this config
```
service iptables save
```

#Centos
## Add user and group deploy
sudo useradd -m -d /home/deploy deploy  -s /bin/bash -G wheel
##If you don't want to add user deploy group wheel, you can config file sudoer (Staging is ok not in production)
```
sudo vim /etc/sudoer
```
Add this
```
deploy  ALL=(ALL)
```
if you don't want to type password. you can add this
```
deploy  ALL=(ALL)  NOPASSWD: ALL
```
## Stop SELINUX config
```
vim /etc/selinux/config
```
Change this line
```
SELINUX=enabled  --> SELINUX=disabled
```
Reboot server to active this config
If you don't want to restart server, you would use this command
```
setenforce 0
```
This command will disable SELINUX

##Check openfile. This config is very importance, because User's openfile is 1024
Maximum number of open file
```
cat /proc/sys/fs/file-max
```
To see the hard and soft values, issue the command as follows:
```
ulimit -Hn
ulimit -Sn
```
To fix it, you can add new variable to kernel
```
vim /etc/sysctl.conf
```
Add this
```
fs.file-max =65536
```
User deploy level file descriptors (FD) limits
```
vim  /etc/security/limits.conf
```
Add this
```
deploy soft nofile 65536
deploy hard nofile 65536
```
Set user open max process
```
vi /etc/security/limits.d/90-nproc.conf
```
add line
```
	deploy soft nproc 65535
	deploy hard nproc 65535
	deploy soft nofile 65535
  deploy hard nofile 65535
```
### REBOOT SERVER TO MAKE ALL CONFIG RUNNING WELL

## Check firewall
Check port open
```
iptables -L
```
###If you are use staging, AWS, Azure or another cloud serivce you can disable it
Centos 6
```
/etc/init.d/iptables stop
chkconfig iptables off
```
Centos 7
```
systemctl stop firewalld
systemctl disable firewalld
```
### If you are use VPS, DO NOT STOP IPTABLES open port you want to public. In this guide i will open port 22,80,443
```
iptables -I INPUT 5 -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT 5 -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT 5 -i eth0 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
```
Save this config
```
service iptables save
```
