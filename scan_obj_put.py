import oci, pyclamd
from base64 import b64decode

bucket_scan = "bucket1"
bucket_quarentine = "quarentine"
region = "sa-saopaulo-1"
streamingID = "ocid1.stream.oc1.sa-saopaulo-1.amaaaaaaay4fmgaax5ttloxb52w7nfkqqgueytfjreoagds3dtgyn5bye74a"
endpoint = "https://cell-1.streaming.sa-saopaulo-1.oci.oraclecloud.com"

signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
streaming = oci.streaming.StreamClient(config={}, service_endpoint=endpoint, signer=signer)
object_storage_client = oci.object_storage.ObjectStorageClient(config={}, signer=signer)
namespace = object_storage_client.get_namespace().data
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
        object_name = file.split(',')[8].split(':')[1].replace('"','')
        scan_obj = object_storage_client.get_object(namespace, bucket_scan, object_name)
        # Scan object
        retmessage = cdsocket.scan_stream(scan_obj.data.content)
        print("Bucket: {0} - Object: {1} - Result: {2}".format(bucket_scan, object_name, retmessage))
        # If found move to bucket quarentine
        if retmessage.get('stream')[0] == "FOUND":
            print("Mensagem {0}".format(retmessage.get('stream')[1]))
            cur_obj_detail = oci.object_storage.models.CopyObjectDetails()
            cur_obj_detail.source_object_name = object_name
            cur_obj_detail.destination_region = region
            cur_obj_detail.destination_namespace = namespace
            cur_obj_detail.destination_bucket = bucket_scan
            cur_obj_detail.destination_object_name = "copied"
            output = object_storage_client.copy_object(namespace, bucket_scan, cur_obj_detail)
            print("output: {0} ".format(output.value))
