# Software install & basic configuration #
## Adjusting the registry key values
First things first, we need to adjust the values of the registry keys. This need to be done before the reboot, since you can't adjust them with the script while booting. 

    $values=@(
             "TLS_RSA_WITH_AES_128_CBC_SHA256",
             "TLS_RSA_WITH_AES_128_CBC_SHA",
             "TLS_RSA_WITH_AES_256_CBC_SHA256",
             "TLS_RSA_WITH_AES_256_CBC_SHA",
             "TLS_RSA_WITH_RC4_128_SHA",
             "TLS_RSA_WITH_3DES_EDE_CBC_SHA",
             "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256",
             "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P384",
             "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256",
             "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P384",
             "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256",
             "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P384",
             "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P256",
             "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P256",
             "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P384",
             "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384_P384",
             "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P256",
             "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P384",
             "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P256",
             "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P384",
             "TLS_DHE_DSS_WITH_AES_128_CBC_SHA256",
             "TLS_DHE_DSS_WITH_AES_128_CBC_SHA",
             "TLS_DHE_DSS_WITH_AES_256_CBC_SHA256",
             "TLS_DHE_DSS_WITH_AES_256_CBC_SHA",
             "TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA",
             "TLS_RSA_WITH_RC4_128_MD5",
             "SSL_CK_RC4_128_WITH_MD5",
             "SSL_CK_DES_192_EDE3_CBC_WITH_MD5",
             "TLS_RSA_WITH_NULL_SHA256",
             "TLS_RSA_WITH_NULL_SHA"
             )
    Set-ItemProperty -Path HKLM:SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\SSL\00010002 -Name functions -Value $values

First we assign the values to a variable. After this we use the cmdlet *Set-ItemProperty* to assign the values to the reg key.

## Join a domain ##
First we need to configure the dns settings. In this script we will ask the user for an input. Since we are not sure what dns we going to use. After the input we use the cmdlet *Set-DNSClientServerAddress* to configure the dns settings.

	$dnsAddress = Read-Host 'Give the dns address you wish to set'
    Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $dnsAddress

Now we still need to join a domain. Again we will ask the user for an input since we are not sure what domain to join.

	$domainName = Read-Host 'Give the domain name you wish to join.'
	Add-Computer -DomainName $domainName -Restart
	if($Error[0].ToString() -match "The specified domain either does not exist or could not be contacted"){
    Write-Host "Please enter a valid domain name."
    $Error.Clear()
    addToDomain
 	}
	elseIf($Error[0].ToString() -match "The user name or password is incorrect"){
    Write-Host "Please enter a valid user name or password."
    $Error.Clear()
    addToDomain   
 	}
 	}
I did some error-catching here. But the problem is that PowerShell doesn't provide error codes. So we solved that problem with checking for a specific string in the error message.

## Continue script after reboot ##
Since we need to reboot the machine after joining a domain. We need to put the script in a registry key named *run once*. This will make sure the script will run one time after a first reboot.

	set-location HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce
    new-itemproperty . MyKey -propertytype String -value "Powershell $PSCommandPath"

## Install software ##
 Now we going to install the software, this will happen during the boot. We use a webserver where we put our needed files, we will download the files from the server and unzip it. This is done by a small function I found on the internet.

	  
    $url = "http://172.26.17.11/files/nupkg.zip"
    $output = "$PSScriptRoot\nupkg.zip"

    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $output)

   
    Expand-ZIPFile –File $output –Destination $PSScriptRoot


    choco install googlechrome -y
    choco install kitty.portable -y
    choco install firefox -y
    cd $PSScriptRoot
    choco install office.1.0.0.nupkg -fdv -s $pwd -y
    choco install financeexplorer.8.0.0.nupkg -fdv -s $pwd -y

The unzip function:

	function Expand-ZIPFile($file, $destination){
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace($file)
    foreach($item in $zip.items())
    {
    $shell.Namespace($destination).copyhere($item)
    }
    }

## Everything combined

I put every part in a function and now we need to call the functions to work. Here we also make sure we allowed a firewall rule and we installed chocolatey. This is needed since we are using the chocolatey package for installing the software with commands.

	#Check if this computer already part of a domain, if not, join the domain.
	if ((gwmi win32_computersystem).partofdomain -eq $false) {
    # Set reg-key
    setupRegKey
    # Resume this script after a boot
    resumeAfterBoot
    # Set the dns to the ad-server IP
    setDNS
    # Enable WMI firewall rule
    Enable-NetFirewallRule -DisplayName "Windows Management Instrumentation (WMI-In)"
    # Join a domain
    addToDomain
	}else{
    #Install software
    #Step 1. Install chocolatey
    (iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
    #Step 2. Install the software
    installSoftware
	}


