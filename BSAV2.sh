#!/bin/bash

pip3 install oci pyclamd

echo "Install and Update ClamAV Started"
yum -y install clamav clamav-scanner-systemd
ln -s /etc/clamd.d/scan.conf /etc/clamd.conf
echo "LocalSocket /run/clamd.scan/clamd.sock" >>/etc/clamd.conf
setsebool -P antivirus_can_scan_system 1
freshclam
systemctl start clamd@scan
systemctl enable clamd@scan
echo "ClamAV Installation Ended"
