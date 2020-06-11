param($installPath, $toolsPath, $package, $project)

try{
	if ($project.Type -eq "VB.NET") {
       #delete the c# bootstrapper
	   $project.ProjectItems | ?{ $_.Name -eq "Bootstrapper.cs" } | %{ $_.Delete() }
    } else {
        [System.Windows.Forms.MessageBox]::Show("This NuGet package only supports VB.Net projects.  Use the original Unity.MVC3 package for c#.","Unity.WebAPI.Error",[System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show("An error occurred installing Unity.WebAPI:`n`n$($_.Exception.ToString())`n`nYou may need to upgrade to a newer version of Unity.WebAPI.", "Unity.WebAPI error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
}