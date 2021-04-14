variable "tenancy_ocid" {}
variable "private_key_path" {}
variable "fingerprint" {}
variable "user_ocid"{}
variable "compartment_ocid" {}
variable "region" {}

variable "ScanVCN_CIDR" { 
  default = "172.16.0.0/16"
}

variable "Scan_subnet_public_CIDR" {
  default = "172.16.0.0/24"
}

variable "instance_shape" {
  default = "VM.Standard2.1"
}

#  Oracle Developer image "ol79-dev-RC1-jan-2021-img-21.01-16"
variable "OraDev_Image_OCID" {
    default = "ocid1.image.oc1..aaaaaaaasoykfuuflr4ks6zxxmj5astynromw3f523gcylgdonlwe4dbvaaq"
}
