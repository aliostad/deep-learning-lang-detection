param($message)

function get_commit_message($passed_in_at_command_line)
{
  $commit_message = $passed_in_at_command_line

  if ($commit_message -eq $null)
  {
    write-host "Please enter a commit message (leave blank to exit):"
    $commit_message = read-host
  }
  return $commit_message
}

function format_time_as_new_branch_name
{
  "$($now.year)$($now.month)$($now.day)$($now.hour)$($now.minute)"
}

function get_latest_on_new_branch($branch_name,$commit_message)
{
  git add -A
  git commit -m $commit_message
  git checkout master
  git checkout -b $branch_name
  git pull jp master
}

$commit_message = get_commit_message($message)
if ($commit_message -eq [String]::empty) {exit}
$new_branch_name = format_time_as_new_branch_name
get_latest_on_new_branch($new_branch_name,$commit_message)
echo "new branch name:$new_branch_name message:$commit_message"
