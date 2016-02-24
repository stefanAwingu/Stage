import azure.mgmt.resource
import connection
from azure.mgmt.common import SubscriptionCloudCredentials

deployment_name = 'TestDeployPython'
group_name = 'arm-deployment'
auth_token = connection.connect()
subscription_id = connection.subscription()
creds = SubscriptionCloudCredentials(subscription_id, auth_token)

resource_client = azure.mgmt.resource.ResourceManagementClient(creds)

template_link = azure.mgmt.resource.resourcemanagement.ParametersLink(
        uri='https://raw.githubusercontent.com/Xplendit/Stage/master/PythonDeployment/armTemplate1.json'
)

parameters_link = azure.mgmt.resource.resourcemanagement.TemplateLink(
        uri='https://raw.githubusercontent.com/Xplendit/Stage/master/PythonDeployment/Parameters.json'
)

properties = azure.mgmt.resource.resourcemanagement.DeploymentProperties(
        mode="incremental",
        template_link=template_link,
        parameters_link=parameters_link
)

deploy_parameter = azure.mgmt.resource.Deployment()
deploy_parameter.properties=properties

result = resource_client.deployments.create_or_update(
    resource_group_name=group_name,
    deployment_name=deployment_name,
    parameters= deploy_parameter
)
