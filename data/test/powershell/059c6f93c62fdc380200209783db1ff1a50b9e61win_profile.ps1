$user = ${env:username}

copy-item C:\BACKUP2013_$user\Desktop\* C:\Users\$user\Desktop -force -recurse

copy-item C:\BACKUP2013_$user\Favorites\* C:\Users\$user\Favorites -force -recurse

copy-item C:\BACKUP2013_$user\Outlook\Signatures C:\Users\$user\AppData\Roaming\Microsoft -force -recurse

copy-item "C:\BACKUP2013_$user\Outlook\Personal Folders\*.pst" "C:\Users\$user\AppData\Local\Microsoft\Outlook" -force -recurse

gci C:\BACKUP2013_$user\Outlook\NK2 | sort LastWriteTime -desc | select -first 1 | cpi -dest C:\Users\$user\AppData\Roaming\Microsoft\Outlook -force -recurse
 
rm "C:\Users\$user\AppData\Roaming\Thomson Financial\Thomson ONE\Workspaces" -recurse

copy-item "C:\BACKUP2013_$user\Thomson Financial\Thomson ONE\Workspaces" "C:\Users\$user\AppData\Roaming\Thomson Financial\Thomson ONE" -force -recurse


