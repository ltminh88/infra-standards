# Centos 6 - Ubuntu
## Copy file unicorn to /etc/init.d
```
cp unicorn /etc/init.d/unicorn
chmod +x etc/init.d/unicorn
```
### Start/stop service
```
/etc/init.d/unicorn start
/etc/init.d/unicorn stop
```
# Centos 7
# How i add Unicorn ( running as user deploy) to service with systemd
## Add file unicorn to init.d
```
cp unicorn /etc/init.d/unicorn
chmod +x etc/init.d/unicorn
```
## Copy file unicornup to folder bin
```
cp unicornup /usr/local/rails_apps/<PJ-NAME>/shared/bin/unicornup
chmod +x /usr/local/rails_apps/<PJ-NAME>/shared/bin/unicornup
```
## Copy file unicorn.service to systemd
```
cp unicorn.service /lib/systemd/system/unicorn.service
```
###Start/stop unicorn:
```
systemctl stop unicorn
systemctl start unicorn
```
###Add unicorn as service
```
systemctl enable unicorn
```
