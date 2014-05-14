#!/bin/bash

yum_repo_auth=user:password

# make it strict
set -o errexit
set -o nounset

# export http_proxy
if [ ! -z "${http_proxy:-}" ]; then
	echo "Using http proxy: $http_proxy"
	export http_proxy
fi

# disable fastestmirror
sudo sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf

# install epel
# sudo -E yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# use jaist mirror
# sudo -E sed -i 's/download.fedoraproject.org\/pub/ftp.jaist.ac.jp\/pub\/Linux\/Fedora/' /etc/yum.repos.d/epel.repo

# disable mirror list to take advantage of cache
sudo -E sed -e 's/^mirrorlist=/#mirrorlist=/' -e 's/^#baseurl=/baseurl=/g' -i /etc/yum.repos.d/CentOS-Base.repo # /etc/yum.repos.d/epel*.repo

# add openuc yum repo
sudo -E wget -O /etc/yum.repos.d/openuc-14.10.0-centos.repo http://"$yum_repo_auth"@download.ezuce.com/openuc-stage/14.10-unstable/openuc-14.10.0-centos.repo

# update
sudo yum clean all
sudo -E yum -y update

# install utilities
sudo -E yum -y install vim git byobu telnet

# install dkms for vbox host kernel modules
sudo -E yum -y install dkms

# install openuc
sudo -E yum -y install openuc
# sudo -E yum -y install reach-app reach-config openuc-reports-server

# remove openuc setup
sudo rm /etc/sipxpbx/sipxecs-setuprc

# # add license
# sudo cp /vagrant/*.lic /etc/sipxpbx/

# always retry sipxconfig from httpd
sudo sed -i -E 's/ProxyPass\s+.*/\0 retry=0/' /etc/sipxpbx/sipxconfig/sipxconfig-apache.conf
# always accept from eth0
sudo -E iptables -I INPUT -i eth0 -j ACCEPT
sudo -E service iptables save

# remove persistent rules
sudo -E sed -i '/eth[1-2]/d' /etc/udev/rules.d/70-persistent-net.rules

# fix sipxecs-setup losing primary
sudo -E sed -i 's/\(change = \)\(\$prompt\[:noui\]\)\( || \)\(.*\)/\1\4 unless \2/' /usr/bin/sipxecs-setup

# set sipxecs to use eth1
sudo -E sed -i.orig -e 's/$(sys.interface)/eth1/' -e 's/$(sys.ipv4)/$(sys.ipv4[eth1])/' /usr/share/sipxecs/cfinputs/sipx.cf
sudo -E sed -i.orig -e 's/$(sys.ipv4)/$(sys.ipv4[eth1])/' /usr/share/sipxecs/cfinputs/hostname.cf

# bind freeswitch
sudo -E sed -i.orig '/<X-PRE-PROCESS.*default_password/i\
  <X-PRE-PROCESS cmd="set" data="local_ip_v4=10.24.7.14"/>
' /etc/sipxpbx/freeswitch/vars.xml.vm
