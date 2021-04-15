terraform {
  required_version = ">= 0.12.0"
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  region           = var.region
  fingerprint      = var.fingerprint
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
}
