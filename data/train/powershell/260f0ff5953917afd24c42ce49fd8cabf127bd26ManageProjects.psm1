$global:cleanPath="C:\code_backup"
$global:sourceRoot = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\ManageProjects"
$global:editorPath = 'C:\Program Files (x86)\Notepad++\notepad++.exe'
$global:pythonPath = 'C:\Python33\python'

function create_project(){
	write-host 'Enter name of Project'  -ForegroundColor "green"
	$global:name = read-host ">"
	while($name -eq "create_project" -or $name -eq "run" -or $name -eq "clean" -or $name -eq "compile" -or $name -eq "create_test" -or $name -eq "test"){
		write-host 'Invalid Name. Please try another name of Project'  -ForegroundColor "green"
		$global:name = read-host ">"
	}
	write-host 'Enter type of Project'  -ForegroundColor "green"
	$global:type = read-host ">"
	$sw = [Diagnostics.Stopwatch]::StartNew()
	if($type -eq "cpp" -or $type -eq "c" -or $type -eq "py" -or $type -eq "java")
	{
		$global:file=$cleanPath+"\"+$type+"\"+$name+"\Main."+$type
		$global:buildPath=$cleanPath+"\"+$type+"\"+$name
		if(Test-Path $file){}
		else{
			mkdir $buildPath
			cd $global:buildPath
			New-Item -path $file -itemtype file
			switch($type)
			{
				c {
					Set-Content $file "#include<stdio.h>`n#include<stdlib.h>`nint main()`n{`n`t`n`treturn 0;`n}"
					break
				}
				cpp{
					Set-Content $file "#include<iostream>`nint main()`n{`n`t`n`treturn 0;`n}"
					break
				}
				java{
					$content="public class Main`n{`n`tpublic static void main(String[] args)`n`t{`n`t`t`n`t}`n}"
					Set-Content $file $content
					break
				}
			}
		}
		& $editorPath $file
		write-host "Project Created. Moving to project Location." -ForegroundColor "green" -BackgroundColor "black"
		cd $buildPath
	}else{
		write-host "Unrecognized project type." -ForegroundColor "red" -BackgroundColor "black"
	}
	$sw.Stop()
	$msg = "Total time elapsed in MiliSeconds: "+$sw.Elapsed.TotalMilliseconds
	write-host $msg -ForegroundColor "green"
}

function run(){
	write-host "Preparing to run." -ForegroundColor "green"
	cd $global:buildPath
	$sw = [Diagnostics.Stopwatch]::StartNew()
	$prjfile="run.ps1"
	if(Test-Path $prjfile)
	{
		.\run.ps1
	}else
	{
		switch($type)
		{
			c{
				$cmd=".\"+$name
				& $cmd
				break
			}
			cpp{
				$cmd=".\"+$name
				& $cmd
				break
			}
			py{
				& $pythonPath Main.py
				break
			}
			java{
				java Main
				break
			}
			default{
				write-host "Unrecognized project type." -ForegroundColor "red" -BackgroundColor "black"
				break
			}
		}
	}
	$sw.Stop()
	$msg = "Total time elapsed in MiliSeconds: "+$sw.Elapsed.TotalMilliseconds
	write-host $msg -ForegroundColor "green"
}

function clean(){
	cd $global:buildPath
	$sw = [Diagnostics.Stopwatch]::StartNew()
	$foldername=$name+"_test"
	if(Test-Path $foldername)
	{
		write-host "Deleting test files." -ForegroundColor "green"
		Remove-Item $foldername -force
	}
	$dir = "test_archive"
	if(Test-Path $dir)
	{
		$directoryInfo = Get-ChildItem C:\temp | Measure-Object
		if($directoryInfo.count > 1){
			write-host "Saving latest test Report" -ForegroundColor "green"
			$latest = Get-ChildItem -Path $dir | Sort-Object LastAccessTime -Descending | Select-Object -First 1
			$file="test_archive\"+$latest.name
			Copy-Item $file "LastTestReport.html"
		}
		write-host "Deleting test archive." -ForegroundColor "green"
		Remove-Item $dir -force
	}
	
	$sw.Stop()
	$msg = "Total time elapsed in MiliSeconds: "+$sw.Elapsed.TotalMilliseconds
	write-host $msg -ForegroundColor "green"
}

