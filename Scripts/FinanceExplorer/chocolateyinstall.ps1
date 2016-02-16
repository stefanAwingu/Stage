try {
  $sysDrive = $env:SystemDrive
  $financeExplorerPath = "$sysDrive\tools\financeexplorer"
 
  if(test-path $financeExplorerPath) {
    write-host "Cleaning out the contents of $financeExplorerPath"
    Remove-Item "$($financeExplorerPath)\*" -recurse -force
  }
   
  Install-ChocolateyZipPackage 'financeexplorer' 'https://github.com/Xplendit/Finance-Explorer-Package/releases/download/test/FinanceExplorerPortable.zip' $financeExplorerPath
  Install-ChocolateyPath $financeExplorerPath
 
  write-host 'Finance Explorer has been installed.'
  Write-ChocolateySuccess 'Finance Explorer'
} catch {
  Write-ChocolateyFailure 'Finance Explorer' $($_.Exception.Message)
  throw 
}