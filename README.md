# Low cost antivirus for object storage

Low cost Antivirus for Oracle Cloud object store 

## Overview

Improve security and maintain compliance by building a low cost antivirus to scan all your objects in a bucket and also scan an object when it is created using only an OCI instance and open source software.

You can store an unlimited amount of unstructured data of any content type in your internet-scale and high-performance object storage . You may want to run an antivirus to identify threats and then move those infected objects to another bucket called quarantine.

We are going to use Clamav open source antivirus engine for detecting trojans, viruses, malware and other malicious threats for this solution.

## Setup

You can spin up your instance on a different **Compartment** and a new **Virtual Cloud Network** using a VCN template or you can just start your instance on a existing subnet. It is all up to you. We are going to use a new compartment called **scan**. Besides that you'll need to setup the following resources:

### Object Storage

1. Select a bucket with objects to scan and enable *Emit Object Events* for this bucket
2. Create a bucket to move infected object to it (quarantine)

### Security 

3. Create a Dynamic Group with a rule that will qualify your instance **dyngroupscan**
4. Create a policy to allow your Dynamic Group to manage objects **policiescan**
```
Allow dynamic-group dyngroupscan to manage buckets in compartment scan
Allow dynamic-group dyngroupscan to manage objects in compartment scan
Allow dynamic-group dyngroupscan to manage stream-family in compartment scan
Allow service objectstorage-sa-saopaulo-1 to manage object-family in compartment scan
```
### Services

5. Create a stream to receive event from object creation.
6. Create an event to track object creation

### Instance 

7. Create a instance with **Oracle Developer Image** and **cloud-init** script

## Usage

## Roadmap

If you have ideas for releases in the future, it is a good idea to list them in the README.

## References

[Calling Services from an Instance:](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/callingservicesfrominstances.htm) \
[Managing Dynamic Groups:](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm) \
[Writing authorization policies for Dynamic Groups:](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Tasks/callingservicesfrominstances.htm#Writing) \
[OCI Command Line Interface (CLI):](https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm) \
[CLI supported OS and Python versions:](https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm#SupportedPythonVersionsandOperatingSystems) \
[OCI CLI Quick Start:](https://docs.cloud.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) \
[Instance Principals:](https://blogs.oracle.com/cloud-infrastructure/announcing-instance-principals-for-identity-and-access-management)

## Authors and acknowledgment

I'd like to say thanks to Fabio Silva and Fernando Costa who help me to build this project

## License

Clam AntiVirus is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

[Oracle](https://www.oracle.com).
`Inline code` with backticks
