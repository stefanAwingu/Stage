		New-RDSessionDeployment -ConnectionBroker "fileserver.awingu.test" -SessionHost "fileserver.awingu.test" -WebAccessServer "fileserver.awingu.test"
		New-RDSessionCollection -CollectionName "TestApps" -ConnectionBroker "fileserver.awingu.test" -SessionHost "fileserver.awingu.test"
		New-RDRemoteApp -CollectionName "TestApps" -ConnectionBroker "fileserver.awingu.test" 