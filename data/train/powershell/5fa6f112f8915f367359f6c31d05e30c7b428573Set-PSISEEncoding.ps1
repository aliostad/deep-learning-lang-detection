<#
.SYNOPSIS
Sets the default file encoding of PowerShell ISE to the one you specify. 

.DESCRIPTION
This script is pretty much a mix of various snippets from the web. It is meant to be called from your PowerShell ISE $profile and does a couple of things:

* Lets you specify your preferred encoding. 
  * PowerShell 2.0 saves as UTF16 by default; PowerShell 3.0 saves as UTF8 by default. If no encoding is specified this script sets the preferred encoding to UTF8.
  * Why UTF8 as the preferred encoding? Because the script was originally born when I started using Git & Mercurial to manage my code and realized that PowerShell 2.0 saves files as UTF16 and that doesn't play well with these DVCSes. 
  * Later I decided to tidy it up and make it more generic, the result of which is before you now. I am learning PowerShell and making a big deal of simple stuff like this lets me play around with the language a bit. :)

* Each time you open a file, if its encoding isn't the preferred one the script *automatically changes the encoding* to what you specify and *saves it*. 
  * I provide a switch -NoAutoSave in which case the encoding is set to the preferred one but the file isn't automatically saved. This way you can open and close files of a different encoding but they won't be changed. 

* It creates a Sub menu under Add-ons called "Save & Close as [Encoding]..." within which you have items for each of the encodings supported by ISE. This way you can save a file in a different encoding as a one time thing. 
  * I decided to close the file after saving - else the script *could* automatically resave it later to the preferred encoding. 

.PARAMETER Encoding
Your preferred encoding. If skipped UTF8 is used. Valid encodings are ASCII, BigEndianUnicode, Default, Unicode, UTF32, UTF7, UTF8. If you want UTF16 specify Unicode.

.PARAMETER AutoSave
By default any file you open is resaved automatically with the preferred encoding. If you don't want the autosaving to happen specify this switch. 

The encoding will still be changed but it won't take effect until you save the file. If you close the file without saving the encoding won't be changed.

.EXAMPLE
Set-PSISEEncoding

Sets encoding as UTF8. Auto saves.

.EXAMPLE
Set-PSISEEncoding -Encoding ASCII

Sets encoding as ASCII. Auto saves.

.EXAMPLE
Set-PSISEEncoding -NoAutoSave

Sets encoding as UTF8. No auto save.

.EXAMPLE
Set-PSISEEncoding -NoAutoSave -Encoding Unicode

Sets encoding as UTF16. No auto save.
#>

param(
  # Our preferred encoding
  [parameter(Mandatory=$false)]
  [ValidateSet("UTF8","Unicode","UTF7","ASCII","UTF32","BigEndianUnicode")]
  [string]$Encoding = "UTF8",
  
  # AutoSave files to the preferred encoding or not?
  [parameter(Mandatory=$false)]
  [switch]$NoAutoSave
)

# Convert the input to an object of the [text.encoding] class
# It is important that the variable is specified as of global scope else it does not work within the event-action block.
$global:preferredEncoding = [text.encoding]::$Encoding

# Adds menu item Add-ons > Save & Close as [Encoding] for each of the encodings present in the system
# Idea thanks to http://serverfault.com/a/229560
# I tried like crazy to have a dynamic menu - i.e. the scriptblock had something like $_.Save($encoding) where $encoding would be set from one of the values we have (I had a loop that made menu entries)
# However, turns out $encoding does not get assigned whatever value it is as part of the loop; rather, at run time $encoding is picked up. Since this always points to the last value of the loop the code never worked. 
# Tried whatever I could think of to make the scripblock get a variable and have dynamic menus, but I failed. So hardcoding these manually for now. 
$menu = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Save & Close as [Encoding]...",$null,$null)
$menu.Submenus.Add("UTF8",{ $psIse.CurrentFile.Save([text.encoding]::UTF8); $psIse.CurrentPowerShellTab.Files.Remove($psIse.CurrentFile) },$null) | Out-Null
$menu.Submenus.Add("Unicode|UTF16",{ $psIse.CurrentFile.Save([text.encoding]::Unicode); $psIse.CurrentPowerShellTab.Files.Remove($psIse.CurrentFile) },$null) | Out-Null
$menu.Submenus.Add("ANSI|UTF7",{ $psIse.CurrentFile.Save([text.encoding]::UTF7); $psIse.CurrentPowerShellTab.Files.Remove($psIse.CurrentFile) },$null) | Out-Null
$menu.Submenus.Add("UTF32",{ $psIse.CurrentFile.Save([text.encoding]::UTF32); $psIse.CurrentPowerShellTab.Files.Remove($psIse.CurrentFile) },$null) | Out-Null
$menu.Submenus.Add("ASCII",{ $psIse.CurrentFile.Save([text.encoding]::ASCII); $psIse.CurrentPowerShellTab.Files.Remove($psIse.CurrentFile) },$null) | Out-Null
$menu.Submenus.Add("Big Endian Unicode",{ $psIse.CurrentFile.Save([text.encoding]::BigEndianUnicode); $psIse.CurrentPowerShellTab.Files.Remove($psIse.CurrentFile) },$null) | Out-Null

