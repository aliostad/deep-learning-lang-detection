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

function push_up($commit_message)
{
  git add -A
  git commit -m $commit_message
  git push origin
}

$commit_message = get_commit_message($message)
if ($commit_message -eq [String]::empty) {exit}
push_up($commit_message)
