

$dizinler = @(); 
$dizinler += "TypeLibrary/Karkas.Ornek.TypeLibrary"
$dizinler += "Dal/Karkas.Ornek.Dal"
$dizinler += "Bs/Karkas.Ornek.Bs"
$dizinler += "BsWrapper/Karkas.Ornek.BsWrapper"




function CopyDllsToWebBin($dll_files)
{
  if ($dll_files -eq $null)
  {
    return;
  }
$hedefDizin = "./WebSite/bin/"

	foreach($dll in $dll_files)
	{
    
		copy-item $dll.FullName -destination "$hedefDizin" -force #-Verbose
	}


}

function CopyDllsToThirdParty($dll_files)
{

$hedefDizin = "../ThirdParty/"

	foreach($dll in $dll_files)
	{
		copy-item $dll.FullName -destination "$hedefDizin" -force #-Verbose
	}


}


	



$dll_output_dizin = "/bin/debug";



foreach($dizin in $dizinler)
{
    $dll_files = Get-ChildItem -Path $dizin$dll_output_dizin  -include *.dll -Recurse |  sort-object Name
    CopyDllsToWebBin($dll_files)
    $dll_files = Get-ChildItem -Path $dizin$dll_output_dizin  -include *.pdb -Recurse |  sort-object Name
    CopyDllsToWebBin($dll_files)
   "Copied $dizin$dll_output_dizin"

}



$dll_files = Get-ChildItem -Path "../../ThirdParty" -include *.dll -Recurse |  sort-object Name
CopyDllsToWebBin($dll_files)
$dll_files = Get-ChildItem -Path "../../ThirdParty" -include *.pdb -Recurse |  sort-object Name
CopyDllsToWebBin($dll_files)


"Copied ThirdParty"



#timestamp 
date

