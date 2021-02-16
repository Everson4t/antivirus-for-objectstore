# to source this file run:
# Set-ExecutionPolicy Bypass -Scope Process -Force; .\env-vars.ps1
# To print env variables
# Get-ChildItem Env:
#
$env:TF_VAR_compartment_ocid="ocid1.tenancy.oc1..aaaaaaaakn6jozwr2wul5aep6f56dwbhxfhl53cslbpl5gkivygrkxqzv3yq"
#
# Required for the OCI Provider
$env:TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaakn6jozwr2wul5aep6f56dwbhxfhl53cslbpl5gkivygrkxqzv3yq"
$env:TF_VAR_user_ocid="ocid1.user.oc1..aaaaaaaayq33opsntxpgwuef6n5vyori2vm5ebxvvmrggxalustna5qlgnca"
#
$env:TF_VAR_fingerprint = Get-Content (Resolve-Path "C:\Oradocs\Oracle Content\Sync\orcl_ocigen.fingerprint") -Raw -Encoding ASCII
$env:TF_VAR_private_key_path="C:\Oradocs\Oracle Content\Sync\orcl_ocigen.pem"
$env:TF_VAR_region="sa-saopaulo-1"
#
# Keys used to SSH to OCI VMs
$env:TF_VAR_ssh_public_key = Get-Content (Resolve-Path "C:\Oradocs\Oracle Content\Sync\orcl.pub") -Raw -Encoding ASCII
