$serverNaam = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
$collectionNaam = "RemoteApssCollection"

try{
   New-RDSessionDeployment -ConnectionBroker $serverNaam `        -SessionHost $serverNaam `        -WebAccessServer $serverNaam -ErrorAction Stop
   Restart-Computer -Wait -Confirm
   Write-Host "Created new RDS deployment on: $serverName"
   
   New-RDSessionCollection -CollectionName $collectionNaam `        -ConnectionBroker $serverNaam `        -SessionHost $serverNaam -ErrorAction Stop
  
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