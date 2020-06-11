#Copyright: GNU GENERAL PUBLIC LICENSE
#author: James Meers

#Source path 64bit
$SourceFileADP = "C:\Program Files (x86)\ADP\webSuite TE\Config\adp.zvt"
$SourceFileADP50 = "C:\Program Files (x86)\ADP\webSuite TE\Config\adp50.zvt"

#Source path 32bit
$SourceFileADP32 = "C:\Program Files\ADP\webSuite TE\Config\adp.zvt"
$SourceFileADP5032 = "C:\Program Files\ADP\webSuite TE\Config\adp50.zvt"

#Destination path for both
$DestinationFileADP = "C:\Users\User\Documents\BlueZone\Config\adp.zvt"
$DestinationFileADP50 = "C:\Users\User\Documents\BlueZone\Config\adp50.zvt"
Try
{
      
      If ($OS.Caption -like '*Windows 7*') {
      #If it is a windows 64 run this
        If ($OS.OSArchitecture -eq '64-bit') { 
        $wshell.Popup("64bit installing",0,"Done")
        Copy-Item -Path $SourceFileADP -Destination $DestinationFileADP -Force #Copy and overwrite file at destination
        Copy-Item -Path $SourceFileADP50 -Destination $DestinationFileADP50 -Force #Copy and overwrite file at destination
    }else{
          #If it is a windows 32 run this
        $wshell.Popup("32bit installing",0,"Done")
        Copy-Item -Path $SourceFileADP32 -Destination $DestinationFileADP -Force #Copy and overwrite file at destination
        Copy-Item -Path $SourceFileADP5032 -Destination $DestinationFileADP50 -Force #Copy and overwrite file at destination
    }else{
          #error
    $wshell.Popup("Your system Architecture can't be found",0,"Done")
}
}
}
Catch
{
    #error
    $wshell.Popup("Close ADP and Try Again",0,"Done")
}
