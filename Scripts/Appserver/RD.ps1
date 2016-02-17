$serverNaam = Read-Host "Give your FQDN"
$collectionNaam = "RemoteApssCollection"

New-RDSessionDeployment -ConnectionBroker $serverNaam -SessionHost $serverNaam -WebAccessServer $serverNaam
New-RDSessionCollection -CollectionName $collectionNaam -ConnectionBroker $serverNaam -SessionHost $serverNaam

New-RDRemoteApp -Alias Acces -DisplayName Acces -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\MSACCESS.EXE" -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
New-RDRemoteApp -Alias Outlook -DisplayName Outlook -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\OUTLOOK.EXE" -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
New-RDRemoteApp -Alias Excell -DisplayName Excell -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\EXCEL.EXE" -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
New-RDRemoteApp -Alias Word -DisplayName Word -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\WINWORD.EXE" -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
New-RDRemoteApp -Alias PowerPoint -DisplayName PowerPoint -FilePath "C:\Program Files (x86)\Microsoft Office\Office15\POWERPNT.EXE" -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
New-RDRemoteApp -Alias Google Chrome -DisplayName Chrome -FilePath "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
New-RDRemoteApp -Alias Mozilla FireFox -DisplayName FireFox -FilePath "C:\Program Files\Mozilla Firefox\firefox.exe" -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
New-RDRemoteApp -Alias Kitty -DisplayName Kitty -FilePath "C:\ProgramData\chocolatey\bin\kitty.exe" -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 
New-RDRemoteApp -Alias Finance Explorer -DisplayName Finance Explorer -FilePath "C:\Tools\financeexplorer\FinanceExplorerPortable\FinanceExplorerPortable.exe" -ShowInWebAcces 1 -CollectionName $collectionNaam -ConnectionBroker $serverNaam 

$apps = {Acces;Outlook;Excell;Word;PowerPoint;Chrome;FireFox;Kitty;FinanceExplorer}

foreach($element in $apps){
    Get-RDRemoteApp -DisplayName $element
    Set-RDRemoteApp -CollectionName $collectionNaam -CommandLineSetting Allow
}