param(
       $installPath, # the path to the folder where the package is installed
       $toolsPath,   # the path to the tools directory in the folder where the package is installed
       $package,     # a reference to the package object.
       $project      # a reference to the EnvDTE project object and represents the project the package is installed into.
)
 
Function Set-AlwaysCopyDirectoryToOutputRecursive
{
       # Recursively set the "Copy to Output Directory" property to "Copy always" (1)
       param(
              [object]$item
       )
 
       if(-not $item)
       {
              return
       }
 
       $item.ProjectItems | ForEach-Object {
              try
              {
                     $_.Properties.Item("CopyToOutputDirectory").Value = 1
              }
              catch {}
             
              if($_.ProjectItems.Count -gt 0)
              {
                     # This is a directory, recurse
                     Set-AlwaysCopyDirectoryToOutputRecursive $_
              }
       }
}
 
&{
    # Set "Copy to Output Directory" to "Copy always" for all files in the MdsTools directory
    Set-AlwaysCopyDirectoryToOutputRecursive($project.ProjectItems.Item("MdsTools"))
}