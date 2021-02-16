output "public-ip-for-compute-instance" {
  value = oci_core_instance.ScanInstance.public_ip
}

output "private-ip-for-compute-instance" {
  value = oci_core_instance.ScanInstance.private_ip
}
 
output "Streaming-id" {
  value = oci_streaming_stream.ScanStream.id
}

output "Streaming-endpoint" {
  value = oci_streaming_stream.ScanStream.messages_endpoint
}
