#Requires -version 4.0
# Windows 2012 does not include version PS 4 by default.  It must be downloaded separately.

Configuration MyWebConfig
{
   # A Configuration block can have zero or more Node blocks
   Node "windsc"
   {
      # Next, specify one or more resource blocks

      # WindowsFeature is one of the built-in resources you can use in a Node block
      # This example ensures the Web Server (IIS) role is installed
      WindowsFeature MyRoleExample
      {
          Ensure = "Present" # To uninstall the role, set Ensure to "Absent"
          Name = "Web-Server"  
      }

      # File is a built-in resource you can use to manage files and directories
      # This example ensures files from the source directory are present in the destination directory
      File MyFileExample
      {
         Ensure = "Present"  # You can also set Ensure to "Absent"
         Type = "Directory" # Default is “File”
         Recurse = $true
         SourcePath = "C:\vagrant\wwwroot" # This is a path that has web files
         DestinationPath = "C:\inetpub\wwwroot" # The path where we want to ensure the web files are present
         DependsOn = "[WindowsFeature]MyRoleExample"  # This ensures that MyRoleExample completes successfully before this block runs
      }
   }
} 