function compile(){
	cd $global:buildPath
	$sw = [Diagnostics.Stopwatch]::StartNew()
	$prjfile="compile.ps1"
	if(Test-Path $prjfile)
	{
		.\compile.ps1
	}else
	{
		switch($type)
		{
			c{
				$global:file="main."+$type
				write-host "Compiling.."  -ForegroundColor "green"
				gcc $global:file -o $global:name
				write-host "End of compilation."  -ForegroundColor "green"
				break
			}
			cpp{
				$global:file="main."+$type
				write-host "Compiling.."  -ForegroundColor "green"
				g++ $global:file -o $global:name
				write-host "End of compilation."  -ForegroundColor "green"
				break
			}
			py{
				$global:file=$cleanPath+"\py\"+$name+"."+$type
				write-host "No Compiling required.Runnig Script instead."  -ForegroundColor "green"
				& $pythonPath Main.py
				break
			}
			java{
				$global:file=$cleanPath+"\java\"+$name+"\main."+$type
				write-host "Compiling.."  -ForegroundColor "green"
				javac $global:file 
				write-host "End of compilation."  -ForegroundColor "green"
				break
			}
			default{
				write-host "Unrecognized project type." -ForegroundColor "red" -BackgroundColor "black"
			}
		}
	}
	$sw.Stop()
	$msg = "Total time elapsed in MiliSeconds: "+$sw.Elapsed.TotalMilliseconds
	write-host $msg -ForegroundColor "green"
}

function create_test(){
	$sw = [Diagnostics.Stopwatch]::StartNew()
	$foldername = $name+"_test"
	if(Test-Path $foldername)
	{
		write-host "Test Suite already exists" -ForegroundColor "green"
		$filename = $name+"_test\"+"\testCases.py"
		& 'C:\Program Files (x86)\Notepad++\notepad++.exe' $filename
		return 
	}
	mkdir $foldername
	mkdir test_archive
	
	write-host "Copying files." -ForegroundColor "green"
	$source = $sourceRoot+"\examineOutput.py"
	$destination = $name+"_test\"
	Copy-Item $source $destination
	
	$source = $sourceRoot+"\input.py"
	Copy-Item $source $destination
	
	$source = $sourceRoot+"\input.txt"
	Copy-Item $source $destination
	
	$source = $sourceRoot+"\output.txt"
	Copy-Item $source $destination
	
	$source = $sourceRoot+"\testTemplate.py"
	Copy-Item $source $destination
	
	$source = $sourceRoot+"\color_console.py"
	Copy-Item $source $destination
	
	$source = $sourceRoot+"\testCases.py"
	Copy-Item $source $destination
	
	$filename = $destination+"\testCases.py"
	& $editorPath $filename
	
	$sw.Stop()
	$msg = "Total time elapsed in MiliSeconds: "+$sw.Elapsed.TotalMilliseconds
	write-host $msg -ForegroundColor "green"
}

function test(){
	$sw = [Diagnostics.Stopwatch]::StartNew()
	$foldername = $name+"_test"
	if(Test-Path $foldername)
	{
		write-host "Creating Test Suite" -ForegroundColor "green"
		$filename = $name+'_test/input.py'
		$outputname= $name+'_test/input.txt'
		& $pythonPath $filename |  Out-File $outputname
		
		write-host "Writing output on file" -ForegroundColor "green"
		$filename=$name+'_test/output.txt'
		
		switch($type)
		{
			c{
				$cmd=".\"+$name
				Get-Content $outputname | & $cmd | Out-File  $filename
				break
			}
			cpp{
				$cmd=".\"+$name
				Get-Content $outputname | & $cmd | Out-File  $filename
				break
			}
			py{
				Get-Content $outputname | & $pythonPath  Main.py | Out-File  $filename
				break
			}
			java{
				Get-Content $outputname | java Main | Out-File  $filename
				break
			}
		}
		write-host "Ready for testing" -ForegroundColor "green"
		
		write-host "Starting test" -ForegroundColor "green"
		$scriptfile=$name+'_test\examineOutput.py'
		Get-Content $filename | & $pythonPath $scriptfile
	}
	else{
		write-host "No Test Cases found. Creating test Suite." -ForegroundColor "green"
		create_test
	}
	
	$sw.Stop()
	$msg = "Total time elapsed in MiliSeconds: "+$sw.Elapsed.TotalMilliseconds
	write-host $msg -ForegroundColor "green"
}

function view_report(){
	if(Test-Path test_archive)
	{
		$dir = "test_archive"
		$latest = Get-ChildItem -Path $dir | Sort-Object LastAccessTime -Descending | Select-Object -First 1
		$file="file:///"+$buildPath+"\test_archive\"+$latest.name
		start $file
	}else{
		write-host "No Test Cases found." -ForegroundColor "green"
	}
}







