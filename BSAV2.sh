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

oci os object list -bn bucket1 --auth instance_principal --query 'data[].name[]' | sed 's/[",]//g' | sed '1d;$d' >>/root/objects.txt

cat << EOF > /root/objscan.py
import oci, pyclamd
bucket_name = 'bucket1'
signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
object_storage_client = oci.object_storage.ObjectStorageClient(config={}, signer=signer)
cdsocket = pyclamd.ClamdUnixSocket()
# read objects list from file
with open('/root/objects.txt') as file:
   for line in file:
       line = line.strip()
       # Get object from Bucket
       scan_obj = object_storage_client.get_object(object_storage_client.get_namespace().data, bucket_name, line)
       # Scan object
       print("Bucket: {0} - Object: {1} - Result: {2}".format(bucket_name,line,cdsocket.scan_stream(scan_obj.data.content)))
EOF
chmod 744 /root/objscan.py
/usr/bin/python3 /root/objscan.py >> /root/report.txt