# The actual work begins here ...
# First set the encoding of all existing files (such as Untitled1.ps1) to $global:preferredEncoding
# Thanks to http://www.nivot.org/post/2010/05/21/PowerShellISEHackingChangeDefaultSaveEncodingToASCII for the idea
# This doesn't save the encoding to the files. Only sets it. The user has to save the file for the encoding to take effect. 
$psISE.CurrentPowerShellTab.Files | %{ 
  # Set private field which holds default encoding to $global:preferredEncoding
  if ($PSVersionTable.PSVersion.Major -eq 2) { $_.GetType().GetField("encoding","nonpublic,instance").SetValue($_, $global:preferredEncoding) }
  if ($PSVersionTable.PSVersion.Major -eq 3) { $_.Gettype().GetField("doc","nonpublic,instance").Getvalue($_).Encoding = $global:preferredEncoding }

  # PowerShell 2 and 3 have different ways of setting the encoding. 
  # Thanks to http://stackoverflow.com/questions/8678810/what-happened-to-this-in-powershell-v3-ctp2-ise. 
}
  
# Then do the same for any new files that we open (register an event for this)
# Thanks to http://social.technet.microsoft.com/Forums/windowsserver/en-US/dacb75cb-47da-4120-8dca-c697f8a84c70/powershell-ise-default-file-encoding-change-from-unicode-big-endian-to-ascii
# and http://bensonxion.wordpress.com/2012/04/25/powershell-ise-default-saveas-encoding/
Register-ObjectEvent -InputObject $psise.CurrentPowerShellTab.Files -EventName CollectionChanged -Action {
  # Iterate ISEFile objects
  # $Event.Sender (aka $Sender) is an automatic variable, see http://technet.microsoft.com/en-us/library/hh847768.aspx
  # Mind you this happens when we close & open tabs
  $Event.Sender | %{
    # In case of an existing file, change encoding and *save* it so that even if the user closes the file without any changes the encoding is saved.
    # Do this only if the encoding isn't $global:preferredEncoding and if $NoAutoSave is $false.
    # Use Test-Path to determine if it's an existing file (can also use $_.IsUntitled)
    if (!$NoAutoSave -and (Test-Path $_.FullPath) -and ($_.Encoding -ne $global:preferredEncoding)) { 
      # This stumped me for a day. During testing phase it used to work, even when I'd run the commands manually. But after a few days of use I realized it was failing. 
      # What would happen is that the event will register, but fail after the first time. 
      # http://blogs.technet.com/b/heyscriptingguy/archive/2011/06/17/manage-event-subscriptions-with-powershell.aspx helped me troubleshoot and learn a bit more about events.
      # Eventually I realized the problem was that $_.Save() was failing and so stopping the events. It would work if I specified the encoding manually, but failed on variables. 
      # On a hunch I tried changing the scope to global, and now it works. 
      $_.Save($global:preferredEncoding) 
    }

    # For all files set private field which holds default encoding to $global:preferredEncoding
    # Mind you, this only sets the field. It doesn't actually take effect on the file until it is saved. 
    if (($_.Encoding -ne $global:preferredEncoding) -and ($PSVersionTable.PSVersion.Major -eq 2)) { $_.GetType().GetField("encoding","nonpublic,instance").SetValue($_, $global:preferredEncoding) }
    if (($_.Encoding -ne $global:preferredEncoding) -and ($PSVersionTable.PSVersion.Major -eq 3)) { $_.Gettype().GetField("doc","nonpublic,instance").Getvalue($_).Encoding = $global:preferredEncoding }

    # PowerShell 2 and 3 have different ways of setting the encoding. 
    # Thanks to http://stackoverflow.com/questions/8678810/what-happened-to-this-in-powershell-v3-ctp2-ise. 
  }
} | Out-Null # piping it to Out-Null so the output isn't shown in the Output Pane