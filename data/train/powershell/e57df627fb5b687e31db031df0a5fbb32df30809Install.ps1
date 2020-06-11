param($installPath, $toolsPath, $package, $project)

#-----------------------------------------------------------------------------
#
# Install and uninstall scripts contributed by Ed Obeda
# Automates the addition and removal of the post-build step to call Afterthought
#
#-----------------------------------------------------------------------------

# Get the current Post Build Event cmds
$currentPostBuildCmds = $project.Properties.Item("PostBuildEvent").Value

$buildCmd = 'Afterthought.Amender "$(TargetPath)"' 

# Append our post build command if it's not already there
if (!$currentPostBuildCmds.Contains($buildCmd))
{
    # Check for partial manual removals of some other version or updates
    if ($currentPostBuildCmds.Contains('Afterthought.Amender.exe'))
    {  
        # Swap out the version details for our current version.        
        $project.Properties.Item("PostBuildEvent").Value = [regex]::replace($currentPostBuildCmds,"packages\\Afterthought.\d+.\d+.\d+\\",'packages\Afterthought.{0}\' -f $package.Version)
    }
    else 
    {
        # Append it, but need to manage carriage return line feeds
        # $project.Properties.Item("PostBuildEvent").Value += $buildCmd
       
        $lines = [regex]::Split($currentPostBuildCmds,"\r\n")
        $cmds = ""

       # Walk each entry
       foreach($line in $lines)
       {
           if( $line.Length -gt 0) # don't include empty lines
           {
                $cmds += $line + "`r`n"  # Creating a noramlized list of commands
            }
       }
      
       $cmds += $buildCmd + "`r`n"  # Add ourself
      
       $project.Properties.Item("PostBuildEvent").Value = $cmds
    }   
}

## site throws error within VS $project.DTE.ItemOperations.Navigate($package.ProjectUrl)  