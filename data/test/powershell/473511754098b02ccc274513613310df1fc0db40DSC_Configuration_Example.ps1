Configuration MyWebConfig
{
   # A Configuration block can have zero or more Node blocks
   Node "Server001"
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
         Type = "Directory“ # Default is “File”
         Recurse = $true
         SourcePath = $WebsiteFilePath # This is a path that has web files
         DestinationPath = "C:\inetpub\wwwroot" # The path where we want to ensure the web files are present
         DependsOn = "[WindowsFeature]MyRoleExample"  # This ensures that MyRoleExample completes successfully before this block runs
      }
   }
} 

# Local Configuration Manager is the Windows PowerShell Desired State Configuration (DSC) engine. It runs on all target nodes, and it is responsible for calling the configuration resources that are included in a DSC configuration script.
# DSC tells the target nodes what configuration they should have by sending a MOF file with that information to each node, where the Local Configuration Manager implements the desired configuration.
# If you wanted to configure how the Local Configuration Manager functions for a specific node, you can specify those options either in a script block of your current DSC file or use DSC to set it from a seperate script and use DSC to set that.

# You can update the Local Configuration Manager settings of a target node by including a LocalConfigurationManager block inside the node block in a configuration script, as shown in the following example.

Configuration ExampleConfig
{
    Node “Server001”
    {
        LocalConfigurationManager
        {
            ConfigurationID = "646e48cb-3082-4a12-9fd9-f71b9a562d4e" # Indicates a GUID which is used to get a particular configuration file from a server set up as a “pull” server. The GUID ensures that the correct configuration file is accessed. 
            # An important difference in configuration for pull mode is that you identify the target node not by name, but with a GUID. This ensures that each target node gets the proper configuration file. To generate a GUID, you can use Create GUID (guidgen.exe) or Guid.NewGuid Method.
            ConfigurationModeFrequencyMins = 45   # How often the LocalConfiguration Manager checks the system to implement on the target node
            ConfigurationMode = "ApplyAndAutocorrect" # Look here to see all the different configuration modes https://technet.microsoft.com/en-us/library/dn249922.aspx
            RefreshMode = "Pull"# Possible values are Push (the default) and Pull. In the “push” configuration, you must place a configuration file on each target node, using any client computer. In the “pull” mode, you must set up a “pull” server for Local Configuration Manager to contact and access the configuration files.
            RefreshFrequencyMins = 90 # Used when you have set up a “pull” server. Represents the frequency (in minutes) at which the Local Configuration Manager contacts a “pull” server to download the current configuration.
            DownloadManagerName = "WebDownloadManager"
            DownloadManagerCustomData = (@{ServerUrl="https://$PullServer/psdscpullserver.svc"})
            CertificateID = "71AA68562316FE3F73536F1096B85D66289ED60E"
            Credential = $cred # Indicates credentials (as with Get-Credential) required to access remote resources, such as to contact the configuration server.
            RebootNodeIfNeeded = $true
            AllowModuleOverwrite = $false
        }
# One or more resource blocks can be added here
    }
}

# The following line invokes the configuration and creates a file called Server001.meta.mof at the specified path
ExampleConfig -OutputPath "c:\users\public\dsc"

# To apply the settings, you can use the Set-DscLocalConfigurationManager cmdlet, as shown in the following example. 

Set-DscLocalConfigurationManager -Path "c:\users\public\dsc"  

# Setting up a pull server. It's basically a webserver with a DSC service running on it and WMF 4.0. However pull transmits are done over https and requires checksumming and at a minimum a self-signed cert so it's a little more work to setup initially. 
# https://technet.microsoft.com/en-us/library/dn249913.aspx