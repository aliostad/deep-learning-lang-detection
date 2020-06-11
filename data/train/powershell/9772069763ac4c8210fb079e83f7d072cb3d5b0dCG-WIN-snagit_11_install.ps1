cd 'C:\CG\Setup\TechSmith SnagIt 11.0.1'

$Processes = @('SnagIt32', 'SnagPriv', 'SnagitEditor')
ForEach ($Snagit_Process in $Processes)
{
    $Process = Get-Process $Snagit_Process -ErrorAction SilentlyContinue
    If ($Process) 
    {
        $Process.Kill()
    }
}

$Snagit_MSI = 'SnagIt_11_0_1.msi'
$Transform_MSI = 'SnagIt_11_0_1.mst'
$Install_Log = 'c:\CG\Logs\Snagit_Install.log'

& msiexec /i $Snagit_MSI TRANSFORMS=$Transform_MSI /l $Install_Log /qn

regedit.exe /s "Registration.reg"

regedit.exe /s "ActiveSetup.reg"

.\copy.cmd
# $ProgramData_Snagit = "%ProgramData%\TechSmith\Snagit 11\"
copy-item "ImageQuickStyles.xml" -Destination "c:\ProgramData\TechSmith\Snagit 11\ImageQuickStyles.xml"
copy-item "SnagIt900.sdf"        -Destination "c:\ProgramData\TechSmith\Snagit 11\SnagIt900.sdf"
copy-item "DrawQuickStyles.xml"  -Destination "c:\ProgramData\TechSmith\Snagit 11\DrawQuickStyles.xml"
copy-item "Tray.bin"             -Destination "c:\ProgramData\TechSmith\Snagit 11\Tray.bin"
copy-item "customization.reg"    -Destination "c:\ProgramData\TechSmith\Snagit 11\customization.reg"
copy-item "exeregistries.reg"    -Destination "c:\ProgramData\TechSmith\Snagit 11\exeregistries.reg"
copy-item "activesetup.cmd"      -Destination "c:\ProgramData\TechSmith\Snagit 11\activesetup.cmd"
