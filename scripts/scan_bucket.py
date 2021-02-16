import oci, sys, time, pyclamd
bucket_name = sys.argv[1]
bucket_quarantine = sys.argv[2]
signer = oci.auth.signers.InstancePrincipalsSecurityTokenSigner()
region = signer.region
client = oci.object_storage.ObjectStorageClient(config={}, signer=signer)
namespace = client.get_namespace().data
cdsocket = pyclamd.ClamdUnixSocket()
# read objects list from bucket
response = client.list_objects(namespace,bucket_name)
for obj in response.data.objects:
   print("Objects: {0} ".format(obj.name))
   # Get object from Bucket
   scan_obj = client.get_object(namespace, bucket_name, obj.name)
   # Scan object
   retmessage = cdsocket.scan_stream(scan_obj.data.content)
   print("Bucket: {0} - Object: {1} - Result: {2}".format(bucket_name, obj.name, retmessage))
   # If virus found move (copy & delete) to bucket quarantine
   if retmessage is not None:
      print("Virus Found {0}".format(retmessage.get('stream')[1]))
      cur_obj_detail = oci.object_storage.models.CopyObjectDetails()
      cur_obj_detail.source_object_name = obj.name
      cur_obj_detail.destination_region = region
      cur_obj_detail.destination_namespace = namespace
      cur_obj_detail.destination_bucket = bucket_quarantine
      cur_obj_detail.destination_object_name = obj.name
      resp_cp = client.copy_object(namespace, bucket_name, cur_obj_detail)
      cp_complete = False
      while not cp_complete:
         resp_wr = client.get_work_request(resp_cp.headers.get('opc-work-request-id'))
         print("Copying infected object to quarantine... Status {0} - obj_name {1} - request  '{2}'".format(resp_cp.status, obj.name, resp_wr.data.status))
         if resp_wr.data.status == 'COMPLETED': 
            cp_complete = True
         else:    
            time.sleep(3)
      print("Copying infected object to quarantine... Status {0} - obj_name {1} - request  '{2}'".format(resp_cp.status, obj.name, resp_wr.data.status))
      if cp_complete:
         resp_del = client.delete_object(namespace, bucket_name, obj.name)
         resp_wr = client.get_work_request(resp_cp.headers.get('opc-work-request-id'))
         print("Deleting virus... status {0} ".format(resp_wr.data.status))
