param($installPath, $toolsPath, $package, $project)

try{
	if ($project.Type -eq "VB.NET") {
       #delete the c# bootstrapper
	   $project.ProjectItems | ?{ $_.Name -eq "Bootstrapper.cs" } | %{ $_.Delete() }
    } else {
        [System.Windows.Forms.MessageBox]::Show("This NuGet package only supports VB.Net projects.  Use the original Unity.MVC3 package for c#.","Unity.Mvc3.VB.Error",[System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show("An error occurred installing Unity.Mvc3:`n`n$($_.Exception.ToString())`n`nYou may need to upgrade to a newer version of Unity.Mvc3", "Unity.Mvc3 error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
}