<#
.SYNOPSIS
    Reset the Workspace Root Directory
.DESCRIPTION
    This Custom Action will allow the user to choose his root workspace location via Directory Browsing Dialog
    This should be run near the beginning of the action list of a workspace setup, prior to any WorkspaceRootDir dependent actions / filesystem changes
.NOTES
    File Name      : setWorkspaceRootDirectory.ps1
    Author         : Bow Archer
    Prerequisite   : PowerShell V2
.LINK

.EXAMPLE
  
.EXAMPLE
#>
function setWorkspaceDriveMapping
{
    Log-Message -Message "[setWorkspaceDriveMapping] execute" -Level $global:LOG_LEVEL.Info
    
    #######################################################################################################################
    # 
    # CREATE COMMON DRIVE MAPPING
    #
    #######################################################################################################################
    # Map our hard disk to a local 'substitute' so we can all have
    # the same 'path' to our workspaces, but still have them in 'unique' locations


    $DriveMapping           = $EnvironmentConfiguration.SelectSingleNode("//WorkspaceDriveMapping");

    $MappingConfiguration   = ( New-DriveMappingConfiguration                                                       `
                                    -VirtualDriveLocation           $global:WorkspaceRootDir                               `
                                    -VirtualDriveLetter             $DriveMapping.virtualDriveLetter                `
                                    -ReplaceExistingDriveMapping    ( $DriveMapping.replaceExisting -eq 'true')     `
                                    -DeleteExistingDriveMapping     ( $DriveMapping.deleteExisting -eq 'true') )
                                    
    ( Configure-Drive-Mapping -MappingConfiguration $MappingConfiguration -WorkspaceRoot $global:WorkspaceRootDir -Prompt $true )


    Log-Message -Message " Drive-Mapping Status $($MappingConfiguration.Status), VDrive: $($MappingConfiguration.VirtualDriveLetter) VLocation: $($MappingConfiguration.VirtualDriveLocation)"
    switch( $MappingConfiguration.Status )
    {
        {$_ -eq $global:SUCCESS }{
        
            #  if subst was a success, we'll update our working directories for further transactions now.
            # This means the Perforce workspace mappings, and other directory based settings will use this new mapped
            # drive value
            $global:WorkspaceRootDir           = $MappingConfiguration.VirtualDriveLetter
            
            # Change to new drive
            Get-Invoke-Expression-Result                                        `
                -Expression "$($MappingConfiguration.VirtualDriveLetter):"                    `
                -Explanation "Change Drive [$($MappingConfiguration.VirtualDriveLetter)]"     `
                -PrintResult

            Log-Message -Message "Drive Mapping Succeeded, current directory is $($MappingConfiguration.VirtualDriveLetter)" -Level $global:LOG_LEVEL.Success -WriteToLog
            
            Get-ChildItem "$($MappingConfiguration.VirtualDriveLetter):\" | %{ Log-Message -Message "`titem discovered: $_" -Level $global:LOG_LEVEL.Verbose -WriteToLog }
        }
        {$_ -eq $global:FAIL}{
            Log-Message -Message "Drive Mapping Failed" -Level $global:LOG_LEVEL.Error -WriteToLog
        }
        {$_ -eq $global:NOT_AUTHORIZED }{
            Log-Message -Message "Drive Mapping Was Not Authorized by the user" -Level $global:LOG_LEVEL.Warn -WriteToLog
        }
        default{
            Log-Message -"Unknown Status $($MappingConfiguration.Status)" -Level $global:LOG_LEVEL.Error -WriteToLog
        }
    }

    $WorkspaceRootConfigXML     = $EnvironmentConfiguration.SelectSingleNode("//WorkspaceRoot");

    # Used to set the environment variable for workspace root
    [string]$WorkspaceRootKey   = $WorkspaceRootConfigXML.environmentVarKey
    [string]$level              = 'User'
    [string]$valueType          = 'STRING'

 
    # Set our environment variable
    ( Set-Environment-Variable -Name $WorkspaceRootKey -Value $global:WorkspaceRootDir -Level $level -ValueType $valueType -Prompt $false -AppendToCurrentValue $false -AsJob )
   
}