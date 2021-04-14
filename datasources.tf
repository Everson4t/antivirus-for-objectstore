data "oci_identity_availability_domains" "availability_domains" { 
  compartment_id = oci_identity_compartment.ScanCompart.id
}

data "oci_objectstorage_namespace" "ns" {
    compartment_id = var.compartment_ocid
}