#!/bin/bash

pip3 install oci pyclamd

echo "ClamAV Install Started"
yum -y install clamav clamav-scanner-systemd
ln -s /etc/clamd.d/scan.conf /etc/clamd.conf
echo "LocalSocket /run/clamd.scan/clamd.sock" >>/etc/clamd.conf
setsebool -P antivirus_can_scan_system 1
freshclam
systemctl start clamd@scan
systemctl enable clamd@scan
echo "ClamAV Install Ended"

echo "Scan objects"
wget -P /root https://raw.githubusercontent.com/Everson4t/antivirus-for-objectstore/main/scan_bucket.py
chmod 744 /root/scan_bucket.py
/usr/bin/python3 /root/scan_bucket.py checkinobj quarantine >> /root/report.txt