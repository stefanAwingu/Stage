#Chocolatey

Chocolatey is a global PowerShell execution engine using the NuGet packaging infrastructure. Think of it as the ultimate automation tool for Windows.

Chocolatey is like apt-get, but built with Windows in mind (there are differences and limitations). For those unfamiliar with APT/Debian, think about Chocolatey as a global silent installer for applications and tools. It can also do configuration tasks and anything that you can do with PowerShell. 

## Installing chocolatey

In PowerShell (Administrator mode) run the command:

	(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1

##Useful commands

**install:**
`choco install <pkg|packages.config> [<pkg2> <pkgN>] [<options/switches>]`   

**uninstall:**   
You will likely have to use the automatic uninstaller feature, this has to be turned on via the following command:    
`choco feature enable -n autoUninstaller`
Then you can uninstall via:   
`choco uninstall <pkg|all> [pkg2 pkgN] [options/switches]`   

**list & search:**
`choco search <filter> [<options/switches>]`   
`choco list <filter> [<options/switches>]`   

**upgrade:**
`choco upgrade <pkg|all> [<pkg2> <pkgN>] [<options/switches>]`    

**outdated:**   
This shows a list of all the packages that need updates.    
`choco outdated [<options/switches>]`


#Our Version

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

### basic:

Google Chrome, Firefox and Kitty have existing packages in Chocolatey, so they can be installed simply by using `choco install`.

Every Office program (Acces, Excell, Outlook, Powerpoint and Word) and Finance Explorer will need to be installed seperatly via new packages. 

## [New packages](https://github.com/chocolatey/choco/wiki/CreatePackages)

When you use the `choco new ` command, Chocolatey makes a new directory with the name of the package. In this directory you'll find several files. A **.nuspec** file which contains the data for packaging your package. And a sub folder named "tools" which contains the ChocolateyInstall and ChocolateyUninstall Powershell scripts. These scripts need to be adjusted to the needs of your software program. 

### [ChocolateyInstall.ps1](https://github.com/chocolatey/choco/wiki/ChocolateyInstallPS1)

This will retrieve the installation files from the source you want (standard is from a http link) and pass these files with the necessary data to the ChocolateyPackager. It may be possible that you'll have to edit extra files, this is different for every program. (Uninstall works via the same principle.)

### .nuspec

This is the template that's used to package everything. Normally you shouldn't have to edit this very much, all the data you can enter is mostly optional and only necessary if you want to publish the package on the Chocolatey site.

Finally you can package your files with `choco pack` or `cpack`. 
  
You can test this (and also use the package) via:

		choco install package-name -s "$pwd" -f

[All helper functions and there documentation.](https://github.com/chocolatey/choco/wiki/HelpersReference)

## Package via ISO (Office2013)

basic code in chocolateyInstall.ps1:

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

edit .nuspec file:

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
The most important (and the only one that's required) tag is "version", this is required to have a value like for example: "1.2.3"   

To install Office "silently" you'll have to edit the **config.xml** file. You'll find it in the folder  **ProPlus\WWW**. The ISO will have to be rebuild with the correct file.  

	<Configuration Product="ProPlus">

	 <Display Level="none" CompletionNotice="no" SuppressModal="yes" AcceptEula="yes" /> 
	 
	 <Setting Id="SETUP_REBOOT" Value="Never" />
	 
	 <Setting Id="SETUP_REBOOT" Value="ReallySuppress" />
	
	
	</Configuration>

Next you use `cpack` to package everything. 
And finally you can use and test your package with:

		choco install packageName -fdv -s $pwd -y


##Links

[Choco wiki.](https://github.com/chocolatey/choco/wiki)
[How to install.](https://github.com/chocolatey/choco/wiki/Installation)