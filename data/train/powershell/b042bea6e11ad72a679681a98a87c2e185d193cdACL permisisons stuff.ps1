Function Set-Permissions {
    
    param (
    [Parameter(Mandatory = $true, Position = 0)]
    [String]$Folder,
    [Parameter(Mandatory = $true, Position = 1)]
    [String]$SecIdentity,
    [Parameter(Mandatory = $true, Position = 2)]
    [string]$AccessRights
   
    )

    [Array]$PossibleAccessRights = @('FullControl','Read','ReadAndExecute','Modify')
    
    If($PossibleAccessRights -notcontains $AccessRights)
    {
        $AccessRights = 'Read'
    }

    $Inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
    $Propagation = [system.security.accesscontrol.PropagationFlags]"None"
    $AccessControlType = 'Allow'

    $ACL = Get-Acl $Folder -ErrorVariable ErrGetACL

    $PSObjACL = New-Object PSObject -Property @{
        Path = Convert-Path $acl.pspath
        ACEs = $acl | Select-Object -ExpandProperty Access
    }    

    If(!($PSOBjACL | Where-Object {$_.aces.AccessControlType -eq $AccessControlType `
                                 -and $_.aces.FileSystemRights -eq $AccessRights `
                                 -and $_.aces.IdentityReference -eq $SecIdentity})){
        
        Enable-Privilege -Privilege SeSecurityPrivilege
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($SecIdentity, $AccessRights, $inherit, $propagation, $AccessControlType)
        $Acl.AddAccessRule($accessRule)
        Set-Acl -aclobject $ACL $Folder -ErrorVariable ACLShit
        
 
    }
}

Function EnablePprivilege{
	param (
		## The privilege to adjust. This set is taken from
		## http://msdn.microsoft.com/en-us/library/bb530716(VS.85).aspx
		[ValidateSet(
					 "SeAssignPrimaryTokenPrivilege", "SeAuditPrivilege", "SeBackupPrivilege",
					 "SeChangeNotifyPrivilege", "SeCreateGlobalPrivilege", "SeCreatePagefilePrivilege",
					 "SeCreatePermanentPrivilege", "SeCreateSymbolicLinkPrivilege", "SeCreateTokenPrivilege",
					 "SeDebugPrivilege", "SeEnableDelegationPrivilege", "SeImpersonatePrivilege", "SeIncreaseBasePriorityPrivilege",
					 "SeIncreaseQuotaPrivilege", "SeIncreaseWorkingSetPrivilege", "SeLoadDriverPrivilege",
					 "SeLockMemoryPrivilege", "SeMachineAccountPrivilege", "SeManageVolumePrivilege",
					 "SeProfileSingleProcessPrivilege", "SeRelabelPrivilege", "SeRemoteShutdownPrivilege",
					 "SeRestorePrivilege", "SeSecurityPrivilege", "SeShutdownPrivilege", "SeSyncAgentPrivilege",
					 "SeSystemEnvironmentPrivilege", "SeSystemProfilePrivilege", "SeSystemtimePrivilege",
					 "SeTakeOwnershipPrivilege", "SeTcbPrivilege", "SeTimeZonePrivilege", "SeTrustedCredManAccessPrivilege",
					 "SeUndockPrivilege", "SeUnsolicitedInputPrivilege")]
		$Privilege,
		## The process on which to adjust the privilege. Defaults to the current process.

		$ProcessId = $pid,
		## Switch to disable the privilege, rather than enable it.

		[Switch]$Disable
	)
	
	## Taken from P/Invoke.NET with minor adjustments.
	$definition = @'
 using System;
 using System.Runtime.InteropServices;
  
 public class AdjPriv
 {
  [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
  internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall,
   ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr relen);
  
  [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
  internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);
  [DllImport("advapi32.dll", SetLastError = true)]
  internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);
  [StructLayout(LayoutKind.Sequential, Pack = 1)]
  internal struct TokPriv1Luid
  {
   public int Count;
   public long Luid;
   public int Attr;
  }
  
  internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
  internal const int SE_PRIVILEGE_DISABLED = 0x00000000;
  internal const int TOKEN_QUERY = 0x00000008;
  internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
  public static bool EnablePrivilege(long processHandle, string privilege, bool disable)
  {
   bool retVal;
   TokPriv1Luid tp;
   IntPtr hproc = new IntPtr(processHandle);
   IntPtr htok = IntPtr.Zero;
   retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
   tp.Count = 1;
   tp.Luid = 0;
   if(disable)
   {
    tp.Attr = SE_PRIVILEGE_DISABLED;
   }
   else
   {
    tp.Attr = SE_PRIVILEGE_ENABLED;
   }
   retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
   retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
   return retVal;
  }
 }
'@
	
	$processHandle = (Get-Process -id $ProcessId).Handle
	$type = Add-Type $definition -PassThru
	$type[0]::EnablePrivilege($processHandle, $Privilege, $Disable)
}

Set-Permissions -Folder '\\WCNET\Firm\Admin\Americas\Automated-Testing' -SecIdentity 'wcnet\TAM-P-ALLOFFICE' -AccessRights 'Read'

ICACLS "\\WCNET\Firm\Client\Americas\Automated-Testing" "/grant" ("wcnet\TAM-P-ALLOFFICE:(OI)(CI)F")