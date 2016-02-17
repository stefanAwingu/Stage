# Script for automated install and configuration appserver
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
function resumeAfterBoot{
    set-location HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce
    new-itemproperty . MyKey -propertytype String -value "Powershell $PSScriptRoot\SetupAppServer.ps1"
}
function setDNS{
    Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses 172.26.17.4

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
    cd C:\Users\azure\Desktop
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
    Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses 172.26.17.4
    # Join a domain
    $domainName = Read-Host 'Give the domain name you wish to join.'
    Add-Computer -DomainName $domainName -Restart
}else{
    #Install software
    #Step 1. Install chocolatey
    (iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
    #Step 2. Install the software
    installSoftware


}