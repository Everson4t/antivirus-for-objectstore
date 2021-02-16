terraform {
  required_version = ">= 0.12.0"
}

# Required by the OCI Provider
#
variable compartment_ocid {}
variable region {}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}


