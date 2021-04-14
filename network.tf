resource oci_core_vcn ScanVCN {
  depends_on = [oci_identity_compartment.ScanCompart]
  cidr_block     = var.ScanVCN_CIDR
  compartment_id = oci_identity_compartment.ScanCompart.id
  defined_tags   = {}

  display_name = "ScanVCN"
  dns_label    = "scandns"
}

resource "oci_core_internet_gateway" "ScanIG" {
  display_name   = "SCAN-IGW"
  compartment_id = oci_identity_compartment.ScanCompart.id
  vcn_id         = oci_core_vcn.ScanVCN.id
}

resource "oci_core_route_table" "ScanRT" {
  display_name   = "ScanRT"
  compartment_id = oci_identity_compartment.ScanCompart.id
  vcn_id         = oci_core_vcn.ScanVCN.id

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.ScanIG.id
  }
}

resource "oci_core_security_list" "ScanSL" {
  display_name   = "ScanSL"
  compartment_id = oci_identity_compartment.ScanCompart.id
  vcn_id         = oci_core_vcn.ScanVCN.id

  egress_security_rules {
    protocol    = "All"
    destination = "0.0.0.0/0"
  }
  
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
   }
}

resource oci_core_subnet Scan_subnet_public {
  cidr_block     = var.Scan_subnet_public_CIDR
  compartment_id = oci_identity_compartment.ScanCompart.id
  defined_tags   = {}

  dhcp_options_id = oci_core_vcn.ScanVCN.default_dhcp_options_id
  display_name    = "ScanPubSub"
  dns_label       = "scandns"

  prohibit_public_ip_on_vnic = "false"
  route_table_id             = oci_core_route_table.ScanRT.id

  security_list_ids = [
    oci_core_security_list.ScanSL.id,
  ]

  vcn_id = oci_core_vcn.ScanVCN.id
}
