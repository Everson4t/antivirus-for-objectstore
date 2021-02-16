# Low cost antivirus for object storage

Low cost Antivirus for Oracle Cloud object store 

## Overview

Improve security and maintain compliance by building a low cost antivirus to scan all your objects in a bucket and also scan an object when it is created using only an OCI instance and open source software.

You can store an unlimited amount of unstructured data of any content type in your internet-scale and high-performance object storage . You may want to run an antivirus to identify threats and then move those infected objects to another bucket called quarantine.

We are going to use Clamav open source antivirus engine for detecting trojans, viruses, malware and other malicious threats for this solution.

![AVobj1.JPG](https://github.com/Everson4t/antivirus-for-objectstore/blob/main/images/AVobj1.JPG)

## Manual Setup

To setup this environment you need to have all the required privileges in the compartment or be part of an administrator group.

You can spin up your instance on a different **Compartment** and a new **Virtual Cloud Network** using a VCN Wizard or you can just start your instance on an existing subnet. It is all up to you.

We are going to use a new compartment called **scan** and also a VCN using the Wizard. Besides that you'll need to setup the following resources:

### Compartment and VCN
Create a new compartment called **scan** and annotate the compartment OCID. 
Create a VCN called **ScanVCN** using Wizard. 

### Object Storage

1. Select a bucket with objects to scan and enable **Emit Object Events** for this bucket. Name: **checkinobj**
2. Create a standard bucket to move infected object to it. Name: **quarantine**

### Security 

3. Create a Dynamic Group with a rule that will qualify your instance. Name: **ScanDynGroup**
``` 
All {instance.compartment.id = 'ocid1.compartment.oc1..aaaaaaaa......algq'} 
 ```
4. Create a policy to allow your Dynamic Group to manage objects. Name: **ScanPolicy**
```oci
Allow dynamic-group dyngroupscan to manage buckets in compartment scan
Allow dynamic-group dyngroupscan to manage objects in compartment scan
Allow dynamic-group dyngroupscan to manage stream-family in compartment scan
Allow service objectstorage-sa-saopaulo-1 to manage object-family in compartment scan
```
### Stream

5. Create a stream to receive event from object creation. Name **ScanStream**
for this component you need to annotate the streamID and endpoint 
```
streamingID = "ocid1.stream.oc1.sa-saopaulo-1.amaaaa......moxla"
endpoint = "https://cell-1.streaming.sa-saopaulo-1.oci.oraclecloud.com"
```
### Event
6. Create an event to track object create on bucket checkinobj and write to ScanStream. Name: **ScanRule**

### ssh Key par 
7. Generate a ssh key par to use with your instance.

## Setup Using the Terraform CLI

### Clone the Module

Now, you'll want a local copy of this repo. You can make that with the commands:
```
git clone https://github.com/Everson4t/antivirus-for-objectstore
cd antivirus-for-objectstore
ls
```

## Usage with SCAN 

### To scan your bucket do the following:
1. create a fake virus file to test the environment.
```
python3
import pyclamd
cdsocket = pyclamd.ClamdUnixSocket()
void = open('/root/EICAR_TEST','wb').write(cdsocket.EICAR())
```
2. upload the file you just created to checkinobj bucket.
```
oci os ns get --auth instance_principal
oci os object put -ns <namespace> -bn checkinobj --name infected_01.txt --file /root/EICAR_TEST --auth instance_principal
```
3. get and run the scan_bucket.py
```
wget https://raw.githubusercontent.com/Everson4t/antivirus-for-objectstore/main/scripts/scan_bucket.py
python3 scan_bucket.py checkinobj quarantine
```

## Usage with PROTECT

To protect your bucket scanning objects created on it do the following:
1. Create a Linux instance in the compartment scan.
2. Select the shape you need and **Oracle Developer Image**
3. Put the instance in your VCN and Subnet. 
4. Copy the **cloud-init** script for the instance. File: **BSAV2.sh**
5. Adjust the parameters **bucket_to_scan, bucket_quarantine, streamID, endpoint** !

## Roadmap and extensions 

1. Implement this solution with a different or commercial antivirus.  
2. Make the protect program a daemon to read the stream constantly.
3. Send an alert e-mail when a threat is found. 
4. Implement error handling, timeout and a better python program.
5. Any great idea you may have.

## References

[Calling Services from an Instance:](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/callingservicesfrominstances.htm) \
[Managing Dynamic Groups:](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm) \
[Writing authorization policies for Dynamic Groups:](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/callingservicesfrominstances.htm#Writing) \
[OCI Command Line Interface (CLI):](https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm) \
[CLI supported OS and Python versions:](https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm#SupportedPythonVersionsandOperatingSystems) \
[OCI CLI Quick Start:](https://docs.cloud.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) \
[Instance Principals:](https://blogs.oracle.com/cloud-infrastructure/announcing-instance-principals-for-identity-and-access-management)

## Authors and acknowledgment

I'd like to say thank you very much to Fabio Silva and Fernando Costa who help me to build this project

## License

Clam AntiVirus is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
