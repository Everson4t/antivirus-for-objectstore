import sys, oci, pyclamd
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
   if retmessage.get('stream')[0] == "FOUND":
      print("Mensagem {0}".format(retmessage.get('stream')[1]))
      cur_obj_detail = oci.object_storage.models.CopyObjectDetails()
      cur_obj_detail.source_object_name = obj.name
      cur_obj_detail.destination_region = region
      cur_obj_detail.destination_namespace = namespace
      cur_obj_detail.destination_bucket = bucket_quarantine
      cur_obj_detail.destination_object_name = obj.name
      #resp_cp = client.copy_object(namespace, bucket_name, cur_obj_detail)
      print("resp_cp data: {0} - resp_cp status {1} - obj_name {2}".format(resp_cp.data, resp_cp.status, obj.name))
      if resp_cp:
         #resp_del = client.delete_object(namespace, bucket_name, obj.name)
         print("resp_del data: {0} - resp_del status {1} ".format(resp_del.data, resp_del.status))   
       