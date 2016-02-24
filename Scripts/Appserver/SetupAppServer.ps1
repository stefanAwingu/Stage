# Script for automated install and configuration appserver
$ErrorActionPreference = 'Silent'
function setupRegKey{

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
}

function addToDomain{
$domainName = "awingu.test"
$password = "Hackaton2015" | ConvertTo-SecureString -asPlainText -Force
$username = "cloud3" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domainName -Credential $credential -Restart
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

function resumeAfterBoot{
    set-location HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce
    new-itemproperty . MyKey -propertytype String -value "Powershell $PSCommandPath"
}

function setDNS{
    $dnsAddress = Read-Host 'Give the dns address you wish to set'
    Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses $dnsAddress

}

function Expand-ZIPFile($file, $destination){
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace($file)
    foreach($item in $zip.items())
    {
    $shell.Namespace($destination).copyhere($item)
    }
    }

function installSoftware{
     # Get the nupkg files
    $url = "http://172.26.17.11/files/nupkg.zip"
    $output = "$PSScriptRoot\nupkg.zip"

    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $output)

    #unzipe the file
    Expand-ZIPFile –File $output –Destination $PSScriptRoot

    #Install Apps
    choco install googlechrome -y
    choco install kitty.portable -y
    choco install firefox -y
    cd $PSScriptRoot
    choco install office.1.0.0.nupkg -fdv -s $pwd -y
    choco install financeexplorer.8.0.0.nupkg -fdv -s $pwd -y
}

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
