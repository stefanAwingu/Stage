$WUSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
$WUSettings.NotificationLevel=2
#NotificationLevel  :
#0 = Not configured;
#1 = Disabled;
#2 = Notify before download;
#3 = Notify before installation;
#4 = Scheduled installation;
$WUSettings.save()