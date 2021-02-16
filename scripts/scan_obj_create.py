import oci, sys, time, pyclamd
from base64 import b64decode
#
bucket_scan = sys.argv[1]
bucket_quarantine = sys.argv[2]
streamingID = sys.argv[3]
endpoint = sys.argv[4]
#
signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
region = signer.region
streaming = oci.streaming.StreamClient(config={}, service_endpoint=endpoint, signer=signer)
client = oci.object_storage.ObjectStorageClient(config={}, signer=signer)
namespace = client.get_namespace().data
cdsocket = pyclamd.ClamdUnixSocket()
#
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
        scan_obj = client.get_object(namespace, bucket_scan, object_name)
        # Scan object
        retmessage = cdsocket.scan_stream(scan_obj.data.content)
        print("Bucket: {0} - Object: {1} - Result: {2}".format(bucket_scan, object_name, retmessage))
        # If virus found move to bucket quarantine
        if retmessage is not None:
            print("Mensagem {0}".format(retmessage.get('stream')[1]))
            cur_obj_detail = oci.object_storage.models.CopyObjectDetails()
            cur_obj_detail.source_object_name = object_name
            cur_obj_detail.destination_region = region
            cur_obj_detail.destination_namespace = namespace
            cur_obj_detail.destination_bucket = bucket_quarantine
            cur_obj_detail.destination_object_name = object_name
            resp_cp = client.copy_object(namespace, bucket_scan, cur_obj_detail)
            cp_complete = False
            while not cp_complete:
               resp_wr = client.get_work_request(resp_cp.headers.get('opc-work-request-id'))
               print("Copying infected object to quarantine... Status {0} - obj_name {1} - request  '{2}'".format(resp_cp.status, object_name, resp_wr.data.status))
               if resp_wr.data.status == 'COMPLETED': 
                  cp_complete = True
               else:    
                  time.sleep(3)
            print("Copying infected object to quarantine... Status {0} - obj_name {1} - request  '{2}'".format(resp_cp.status, object_name, resp_wr.data.status))
            if cp_complete:
               resp_del = client.delete_object(namespace, bucket_scan, object_name)
               resp_wr = client.get_work_request(resp_cp.headers.get('opc-work-request-id'))
               print("Deleting virus... status {0} ".format(resp_wr.data.status))
