#
#  Git plugin
#   For working with Git.
#
#  Usage:
#   g <Tab>  Cycle through common Git commands.
#

# Aliases

Set-Alias g Invoke-GitTabExpansion

# Functions

Function Invoke-GitTabExpansion {
  Param(
    [ValidateSet(
      "add",
      "bisect",
      "branch",
      "checkout",
      "clone",
      "commit",
      "diff",
      "fetch",
      "grep",
      "help",
      "init",
      "log",
      "merge",
      "mv",
      "pull",
      "push",
      "rebase",
      "reset",
      "rm",
      "show",
      "status",
      "submodule",
      "tag")]
    [String]$Command
  )
  git $Command $Args
}
