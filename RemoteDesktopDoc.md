# Remote Desktop Role

## Script
[https://github.com/Xplendit/Stage/blob/master/Scripts/Appserver/RD.ps1]()

The script uses the Remote-Desktop Powershell commands to install a Remote-Desktop Role and publish a selection of applications.

`New-RDSessionDeployment` Installs the role and configures your server as a RD-ConnectionBroker, RD-SessionHost and RD-WebAccessServer.

During this installation your server is validated, this will often give an error. The most common one "Your server has reboots pending and needs to be restarted." is caught by some basic Error-Handling (which will just reboot the target server).   
The other commonly encountered error is "You cannot restart the local server". This occurs when you run this script locally and there seems to be no fix for this.

`New-RDSessionCollection` Creates a collection where you can publish your applications.

And every remote application is published via `New-RDRemoteApp`. 

## Problems

### "You cannot restart the local server."

[https://social.technet.microsoft.com/Forums/en-US/4acdda0d-3181-4d23-ae05-4c72c59839d3/rd-session-deployment-using-powershell?forum=winserverTS]()

[http://ryanmangansitblog.com/2013/07/07/rds-session-depolyment-powershell-script-for-rds-2012/]()

[http://blogs.technet.com/b/supportingwindows/archive/2015/03/04/step-by-step-instructions-for-installing-rds-session-deployment-using-powershell-in-windows-server-2012-r2.aspx]()

### Workaround: remoting to localhost?

		Enter-PSSession -ComputerName localhost

Error: 
>  Validation failed for the "RD Connection Broker" parameter.  
> arm-test1.awingu.test      Unable to connect to the server by using Windows PowerShell remoting. Verify that you can connect to the server.

### Destkop onbruikbaar via remoting na install!!!

Na het manueel installeren van de Remote Desktop Role is de computer onbereikbaar na het heropstarten.

Flow gebruikt:

* Add Roles and Features
* Remote Desktop Service Installation
* Deployment Type: Quick Start
* Deployment Scenario: Session-based desktop deployment
* Op eigen server
* Installeert RD-ConnectionBroker, RD-WebAccessServer, RD-SessionHost (zelfde als met script)
* Herstart
* ???? 

