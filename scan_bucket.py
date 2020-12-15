import sys, oci, pyclamd
bucket_name = sys.argv[1]
signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
object_storage_client = oci.object_storage.ObjectStorageClient(config={}, signer=signer)
cdsocket = pyclamd.ClamdUnixSocket()
# read objects list from file
with open('/root/objects.txt') as file:
   for line in file:
       line = line.strip()
       # Get object from Bucket
       scan_obj = object_storage_client.get_object(object_storage_client.get_namespace().data, bucket_name, line)
       # Scan object
       print("Bucket: {0} - Object: {1} - Result: {2}".format(bucket_name,line,cdsocket.scan_stream(scan_obj.data.content)))
       # Move object (copy + delete)
       