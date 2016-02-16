#Chocolatey

##Installeren packages

###To install:
- Access
- chrome
- Excel
- (4 Finance Explorer) 
- kitty (http://www.9bis.net/kitty/?page=Download)
- firefox
- Outlook
- Powerpoint
- Word

### basis script:

		choco install msaccess2010-redist-x64 -y
		choco install googlechrome -y
		choco install kitty.portable -y
		choco install firefox -y

Werkt voor alle 4 (Acces misschien niet 100%).   

Excel, Powerpoint en Word zijn deel van Office.
[Office Home Premium](https://chocolatey.org/packages/Office365HomePremium)

--> Erros bij installeren??

Gebruik van iso voor Office:

[Chocolatey wiki](https://github.com/chocolatey/choco/wiki/How-To-Mount-An-Iso-In-Chocolatey-Package)


Outlook en finance explorer geen chocolatey package. (Zelf maken?)

## Werking Chocolatey ([nieuwe packages](https://github.com/chocolatey/choco/wiki/CreatePackages))

Chocolatey maakt volgens een standaard template een nieuwe package aan. 

		Choco new $packageNaam

De package wordt aangemaakt in de Directory waar je het commando uitvoert.
In de map vind je enkele files waarvan 2 zeer belangrijk zijn. de **.nuspec** en **chocolateyInstall.ps1**.

### [ChocolateyInstall.ps1](https://github.com/chocolatey/choco/wiki/ChocolateyInstallPS1)

Hier komt een PowerShell script dat de package uiteindelijk installeert. Dit moet je zelf aanpassen naar de specificaties van elke package.

### .nuspec

Dit is de template die gebruikt wordt om de install files te packagen. Als het installscript correct werkt wordt dit normaal vanzelf ingevuld.

Nadat je het install script aangepast hebt moet je de package inpakken. Dit doe je door:

		choco pack

of   

		cpack
  
Als dit slaagt test je de package door in PowerShell

		choco install package-name -s "$pwd" -f

[Alle helper functies](https://github.com/chocolatey/choco/wiki/HelpersReference)

## Package via ISO (Office2013)

basis code in chocolateyInstall.ps1:

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

nuspec file aanpassen tot:

	<?xml version="1.0" encoding="utf-8"?>
	<!-- Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one. -->
	<package xmlns="http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd">
  	<metadata>
    <!-- Read this before publishing packages to chocolatey.org: https://github.com/chocolatey/chocolatey/wiki/CreatePackages -->
    <id>office2013</id>
    <title>office2013 (Install)</title>
    <version>1.0.0</version>
	<authors>LucasClaeys</authors>
	<description>Full Office installation from ISO
    </description>
    <tags>office2013 admin SPACE_SEPARATED</tags>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
  	</metadata>
  	<files>
    <file src="tools\**" target="tools" />
  	</files>
	</package>

Hierna zou **cpack** moeten werken. 
Om een silent install uit te voeren moet je ook nog de **config.xml** van Office zelf aanpassen.
De file vind je in de ISO onder **ProPlus\WWW**.
Hierna moet je wel een nieuwe ISO burnen zodat de nieuwe xml file bij de andere bestanden staat.    

Hierna test je de package door in de folder van u package (waar de nupkg staat)

		choco install packageName -fdv -s $pwd -y

uit te voeren.
