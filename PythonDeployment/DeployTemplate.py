from azure.mgmt.resource import Deployment
from azure.mgmt.resource import DeploymentProperties
from azure.mgmt.resource import DeploymentMode
from azure.mgmt.resource import ParametersLink
from azure.mgmt.resource import TemplateLink
import azure.mgmt.resource
import azure.mgmt.compute
import connection
import azure.common
import azure.servicemanagement
import azure.storage
from azure.mgmt.common import SubscriptionCloudCredentials

deployment_name = 'MyDeployment'
group_name = 'arm-deployment'
auth_token = connection.connect()
subscription_id = connection.subscription()
creds = SubscriptionCloudCredentials(subscription_id, auth_token)

#compute_client = azure.mgmt.compute.ComputeManagementClient(creds)
resource_client = azure.mgmt.resource.ResourceManagementClient(creds)

template = TemplateLink(
    uri='https://raw.githubusercontent.com/Xplendit/Stage/master/PythonDeployment/armTemplate1.json'
)

result = resource_client.deployments.create_or_update(
   group_name,
   deployment_name,
   Deployment(
       properties=DeploymentProperties(
           mode=DeploymentMode.incremental,
           template_link=template,
       )
   )
)

#result = compute_client.virtual_machines.create_or_update(
#    group_name,
#)
