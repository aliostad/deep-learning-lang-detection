# ------------------------------------------------------------------ #
# Script:      Post Déploiement                                      #
# Auteur:      Julian Da Cunha                                       #
# Date:        07/01/14                                              #
# ------------------------------------------------------------------ #

#== Cache le Shell =====================================
$Script:ShowWindowAsync = Add-Type –MemberDefinition @”
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
“@ -Name “Win32ShowWindowAsync” -Namespace Win32Functions –PassThru

Function Hide-PowerShell() { 
    $Null = $ShowWindowAsync::ShowWindowAsync((Get-Process –Id $Pid).MainWindowHandle, 2) 
}

Hide-PowerShell

#== Function Control Smart Screen ======================
Function Set-SmartScreenSettingsStatus {            
    [CmdletBinding()]            
    Param(            
        [Parameter(Mandatory)]            
        [ValidateSet("Off","Prompt","RequireAdmin")]                        
        [system.String]$State            
    )            
    Begin {            
        # Make sure we run as admin                        
        $usercontext = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()                        
        $IsAdmin = $usercontext.IsInRole(544)                                                                   
        if (-not($IsAdmin)) {                        
            Write-Warning "Must run powerShell as Administrator to perform these actions"                        
            break            
        }                         
            
    }            
    Process {            
        try {            
            Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -ErrorAction Stop -Value $State -Force             
        } catch {            
            Write-Warning -Message "Failed to write registry value because $($_.Exception.Message)"            
        }            
    }            
    End {}            
}

