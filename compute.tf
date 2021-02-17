resource "oci_core_instance" "ScanInstance" {
  display_name        = "ScanInstance"
  compartment_id      = oci_identity_compartment.ScanCompart.id
  availability_domain = lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")
  shape               = var.instance_shape
  
  source_details {
    source_id   = var.OraDev_Image_OCID
    source_type = "image"
  }
  
  create_vnic_details {
    subnet_id        = oci_core_subnet.Scan_subnet_public.id
    hostname_label   = "scan"
    assign_public_ip = "true"
  }

  metadata = {
     ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
	   user_data = base64encode(file("./cloud-init.sh"))
  }
}
