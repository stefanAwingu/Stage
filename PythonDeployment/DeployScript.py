import winrm

#ps_script = """
#$cred = Get-Credential awingu.test\cloud3 -Message "Please insert the password for the jumphost"
#
#$session = New-PSSession -ComputerName ad-server.awingu.test -Credential $cred
#
#$cldhost = "Demo-server.awingu.test"
#
#$script = C:/User/Public/Documents/Scripts/RD.ps1 -Verbose
#
#Invoke-Command -Session $session -ScriptBlock $script -ArgumentList $cred, $cldhost -Verbose
#Remove-PSSession $session
#"""

s = winrm.Session('172.26.17.4', auth=('cloud3@awingu.test','Hackaton2015'))


#r = s.run_ps(ps_script)
r = s.run_cmd("""powershell.exe -ExecutionPolicy Unrestricted -File C:\Users\Public\Documents\Scripts\RD.ps1 "Demo-server.awingu.test""""")

print r.std_out
print r.std_err
