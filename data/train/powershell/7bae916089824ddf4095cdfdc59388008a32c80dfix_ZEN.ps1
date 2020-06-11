#!/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
## Author: David Pinto <david.pinto@bioch.ox.ac.uk>
## This program is granted to the public domain.

## Problem:
##    When ZEN (from ZEISS) crashes, the user configuration files may
##    be left in a corrupted state.  The solution recommended by ZEISS
##    (tech info #05-09) is to remove all the user specific configuration
##    files which will then be created new on the first startup.
##
##    These files can only be removed manually but that is not trivial to
##    the typical user.  He is more likely to screw the rest of the system.
##    This just provides a one button to remove the configuration them.
##
##    The problem with this solution is that the user will lose all its
##    configurations.  The configurations are only xml files so in theory
##    ZEN should be able to identify where the problem is and restore most
##    of the files but ZEISS probably does not care.
##
## Objective:
##    Have a single button that removes all files in the problematic
##    directories.
##
## Target:
##    Lightsheet
##
## Note for future:
##    If this ever stops working, it's probably better to just install
##    cygwin on the machine and write a bash script instead.

## Do not forget to use "-ExecutionPolicy ByPass" when starting powershell

$basedir = $Env:APPDATA + "\Carl Zeiss\AIMApplication";
$problematics = @("DefaultWorkspace", "Profiles", "Workspaces");

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');

if (! (Test-Path $basedir)) {
  $status = [System.Windows.Forms.MessageBox]::Show(
    "Unable to find base directory. Doing nothing..."
  );
  Exit 1;
}

$to_remove = @{};
foreach ($problem in $problematics) {
  $d = $basedir + "\" + $problem;
  if (Test-Path $d) {
    $to_remove[$problem] = $d;
  }
}

if ($to_remove.count -lt 1) {
  $status = [System.Windows.Forms.MessageBox]::Show(
    "No problematic directories found in '" + $basedir + "'" +
    "`n`nDoing nothing..."
  );
  Exit 1;
}

$status = [System.Windows.Forms.MessageBox]::Show(
  "Preparing to remove the following directories:`n" +
  ($to_remove.Values -join "`n") +
  "`n`nAre you sure?",
  "Fixing broken ZEN",
  [System.Windows.Forms.MessageBoxButtons]::OKCancel
);

if ($status -eq "OK") {
  foreach ($d in $to_remove.getEnumerator()) {
    Remove-Item $d.Value -recurse -force
  }
  [System.Windows.Forms.MessageBox]::Show("Done. Try starting ZEN now.");
}
