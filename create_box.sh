#!/bin/bash

set -o errexit
set -o nounset

vagrant destroy -f
vagrant up

vagrant ssh -c "http_proxy=$http_proxy /vagrant/bootstrap.sh"

# reset and setup vboxadd
vagrant ssh -c "http_proxy=$http_proxy sudo -E yum -y upgrade"

vagrant reload || true # will fail due to upgrade in kernel
vagrant ssh -c "sudo /etc/init.d/vboxadd setup"

vagrant up # should succed now

# remove persistent rules
vagrant ssh -c "sudo sed -i 's/.*NAME=\"eth1\".*//' /etc/udev/rules.d/70-persistent-net.rules"

# rm -f package.box
# vagrant package

# dt_now=$( date +'%Y%m%d_%H%M' )
# dt=${dt:-$dt_now}

# dl_dir="/var/www/download.ezuce.ph/vagrant/openuc-stable-4.6-rpm"

# cp package.box "$dl_dir/openuc-stable-4.6-rpm_$dt.box"
# ln -sf "$dl_dir/openuc-stable-4.6-rpm_$dt.box" "$dl_dir/latest-stable-rpm.box"
