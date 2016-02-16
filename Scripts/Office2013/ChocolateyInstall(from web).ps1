try {
  $sysDrive = $env:SystemDrive
  $officePath = "$sysDrive\Users\azure\AppData\Local\Temp\office"
  $packageName = 'office'
  $Path = $officePath+'\setup'
  $configArg = '/config ' + $officePath+'\proplus.WW\config.xml'
 
  if(test-path $officePath) {
    write-host "Cleaning out the contents of $officePath"
    Remove-Item "$($officePath)\*" -recurse -force
  }
   
  Install-ChocolateyZipPackage 'office' 'http://172.26.17.11/files/Office.zip' $officePath
  Install-ChocolateyInstallPackage 'office' 'EXE' $configArg $Path


  write-host 'Office has been installed.'
  Write-ChocolateySuccess 'Office'
} catch {
  Write-ChocolateyFailure 'Office' $($_.Exception.Message)
  throw 
}