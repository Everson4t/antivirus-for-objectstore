resource oci_identity_compartment ScanCompart { 
  description = "Scan"
  name = "Scan"
  compartment_id = var.compartment_ocid
}

resource oci_identity_dynamic_group ScanDynGroup {
  depends_on = [oci_core_instance.ScanInstance]
  compartment_id = var.compartment_ocid
  description = "ScanDynGroup"
  matching_rule = join("",["ANY { instance.id = '" , oci_core_instance.ScanInstance.id , "' }"])
  name = "ScanDynGroup"
}

resource oci_identity_policy ScanPolicy {
  depends_on = [oci_identity_dynamic_group.ScanDynGroup]
  compartment_id = var.compartment_ocid
  description = "ScanPolicy"
  name = "ScanPolicy"
  statements = [
    "Allow dynamic-group ScanDynGroup to manage buckets in tenancy",
    "Allow dynamic-group ScanDynGroup to manage objects in tenancy",
    "Allow dynamic-group ScanDynGroup to manage stream-family in compartment Scan",
    format("Allow service objectstorage-%s to manage object-family in tenancy", var.region)
  ]
}