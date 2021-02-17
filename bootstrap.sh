#!/bin/bash
#
pip3 install oci pyclamd
#
echo "Install and Update ClamAV Started"
yum -y install clamav clamd 
ln -s /etc/clamd.d/scan.conf /etc/clamd.conf
echo "LocalSocket /run/clamd.scan/clamd.sock" >>/etc/clamd.conf
echo "StreamMaxLength 1000M" >>/etc/clamd.conf
/usr/sbin/setsebool -P antivirus_can_scan_system 1 
/usr/bin/freshclam 
/usr/bin/systemctl start clamd@scan 
/usr/bin/systemctl enable clamd@scan 
echo "ClamAV Installation Ended"
