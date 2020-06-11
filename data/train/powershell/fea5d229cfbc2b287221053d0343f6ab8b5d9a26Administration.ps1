#Requires -Version 3.0
<#  Administration #>
function Export-ConfluenceSite {
    <#
    .SYNOPSIS
        Export the Confluence Instance to a File

    .DESCRIPTION
        Exports a Confluence instance and returns a String holding the URL for the download.
        The boolean argument indicates whether or not attachments ought to be included in the export.
        This method respects the property admin.ui.allow.manual.backup.download (as described on this page in confluence documentation); if the property is not set, or is set to false, this method will not return the download link, but instead return a string containing the actual path on the server where the export is located.

    .NOTES
        AUTHOR : Oliver Lipkau <oliver@lipkau.net>
        VERSION: 0.0.1 - OL - Initial Code
                 1.0.0 - OL - Replaced hashtables with Objects

    .INPUTS
        switch

    .OUTPUTS
        string

    .EXAMPLE
        Export-ConfluenceSite -apiURi "http://example.com" -token "000000"
        -----------
        Description
        Exports the Confluence Instance


    .EXAMPLE
        $param = @{apiURi = "http://example.com"; token = "000000"}
        Export-ConfluenceSite @param -includeAttachments
        -----------
        Description
        Exports the Cunfluence Instance and all it's attachments

    .LINK
        Atlassians's Docs:
            String exportSite(String token, boolean exportAttachments)

    #>
    [CmdletBinding(
    )]
    [OutputType(
        [string]
    )]
    param(
        # The URi of the API interface.
        [Parameter(
            Position=0,
            Mandatory=$true
        )]
        [string]$apiURi,

        # Confluence's Authentication Token.
        [Parameter(
            Position=1,
            Mandatory=$true
        )]
        [string]$Token,

        # Include Attachments in the export file.
        [switch]$includeAttachments
    )

    Begin
        { Write-Verbose "$($MyInvocation.MyCommand.Name):: Function started" }

    Process {
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Exporting Confluence Instance $(if ($includeAttachments) {"including Attachments"})"
        ConvertFrom-Xml (Invoke-ConfluenceCall -Url $apiURi -MethodName "confluence2.exportSite" -Params ($token,$includeAttachments))
    }

    End
        { Write-Verbose "$($MyInvocation.MyCommand.Name):: Function ended" }
}
function Get-ConfluenceClusterInformation {
    <#
    .SYNOPSIS
        Returns information about the cluster this node is part of

    .DESCRIPTION
        Returns information about the cluster this node is part of

    .NOTES
        AUTHOR : Oliver Lipkau <oliver@lipkau.net>
        VERSION: 0.0.1 - OL - Initial Code
                 1.0.0 - OL - Replaced hashtables with Objects

    .INPUTS


    .OUTPUTS
        Confluence.ClusterInformation

    .EXAMPLE
        Get-ConfluenceClusterInformation -apiURi "http://example.com" -token "000000"
        -----------
        Description
        Fetch the Cluster Information of the Confluence Instance

    .LINK
        Atlassians's Docs:
            ClusterInformation getClusterInformation(String token)

    #>
    [CmdletBinding(
    )]
    [OutputType(
        [Confluence.ClusterInformation]
    )]
    param(
        # The URi of the API interface.
        [Parameter(
            Position=0,
            Mandatory=$true
        )]
        [string]$apiURi,

        # Confluence's Authentication Token.
        [Parameter(
            Position=1,
            Mandatory=$true
        )]
        [string]$Token
    )

    Begin
        { Write-Verbose "$($MyInvocation.MyCommand.Name):: Function started" }

    Process {
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Getting Cluster Information"
        ConvertFrom-Xml (Invoke-ConfluenceCall -Url $apiURi -MethodName "confluence2.getClusterInformation" -Params ($token))
    }

    End
        { Write-Verbose "$($MyInvocation.MyCommand.Name):: Function ended" }
}
function Get-ConfluenceClusterNodeStatuses {
    <#
    .SYNOPSIS
        Returns a Vector of NodeStatus objects containing information about each node in the cluster

    .DESCRIPTION
        Returns a Vector of NodeStatus objects containing information about each node in the cluster

    .NOTES
        AUTHOR : Oliver Lipkau <oliver@lipkau.net>
        VERSION: 0.0.1 - OL - Initial Code
                 1.0.0 - OL - Replaced hashtables with Objects

    .INPUTS
        

    .OUTPUTS
        

    .EXAMPLE
        Get-ConfluenceClusterNodeStatuses -apiURi "http://example.com" -token "000000"
        -----------
        Description
        Returns a Vector of NodeStatus objects containing information about each node in the cluster

    .LINK
        Atlassians's Docs:
            Vector getClusterNodeStatuses(String token)

    #>
    [CmdletBinding(
    )]
    param(
        # The URi of the API interface.
        [Parameter(
            Position=0,
            Mandatory=$true
        )]
        [string]$apiURi,

        # Confluence's Authentication Token.
        [Parameter(
            Position=1,
            Mandatory=$true
        )]
        [string]$Token
    )

    Begin
        { Write-Verbose "$($MyInvocation.MyCommand.Name):: Function started" }

    Process {
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Getting Cluster Node Status"
        ConvertFrom-Xml (Invoke-ConfluenceCall -Url $apiURi -MethodName "confluence2.getClusterNodeStatuses" -Params ($token))
    }

    End
        { Write-Verbose "$($MyInvocation.MyCommand.Name):: Function ended" }
}
function Test-ConfluencePluginEnabled {
    <#
    .SYNOPSIS
        Returns information about the cluster this node is part of

    .DESCRIPTION
        Returns information about the cluster this node is part of

    .NOTES
        AUTHOR : Oliver Lipkau <oliver@lipkau.net>
        VERSION: 0.0.1 - OL - Initial Code
                 1.0.0 - OL - Replaced hashtables with Objects

    .INPUTS
        string

    .OUTPUTS
        bool

    .EXAMPLE
        Test-ConfluencePluginEnabled -apiURi "http://example.com" -token "000000" -Plugin "pluginName"
        -----------
        Description
        Return if the Plugin "pluginName" is enabled

    .LINK
        Atlassians's Docs:
            boolean isPluginEnabled(String token, String pluginKey) - returns true if the plugin is installed and enabled, otherwise false.

    #>
    [CmdletBinding(
    )]
    [OutputType(
        [bool]
    )]
    param(
        # The URi of the API interface.
        [Parameter(
            Position=0,
            Mandatory=$true
        )]
        [string]$apiURi,

        # Confluence's Authentication Token.
        [Parameter(
            Position=1,
            Mandatory=$true
        )]
        [string]$Token,

        # Identifier of the Plugin to be tested.
        [Parameter(
            Position=2,
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )]
        [Alias("Name")]
        [string]$Plugin
    )

    Begin
        { Write-Verbose "$($MyInvocation.MyCommand.Name):: Function started" }

    Process {
        Write-Verbose "$($MyInvocation.MyCommand.Name):: Getting Status of Plugin $Plugin"
        ConvertFrom-Xml (Invoke-ConfluenceCall -Url $apiURi -MethodName "confluence2.isPluginEnabled" -Params ($token,$Plugin))
    }

    End
        { Write-Verbose "$($MyInvocation.MyCommand.Name):: Function ended" }
}
<#function Install-ConfluencePlugin {
    #boolean installPlugin(String token, String pluginFileName, byte[] pluginData) - installs a plugin in Confluence. Returns false if the file is not a JAR or XML file. Throws an exception if the installation fails for another reason.
}#>
<# /Administration #>