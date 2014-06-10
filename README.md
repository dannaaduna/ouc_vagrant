ouc_vagrant
===========

Workarounds for vagrant environment

Server 1 (10.24.7.14)

```
sudo -E sed -i.orig '/<X-PRE-PROCESS.*default_password/i\
  <X-PRE-PROCESS cmd="set" data="local_ip_v4=10.24.7.14"/>
' /var/sipxdata/cfdata/1/vars.xml
```

```
sudo -E sed -i.orig '/<X-PRE-PROCESS.*default_password/i\
  <X-PRE-PROCESS cmd="set" data="local_ip_v4=10.24.7.15"/>
' /var/sipxdata/cfdata/2/vars.xml
```

```
sudo -E sed -i.orig '/<X-PRE-PROCESS.*default_password/i\
  <X-PRE-PROCESS cmd="set" data="local_ip_v4=10.24.7.14"/>
' /etc/sipxpbx/freeswitch/conf/vars.xml
```

Server 2 (10.24.7.15)

```
sudo -E sed -i.orig '/<X-PRE-PROCESS.*default_password/i\
  <X-PRE-PROCESS cmd="set" data="local_ip_v4=10.24.7.15"/>
' /var/sipxdata/cfdata/2/vars.xml
```

```
sudo -E sed -i.orig '/<X-PRE-PROCESS.*default_password/i\
  <X-PRE-PROCESS cmd="set" data="local_ip_v4=10.24.7.15"/>
' /etc/sipxpbx/freeswitch/conf/vars.xml
```
