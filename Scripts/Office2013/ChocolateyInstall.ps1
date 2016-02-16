	try {
	    $iso = Get-Item 'C:\Users\azure1\Downloads\officeISO.iso'
	    Mount-DiskImage -ImagePath $iso
	    $driveLetter = (Get-DiskImage $iso | Get-Volume).DriveLetter
	    Install-ChocolateyInstallPackage "Office2013" "EXE" "/config \ProPlus.WW\config.xml" "${driveLetter}:\setup.exe" -validExitCodes 0, 3010
	    Dismount-DiskImage -ImagePath $iso
	}
	catch{
	    Dismount-DiskImage -ImagePath $iso
	}