$dnsAddress = "172.26.17.4"
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $dnsAddress
$domainName = "awingu.test"
$password = "Hackaton2015" | ConvertTo-SecureString -asPlainText -Force
$username = "cloud3" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domainName -Credential $credential -Restart
