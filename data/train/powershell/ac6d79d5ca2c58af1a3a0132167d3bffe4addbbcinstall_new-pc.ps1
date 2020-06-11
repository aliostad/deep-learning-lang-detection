Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-StartScreenOptions -EnableBootToDesktop -EnableDesktopBackgroundOnStart
Enable-RemoteDesktop

# Dell Treiber Update
#cmd /c "\\em-fs-1\install\driver\DELL Command Update\Systems-Management_Application_H2CN6_WN_2.0.0_A00.EXE" /s
#cmd /c "%ProgramFiles(x86)%\Dell\CommandUpdate\dcu-cli.exe /silent"

# Symantec Virenschutz
#cmd /c "\\EM-FS-1\install\Symantec Endpoint Protection\SymRedistributable.exe" -silent

cinst javaruntime
cinst flashplayeractivex
cinst flashplayerplugin
cinst adobereader-de
cinst IrfanView
cinst Opera
cinst GoogleChrome
cinst Firefox
cinst PDFCreator
cinst 7zip.install
cinst notepadplusplus.install
cinst sublime

cinst phpstorm
#cmd /c move "%appdata%\Microsoft\Windows\Start Menu\JetBrians" "%allusersprofile%\Microsoft\Windows\Start Menu\Programs"

cinst winmerge
cinst putty.install
cinst filezilla
cinst winscp
cinst tortoisesvn
cinst TortoiseGit

cinst TotalCommander
#cmd /c copy "\\EM-FS-1\install\Ghisler - Total Commander\wincmd.key" C:\totalcmd
#cmd /c move "%appdata%\Microsoft\Windows\Start Menu\Programs\Total Commander" "%allusersprofile%\Microsoft\Windows\Start Menu\Programs"

cinst freefilesync
cinst windirstat
cinst wincdemu

cinst pidgin
#cmd /c "%ProgramFiles(x86)%\7-Zip\7z" x \\EM-FS-1\install\pidgin\purple-plugin-pack-2.7.0.zip -o "%ProgramFiles(x86)%\Pidgin" * -r -x!README.txt

cinst libreoffice
cinst gimp
cinst InkScape