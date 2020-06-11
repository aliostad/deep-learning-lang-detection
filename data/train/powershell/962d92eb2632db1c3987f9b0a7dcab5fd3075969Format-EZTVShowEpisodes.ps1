Function Format-EZTVShowEpisodes
{
    <#
    .SYNOPSIS
        Used by GetMagnetLinks() method and the Search-EZTV function.
    .DESCRIPTION
        Used by GetMagnetLinks() method. Private function not for use on its own.
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    param 
    (
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True)]            
        $Results
    )
    Process
    {
        $Results.PSTypeNames.Insert(0,"EZTV.ShowEpisodes")
        Write-Verbose "Currently formatting object for $($Results.title)"
        Update-TypeData -TypeName "EZTV.ShowEpisodes" -MemberType ScriptProperty -MemberName ShowName -Value {  If($this.title -match "\s+S\d+E\d+\s+" ) {($this.title -split "(\s+S\d+E\d+\s+)")[0]}
                                                                                                                else {($this.title -split "(\d{1}x\d+)")[0]}
                                                                                                                } -Force
        Update-TypeData -TypeName "EZTV.ShowEpisodes" -MemberType ScriptProperty -MemberName Season -Value {If($this.title -match "\s+S\d+E\d+\s+" ){[int](((($this.title -split "(\s+S\d+E\d+\s+)")[1]).Trim() -replace "E\d+") -replace "S").TrimStart("0")}
                                                                                                            else {([int]$this.title -split "(\d{1}x\d+)")[1] -replace "x.*" }    
                                                                                                        } -Force
        Update-TypeData -TypeName "EZTV.ShowEpisodes" -MemberType ScriptProperty -MemberName Episode -Value {If($this.title -match "\s+S\d+E\d+\s+" ){[int](((($this.title -split "(\s+S\d+E\d+\s+)")[1]).Trim() -replace "S\d+") -replace "E").TrimStart("0")}
                                                                                                            else {[int](($this.title -split "(\d{1}x\d+)")[1] -replace ".*x").TrimStart("0") }
                                                                                                            } -Force
        Update-TypeData -TypeName "EZTV.ShowEpisodes" -MemberType ScriptProperty -MemberName QualityInfo -Value {If($this.title -match "\s+S\d+E\d+\s+" ){($this.title -split "(\s+S\d+E\d+\s+)")[2]}
                                                                                                                else{($this.title -split "(\d{1}x\d+)")[2] }
                                                                                                                } -Force
        Update-TypeData -TypeName "EZTV.ShowEpisodes" -MemberType ScriptProperty -MemberName MagnetURI -Value {$this.href} -Force

        Update-TypeData -TypeName "EZTV.ShowEpisodes" -MemberType ScriptProperty -MemberName Size -Value {$SizeString = ($this.title -split '\(')[-1] -replace "\).*"
                                                                                                               $Unit = $SizeString -replace ".*\s+"
                                                                                                                Convert-Size -To Bytes -From $Unit -Value $($SizeString -replace "\s+.*")
                                                                                                                } -Force
        
        Update-TypeData -TypeName "EZTV.ShowEpisodes" -MemberType ScriptMethod -MemberName DownloadTorrent -Value {Start-Process $this.MagnetURI} -Force
        
        $Results
    } 
}
