(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')))>$null 2>&1
choco install googlechrome -y
choco install kitty.portable -y
choco install firefox -y
