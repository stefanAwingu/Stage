    $dnsAddress = "172.26.17.4"
    Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $dnsAddress
