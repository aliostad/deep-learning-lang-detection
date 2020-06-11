param($installPath, $toolsPath, $package, $project)

try{
	if ($project.Type -eq "VB.NET") {
       #delete the c# bootstrapper
	   $project.ProjectItems | ?{ $_.Name -eq "AppStart_MefContribMVC3.cs" } | %{ $_.Delete() }
    } else {
        [System.Windows.Forms.MessageBox]::Show("This NuGet package only supports VB.Net projects.  Use the original MefContrib.MVC3 package for c#.","MefContrib.Mvc3.VB.Error",[System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show("An error occurred installing MefContrib.Mvc3.VB:`n`n$($_.Exception.ToString())`n`nYou may need to upgrade to a newer version of MefContrib.Mvc3.VB", "MefContrib.Mvc3.VB error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
}