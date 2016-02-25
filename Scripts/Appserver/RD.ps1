#Get FQDN of verander dit en geef FQDN van remote server in
           <#(Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain#>
$collectionNaam = "RemoteApssCollection"

Function Deploy($servernaam){
try{
   #Maakt nieuwe Remote Desktop Session role aan met ConnectionBroker, SessionHost en WebAccesServer (gelijk aan quickinstall via GUI)
   #Problem: Kan niet local runnen dus moet vanuit een andere desktop uit hetzelfde domein
   #Problem: WebAccessServer is required en maakt een webserver aan, mag dit??
   New-RDSessionDeployment -ConnectionBroker $serverNaam `        -SessionHost $serverNaam `        -WebAccessServer $servernaam -Verbose

   #Restart bij Error van bij ConnectionBroker validation die vaak voorkomt (en opgelost is na 1 restart)
   #ToDo: Automatisch script verder zetten na restart remote server?
   if($Error[0].ToString() -match "The server has reboots pending and needs to be restarted."){
            Restart-Computer -ComputerName $serverNaam -Force -Verbose -Wait
            
       New-RDSessionDeployment -ConnectionBroker $serverNaam `       -SessionHost $serverNaam `       -WebAccessServer $servernaam -Verbose  
    }
       
   #Maakt eigen Collection aan
   New-RDSessionCollection -CollectionName $collectionNaam `        -ConnectionBroker $serverNaam `        -SessionHost $serverNaam -Verbose
   
   #Publisht alle apps met de nodige commandline settings
   New-RDRemoteApp -Alias Acces -DisplayName Acces -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\MSACCESS.EXE" `       -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam -CommandLineSetting Allow
   New-RDRemoteApp -Alias Outlook -DisplayName Outlook -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\OUTLOOK.EXE" `       -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam -CommandLineSetting Allow
   New-RDRemoteApp -Alias Excell -DisplayName Excell -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE" `       -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam -CommandLineSetting Allow
   New-RDRemoteApp -Alias Word -DisplayName Word -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\WINWORD.EXE" `       -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam -CommandLineSetting Allow
   New-RDRemoteApp -Alias PowerPoint -DisplayName PowerPoint -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\POWERPNT.EXE" `
       -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam -CommandLineSetting Allow
    New-RDRemoteApp -Alias Chrome -DisplayName Chrome -FilePath "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" `        -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
    New-RDRemoteApp -Alias FireFox -DisplayName FireFox -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" `        -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
   New-RDRemoteApp -Alias Kitty -DisplayName Kitty -FilePath "C:\ProgramData\chocolatey\bin\kitty.exe" `       -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
    New-RDRemoteApp -Alias Explorer -DisplayName 'Finance Explorer' `        -FilePath "C:\Tools\financeexplorer\FinanceExplorerPortable\FinanceExplorerPortable.exe" -ShowInWebAcces 1 `        -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
}
catch{
   Write-Host "Er is een fout opgetreden."   
   Write-Error $_.Exception.Message
}
}

Deploy($args[0])