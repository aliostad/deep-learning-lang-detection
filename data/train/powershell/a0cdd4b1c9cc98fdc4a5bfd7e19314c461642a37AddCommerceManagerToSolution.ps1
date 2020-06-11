param($SolutionRootDir, $SolutionName)

#Get the solution as a EnvDTE80.Solution2 interface. People running < VS 2013 need not apply.  Upgrade your VS!
$solution2 = Get-Interface $dte.Solution ([EnvDTE80.Solution2])

#Build the Commerce Solution Folder, add the csproj
$commerceSolutionFolder = $solution2.AddSolutionFolder("Commerce")
$pathToCommerceManagerProj = $SolutionRootDir + "\Commerce\CommerceManager\CommerceManager.csproj";

#Note: .Object gives us the object as an [EnvDTE80.SolutionFolder]
$commerceSolutionFolder.Object.AddFromFile($pathToCommerceManagerProj);

$solutionSavePath = $SolutionRootDir + "\" + $SolutionName + ".sln"
$solution2.SaveAs($solutionSavePath)