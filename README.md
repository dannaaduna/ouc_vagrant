ouc_vagrant
===========

Workarounds for vagrant environment

```
sudo -E sed -i.orig '/<X-PRE-PROCESS.*default_password/i\
  <X-PRE-PROCESS cmd="set" data="local_ip_v4=10.24.7.14"/>
' /var/sipxdata/cfdata/1/vars.xml
```
