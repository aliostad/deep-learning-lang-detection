param([string] $commitFile)

$messageFileContent = Get-Content ($commitFile)

$jiraItemRegex = "^feature\/[A-Za-z0-9]+(\-|_)\d+"
$currentBranch = git rev-parse --abbrev-ref HEAD
    
# Only do things if is a feature branch
if($currentBranch -match $jiraItemRegex)
{
    Write-Host "Matches JIRA feature branch"
    $jiraItem = $Matches[0].Replace("feature/", "")
    $isOneLine = $messageFileContent -is [String]
    
    # Check isn't merge commit
    if($isOneLine){
        Write-Host "Is one line message"
        $firstLine = $messageFileContent 
    } else { 
        Write-Host "Is multiple line message"
        $firstLine = $messageFileContent[0] 
    }
        
    if($firstLine.StartsWith("Merge"))
    {
        Write-Host "First line starts with Merge, returning"
        return
    }

    # Make new message first line
    if($firstLine.StartsWith($jiraItem))
    {
        $msg = $firstLine
    }else {
        $msg = "$jiraItem`: $firstLine"
    }
        
    # Add first line to message
    if($isOneLine)
    {
        $newCommitMessage = $msg
    }
    else
    {
        $messageFileContent[0] = $msg
        $newCommitMessage = $messageFileContent
    }

    # Write to file.
    Write-Host "Writing to file '$commitFile'"
    Set-Content $commitFile $newCommitMessage
}
else
{
    Write-Host "Branch '$currentBranch' doesn't match JIRA item regex"
}