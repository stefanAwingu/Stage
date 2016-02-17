#Get FQDN
$serverNaam = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
$collectionNaam = "RemoteApssCollection"
#aparte webserver poging
$webAccesServer = "Webserver.awingu.test"

try{
   #Maakt nieuwe Remote Desktop Session role aan met ConnectionBroker, SessionHost en WebAccesServer (gelijk aan quickinstall via GUI)
   #Problem: Kan niet local
   #Problem: WebAccessServer is required en maakt een webserver aan (niet ideaal) -> Onze webserver als target proberen meegeven maar dit geeft meer errors.
   New-RDSessionDeployment -ConnectionBroker $serverNaam `

   #Restart bij Error van bij ConnectionBroker validation die vaak voorkomt (en opgelost is na 1 restart)
   #ToDo: Automatisch script verder zetten na restart remote server?
   if($Error[0].ToString() -match "The server has reboots pending and needs to be restarted."){
        if($Error[0].ToString() -match "RD Web Access server"){
            Restart-Computer -Confirm -ComputerName $webAccesServer -Force
        }
        else{
            Restart-Computer -Confirm -ComputerName $serverNaam -Force
        }    
    }
       
   #Maakt eigen Collection aan
   New-RDSessionCollection -CollectionName $collectionNaam `
   
   #Publisht alle apps met de nodige commandline settings
   New-RDRemoteApp -Alias Acces -DisplayName Acces -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\MSACCESS.EXE" `
   New-RDRemoteApp -Alias Outlook -DisplayName Outlook -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\OUTLOOK.EXE" `
   New-RDRemoteApp -Alias Excell -DisplayName Excell -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE" `
   New-RDRemoteApp -Alias Word -DisplayName Word -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\WINWORD.EXE" `
   New-RDRemoteApp -Alias PowerPoint -DisplayName PowerPoint -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\POWERPNT.EXE" `
       -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam -CommandLineSetting Allow
    New-RDRemoteApp -Alias Chrome -DisplayName Chrome -FilePath "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" `
    New-RDRemoteApp -Alias FireFox -DisplayName FireFox -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" `
   New-RDRemoteApp -Alias Kitty -DisplayName Kitty -FilePath "C:\ProgramData\chocolatey\bin\kitty.exe" `
    New-RDRemoteApp -Alias Explorer -DisplayName 'Finance Explorer' `
}
catch{
   Write-Host "Er is een fout opgetreden."   
   Write-Error $_.Exception.Message
}