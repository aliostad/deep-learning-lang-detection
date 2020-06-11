function Git-Checkout-Branch
{
    if($args.count -eq 0)
    {
        return "ERROR: No branch name specified";
    }
    
    $branchName = $args[0];
    $branchRegex = "(.*)" + $branchName + "(.*)";
    
    $message = "";
    
    $result = Does-Branch-Exist $branchName
    
    $result;
    
    if($result){
        git checkout $branchName;
        $message = $branchName.ToString() + " - Switched to branch";
    } else {
        git checkout -b $branchName;    
        $message = $branchName.ToString() + " - Checked out new branch";
    } 

    Write-Eng-Journal $message
}

function Does-Branch-Exist
{
    if($args.count -eq 0)
    {
        return "ERROR: No branch name specified";
    }

    $branchName = $args[0];
    $foundBranch = ""
    
    git branch | foreach {
        if($_.Trim('*').Trim() -eq $branchName){
            $foundBranch += $branchName
        }
    } | Out-Null;
    
    return ($foundBranch.length -gt 0);
}