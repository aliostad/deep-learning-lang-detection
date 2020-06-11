function New-ObjectFromGenericType {
	<#
		.SYNOPSIS
			Get an instances of a Generic Type.

		.DESCRIPTION
			Get an instances of a Generic Type. For example List`<Int`> where ClassName is List and TypeName is Int. This is just an example as
			Powershell can manage dynamic collections nativly.

		.PARAMETER  ClassName
			This is the name of the generic class.

		.PARAMETER  TypeName
			This is the name of the type parameter.

		.EXAMPLE
			PS C:\> $serializer = New-ObjectFromGenericType "YamlDotNet.RepresentationModel.Serialization.YamlSerializer" "Models.CustomModelClass"

		.INPUTS
			System.String,System.String[]

		.OUTPUTS
			System.Object

		.LINK
			about_functions_advanced

		.LINK
			http://poshcode.org/4176

		.LINK
			http://msdn.microsoft.com/en-us/library/system.activator.aspx
			
		.FUNCTION
			Helper

	#>
	
	[CmdletBinding()]
	[OutputType([System.Object])]
	param(
		[Parameter(Position=0, Mandatory)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$ClassName,

		[Parameter(Position=1, Mandatory)]
		[ValidateNotNull()]
		[System.String[]]
		$TypeName
	)
	try {
		$classType = ($ClassName+'`'+$TypeName.Count) -as [Type]
	
		if ($classType -ne $null)
		{				
			$typeParameter = @()
			foreach ($name in $TypeName)
			{
				try
				{
					$typeParameter += ($name -as [Type])
				}
				catch
				{
					Write-Error -Message "Type is not accessible in this session" -TargetObject $name
				}
			}		
			$typeObject = $classType.MakeGenericType($typeParameter)		
			$objectInstance = [Activator]::CreateInstance($typeObject)		
			Write-Output $objectInstance		
		}
		else
		{
			Write-Warning "$ClassName is not accessible in this session."
		}
	}
	catch {
		Write-Error -Message $_.Exception.Message
	}
}
<#
.SYNOPSIS
Gets a PowerShell Credential (PSCredential) from the Windows Credential Manager

.DESCRIPTION
This module will return a [PSCredential] object from a credential stored in Windows Credential Manager. The 
Get-StoredCredential function can only access Generic Credentials.

.PARAMETER Name
The name of the target login informations in the Windows Credential Manager

.EXAMPLE
PS C:\>Get-StoredCredential tfs.codeplex.com

UserName                             Password
--------                             --------
codeplexuser                         System.Security.SecureString

.EXAMPLE
PS C:\>$cred = gsc production
PS C:\>$conn = Connect-WSMan -ComputerName ProdServer -Credential $cred

.INPUTS
System.String

.OUTPUTS
System.Management.Automation.PSCredential

.NOTES
To add credentials open up Control Panel>User Accounts>Credential Manager and click "Add a gereric credential". 
The "Internet or network address" field will be the Name required by the Get-StoredCredential function.

Forked from https://gist.github.com/toburger/2947424 which was adapted from
http://stackoverflow.com/questions/7162604/get-cached-credentials-in-powershell-from-windows-7-credential-manager

The MIT License

Copyright (c) 2012 Tobias Burger

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

.LINK
Get-Credential

.ROLE
Operations

.FUNCTIONALITY
Security
    
#>
function Get-StoredCredential
{
    [CmdletBinding()]
    [OutputType([PSCredential])]
    Param
    (
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [Alias("Address", "Location", "TargetName")]
        [string]$Name
    )

    End
    {
        $credPtr= New-Object -TypeName IntPtr

        $success = [ADVAPI32.Util]::CredRead($Name,1,0,[ref] $credPtr)

        if ($success) {
            $critCred = New-Object -TypeName ADVAPI32.Util+CriticalCredentialHandle -ArgumentList $credPtr
            $cred = $critCred.GetCredential()
            $username = $cred.UserName
            $securePassword = $cred.CredentialBlob | ConvertTo-SecureString -AsPlainText -Force
            Write-Output (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $securePassword)
        } else {
            Write-Verbose "No credentials where found in Windows Credential Manager for $Name"
        }
    }

    Begin
    {
        $sig = @"

[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
public struct NativeCredential
{
    public UInt32 Flags;
    public CRED_TYPE Type;
    public IntPtr TargetName;
    public IntPtr Comment;
    public System.Runtime.InteropServices.ComTypes.FILETIME LastWritten;
    public UInt32 CredentialBlobSize;
    public IntPtr CredentialBlob;
    public UInt32 Persist;
    public UInt32 AttributeCount;
    public IntPtr Attributes;
    public IntPtr TargetAlias;
    public IntPtr UserName;

    internal static NativeCredential GetNativeCredential(Credential cred)
    {
        NativeCredential ncred = new NativeCredential();
        ncred.AttributeCount = 0;
        ncred.Attributes = IntPtr.Zero;
        ncred.Comment = IntPtr.Zero;
        ncred.TargetAlias = IntPtr.Zero;
        ncred.Type = CRED_TYPE.GENERIC;
        ncred.Persist = (UInt32)1;
        ncred.CredentialBlobSize = (UInt32)cred.CredentialBlobSize;
        ncred.TargetName = Marshal.StringToCoTaskMemUni(cred.TargetName);
        ncred.CredentialBlob = Marshal.StringToCoTaskMemUni(cred.CredentialBlob);
        ncred.UserName = Marshal.StringToCoTaskMemUni(System.Environment.UserName);
        return ncred;
    }
}

[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
public struct Credential
{
    public UInt32 Flags;
    public CRED_TYPE Type;
    public string TargetName;
    public string Comment;
    public System.Runtime.InteropServices.ComTypes.FILETIME LastWritten;
    public UInt32 CredentialBlobSize;
    public string CredentialBlob;
    public UInt32 Persist;
    public UInt32 AttributeCount;
    public IntPtr Attributes;
    public string TargetAlias;
    public string UserName;
}

public enum CRED_TYPE : uint
    {
        GENERIC = 1,
        DOMAIN_PASSWORD = 2,
        DOMAIN_CERTIFICATE = 3,
        DOMAIN_VISIBLE_PASSWORD = 4,
        GENERIC_CERTIFICATE = 5,
        DOMAIN_EXTENDED = 6,
        MAXIMUM = 7,      // Maximum supported cred type
        MAXIMUM_EX = (MAXIMUM + 1000),  // Allow new applications to run on old OSes
    }

public class CriticalCredentialHandle : Microsoft.Win32.SafeHandles.CriticalHandleZeroOrMinusOneIsInvalid
{
    public CriticalCredentialHandle(IntPtr preexistingHandle)
    {
        SetHandle(preexistingHandle);
    }

    public Credential GetCredential()
    {
        if (!IsInvalid)
        {
            NativeCredential ncred = (NativeCredential)Marshal.PtrToStructure(handle,
                  typeof(NativeCredential));
            Credential cred = new Credential();
            cred.CredentialBlobSize = ncred.CredentialBlobSize;
            cred.CredentialBlob = Marshal.PtrToStringUni(ncred.CredentialBlob,
                  (int)ncred.CredentialBlobSize / 2);
            cred.UserName = Marshal.PtrToStringUni(ncred.UserName);
            cred.TargetName = Marshal.PtrToStringUni(ncred.TargetName);
            cred.TargetAlias = Marshal.PtrToStringUni(ncred.TargetAlias);
            cred.Type = ncred.Type;
            cred.Flags = ncred.Flags;
            cred.Persist = ncred.Persist;
            return cred;
        }
        else
        {
            throw new InvalidOperationException("Invalid CriticalHandle!");
        }
    }

    override protected bool ReleaseHandle()
    {
        if (!IsInvalid)
        {
            CredFree(handle);
            SetHandleAsInvalid();
            return true;
        }
        return false;
    }
}

[DllImport("Advapi32.dll", EntryPoint = "CredReadW", CharSet = CharSet.Unicode, SetLastError = true)]
public static extern bool CredRead(string target, CRED_TYPE type, int reservedFlag, out IntPtr CredentialPtr);

[DllImport("Advapi32.dll", EntryPoint = "CredFree", SetLastError = true)]
public static extern bool CredFree([In] IntPtr cred);


"@
        try
        {
            Add-Type -MemberDefinition $sig -Namespace "ADVAPI32" -Name 'Util' -ErrorAction Stop
        }
        catch
        {
            Write-Error -Message "Could not load ADVAPI32. $($_.Exception.Message)"
        }
    
    }
}

Export-ModuleMember -Function New-ObjectFromGenericType,Get-StoredCredential

New-Alias -Name gsc -Value Get-StoredCredential -Description "AutomatedOps alias" -ErrorAction SilentlyContinue
if ($?) {
	Export-ModuleMember -Alias gsc 
}

