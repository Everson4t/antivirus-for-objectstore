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

bucket_name=bucket1

echo "List objects"
oci os object list -bn $bucket_name --auth instance_principal --query 'data[].name[]' | sed 's/[",]//g' | sed '1d;$d' >>/root/objects.txt

echo "Scan objects"
curl -O https://raw.githubusercontent.com/Everson4t/antivirus-for-objectstore/main/scan_bucket.py
chmod 744 /root/scan_bucket.py
/usr/bin/python3 /root/objscan.py $bucket_name >> /root/report.txt
