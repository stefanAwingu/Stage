import azure.mgmt.compute
import connection
from azure.mgmt.common import SubscriptionCloudCredentials

vm_name = 'TestPyDeploy2'
group_name = 'arm-deployment'
auth_token = connection.connect()
subscription_id = connection.subscription()
creds = SubscriptionCloudCredentials(subscription_id, auth_token)

compute_client = azure.mgmt.compute.ComputeManagementClient(creds)

compute_client.virtual_machines.begin_deleting(resource_group_name=group_name,vm_name=vm_name)
