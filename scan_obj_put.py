import oci, pyclamd
from base64 import b64decode

bucket_name = "bucket1"
streamingID = "ocid1.stream.oc1.sa-saopaulo-1.amaaaaaaay4fmgaax5ttloxb52w7nfkqqgueytfjreoagds3dtgyn5bye74a"
endpoint = "https://cell-1.streaming.sa-saopaulo-1.oci.oraclecloud.com"

signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
streaming = oci.streaming.StreamClient(config={}, service_endpoint=endpoint, signer=signer)
object_storage_client = oci.object_storage.ObjectStorageClient(config={}, signer=signer)
cdsocket = pyclamd.ClamdUnixSocket()

cursor_detail = oci.streaming.models.CreateCursorDetails()
cursor_detail.partition = "0"
cursor_detail.type = "TRIM_HORIZON"
cursor = streaming.create_cursor(streamingID, cursor_detail)
r = streaming.get_messages(streamingID, cursor.data.value)

if len(r.data):
    for message in r.data:
        file = b64decode(message.value).decode('utf-8')
		# Get object from Bucket
        scan_obj = object_storage_client.get_object(object_storage_client.get_namespace().data, bucket_name, file.split(',')[8].split(':')[1].replace('"',''))
        # Scan object
        print("Bucket: {0} - Object: {1} - Result: {2}".format(bucket_name,file.split(',')[8].split(':')[1].replace('"',''),cdsocket.scan_stream(scan_obj.data.content)))
