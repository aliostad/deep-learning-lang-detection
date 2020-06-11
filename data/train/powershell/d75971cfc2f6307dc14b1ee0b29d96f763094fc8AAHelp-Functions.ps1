function Update-AAHelpFile 
{
    [CmdletBinding()]
    param (
        [Parameter(Position = 0,Mandatory = $true)]
        [string]$UpdateFile,

        [Parameter(Position = 1,Mandatory = $true)]
        [string]$ShortcutFile
    )
    
    if (Test-Path("$UpdateFile"))
    {
        try 
        {
            Write-Verbose -Message "The file $UpdateFile exists, trying to update it."
            Start-Process -FilePath $ShortcutFile -PassThru | Wait-Process -Timeout 100 -ErrorAction Stop
        }
        catch
        {
            Write-Warning -Message $_.Exception.Message
        }
        finally
        {
            Write-Verbose -Message 'Update Completed.'
            Remove-Item $ShortcutFile -Force -Confirm:$false
        }
    }
    else 
    {
        Write-Warning -Message "The file $($UpdateFile) does not exist. Process will quit" -Verbose
        Break
    }
}
Function Start-AAHelp 
{
    [CmdletBinding()]
    param (
        [Parameter(Position = 0,Mandatory = $true)]
        [string]$Program,
        
        [Parameter(Position = 1,Mandatory = $false)]
        [string[]]$Arguments
    )
    
    #Launch AAHELP
    Write-Verbose -Message 'Will now launch AA Help..' -Verbose

    try 
    {
        Start-Process -FilePath $Program -ArgumentList $Arguments -ErrorAction Stop
    }
    catch 
    {
        throw $_.Exception.Message
    }
}
