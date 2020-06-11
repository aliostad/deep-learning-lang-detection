Function DoNotRun{
    #1. Build a nano image using the NanoServerImageBuilder
    #http://aka.ms/NanoServerImageBuilder
    #https://blogs.technet.microsoft.com/nanoserver/2016/10/15/introducing-the-nano-server-image-builder/

    #2. Manage your hyper-v server in workgroup
    #Hyper-v core 2016 is already configured for WinRM, nothing to do
    #Configure the computer you'll use to manage the Hyper-V host.

    #In your host file, add the computer name (e.g. HYPERV-HOST) and IP
    #Open a Windows PowerShell session as Administrator.
    #Run these commands:

    #Set-Item WSMan:\localhost\Client\TrustedHosts -Value "HYPERV-HOST"
    #Enable-WSManCredSSP -Role client -DelegateComputer "HYPERV-HOST"

    #You might also need to configure the following group policy:
    #Computer Configuration > Administrative Templates > System > Credentials Delegation > Allow delegating fresh credentials with NTLM-only server authentication
    #Click Enable and add wsman/HYPERV-HOST
    #Open Hyper-V Manager.
    #In the left pane, right-click Hyper-V Manager.
    #Click Connect to Server.
    #I couldn't get working "connect as another user" for hyper-v console and other role wouldn't work, no option to provide a different user ... The solution is to create a local user with the same name and same password than your hyper-v host in WorkGroup. Run all your console under this username or start an MMC and add all the snap-in.
    #https://technet.microsoft.com/en-us/windows-server-docs/compute/hyper-v/manage/remotely-manage-hyper-v-hosts

    #3. Enable deduplication
    #https://blogs.technet.microsoft.com/filecab/2016/04/10/configuring-nano-server-and-dedup/

    dism /online /enable-feature /featurename:dedup-core /all

    #4. Create a partition
    $osPartition = Get-Partition -DriveLetter C 
    $dedupPartition = New-Partition -DiskNumber $OsPartition.DiskNumber -UseMaximumSize -DriveLetter D 
    Format-Volume -Partition $dedupPartition -FileSystem NTFS -NewFileSystemLabel “DATA_VMs” -UseLargeFRS

    #5.Enable deduplication
    Enable-DedupVolume -Volume D: -UsageType Default

    #To manage your server, use server manager once RSAT has been installed
}