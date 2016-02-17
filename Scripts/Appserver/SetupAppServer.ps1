# Script for automated install and configuration

# Join a domain
$domainName = Read-Host 'Give the domain name you wish to join.'
Add-Computer -DomainName $domainName

# Set update-rules
$WUSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
$WUSettings.NotificationLevel=2
#NotificationLevel  :
#0 = Not configured;
#1 = Disabled;
#2 = Notify before download;
#3 = Notify before installation;
#4 = Scheduled installation;
$WUSettings.save()

# Set reg-key
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

# Set Remote desktop role

# Install software