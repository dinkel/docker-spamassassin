#!/bin/bash

# This is a hack, because 'spamd_address' does not expand hostnames (only in Exim >= 4.85)
spamd_ip=`grep 'spamassassin' /etc/hosts | cut -f1`
sed -i "s/spamd_address = \(.*\)$/spamd_address = $spamd_ip 783/g" /etc/exim4/exim4.conf

spamd --username debian-spamd \
      --nouser-config \
      --syslog stderr \
      --pidfile /var/run/spamd.pid \
      --helper-home-dir /var/lib/spamassassin \
      --ip-address \
      --allowed-ips 0.0.0.0/0
