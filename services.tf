resource "oci_events_rule" "ScanEventRule" { 
  #Required
  display_name    = "ScanEventRule"
  compartment_id  = oci_identity_compartment.ScanCompart.id
  is_enabled      = true  
  condition       = "{\"eventType\": \"com.oraclecloud.objectstorage.createobject\"}"
  actions {
    #Required
    actions {
      #Required
      action_type = "OSS"
      is_enabled  = true

      #Optional
      stream_id   = oci_streaming_stream.ScanStream.id
    }
  }
}

resource "oci_streaming_stream" "ScanStream" {
    #Required
    name       = "ScanStream"
    partitions = 1

    #Optional
    compartment_id = oci_identity_compartment.ScanCompart.id
}
