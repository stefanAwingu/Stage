# Remote Desktop Role

## Script

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

