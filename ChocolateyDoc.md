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