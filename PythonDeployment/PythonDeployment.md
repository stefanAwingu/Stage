#Python Deployment

## JSON

## Python

## Python Remoting

### WinRM (PyWinRM)

On Target Server in PowerShell:

		winrm set winrm/config/client/auth '@{Basic="true"}'
		winrm set winrm/config/service/auth '@{Basic="true"}'
		winrm set winrm/config/service '@{AllowUnencrypted="true"}'

On the host Linux server add the ip-address and FQDN in the `/etc/hosts` file. 

## Installing Apps

## Remote Desktop Role

