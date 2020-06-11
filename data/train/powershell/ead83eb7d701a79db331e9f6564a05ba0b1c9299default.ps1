properties {
	$projectName = "HttPardon"
	$projectConfig = "Release"
	$base_dir = resolve-path ..\..
	$source_dir = "$base_dir\Source"
	$build_dir = "$base_dir\Build"
	$test_dir = "$base_dir\Test"
	$company = "Matt Hinze"
	$version = "0.0.0.1"
	$asmInfo = "$source_dir\CommonAssemblyInfo.cs"
}

$framework = '4.0'

task default -depends Compile, Test

task Init {
	# clean build artifacts
    delete_directory $build_dir
    create_directory $test_dir
	set-location $source_dir
	get-childitem * -include *.dll -recurse | remove-item
    get-childitem * -include *.pdb -recurse | remove-item
	get-childitem * -include *.exe -recurse | remove-item
	set-location $base_dir

	create_directory $build_dir

	msbuild /t:clean /property:"Configuration=Debug" /nologo /verbosity:m $source_dir\$projectName.sln

	create-commonAssemblyInfo $asmInfo
}

task Compile -depends Init {
	exec { msbuild /t:build /v:m /nologo /p:Configuration=$projectConfig $source_dir\$projectName.sln }
}

task Test -depends Compile {
	copy_all_assemblies_for_test $test_dir
	exec { & $base_dir\Lib\Mspec\mspec.exe $test_dir\$projectName.Specifications.dll }
	delete_directory $test_dir
}





#######################


function global:zip_directory($directory,$file) {
    write-host ""Zipping folder: "" $test_assembly
    delete_file $file
    cd $directory
    & ""$base_dir\lib\7zip\7za.exe"" a -mx=9 -r $file
    cd $base_dir
}

function global:copy_website_files($source,$destination){
    $exclude = @('*.user','*.dtd','*.tt','*.cs','*.csproj','*.orig', '*.log')
    copy_files $source $destination $exclude
	delete_directory ""$destination\obj""
}

function global:copy_files($source,$destination,$exclude=@()){
    create_directory $destination
    Get-ChildItem $source -Recurse -Exclude $exclude | Copy-Item -Destination {Join-Path $destination $_.FullName.Substring($source.length)}
}

function global:Copy_and_flatten ($source,$filter,$dest) {
  ls $source -filter $filter -r | cp -dest $dest
}

function global:copy_all_assemblies_for_test($destination){
  create_directory $destination
  Copy_and_flatten $source_dir *.exe $destination
  Copy_and_flatten $source_dir *.dll $destination
  Copy_and_flatten $source_dir *.config $destination
  Copy_and_flatten $source_dir *.xml $destination
  Copy_and_flatten $source_dir *.pdb $destination
  Copy_and_flatten $source_dir *.sql $destination
  Copy_and_flatten $source_dir *.xlsx $destination
}

function global:delete_file($file) {
    if($file) { remove-item $file -force -ErrorAction SilentlyContinue | out-null }
}

function global:delete_directory($directory_name)
{
  rd $directory_name -recurse -force  -ErrorAction SilentlyContinue | out-null
}

function global:delete_files_in_dir($dir)
{
	get-childitem $dir -recurse | foreach ($_) {remove-item $_.fullname}
}

function global:create_directory($directory_name)
{
  mkdir $directory_name  -ErrorAction SilentlyContinue  | out-null
}

function global:create-commonAssemblyInfo($filename)
{
"using System.Reflection;
using System.Runtime.InteropServices;

[assembly: AssemblyTitle(""$projectName"")]
[assembly: AssemblyDescription("""")]
[assembly: AssemblyConfiguration(""$projectConfig"")]
[assembly: AssemblyCompany(""$company"")]
[assembly: AssemblyProduct(""$projectName"")]
[assembly: AssemblyCopyright(""Copyright © $company 2011"")]
[assembly: AssemblyTrademark("""")]
[assembly: AssemblyCulture("""")]
[assembly: ComVisible(false)]
[assembly: AssemblyVersion(""$version"")]
[assembly: AssemblyFileVersion(""$version"")]"  | out-file $filename -encoding "UTF8"
}