# Copyright 2014 FreemanSoft Inc
# Licensed under the Apache License, Version 2.0 (the "License");
#
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
$CurrentDirectory = (Get-location).Path
#I've only tested this script while my pwd was in the same directory as script
if ( $CurrentDirectory -ne $PSScriptRoot)
{
	echo "You can only run this script while sitting in the directory it is in $PSScriptRoot"
	exit 1
} 
if ( Test-Path Env:\java_home )
{
    #echo "java_home exists"
} else {
	echo  "JAVA_HOME must be set before running this script"
	exit 1
}

# 1.  build the performance dll inside visual studio in debug mode.
# 2.  run this script to build the JNI interchange components
#
# if this fails with a System.IO.FileLoadException then maybe the jni dlls are blocked by windows security
# you can unblock them using the properties inspector in windows explorer 
# you may have to also unblock proxygen.exe itself
#$originalpath = $env:path

# this should be the current working directory
$projectroot = "$PSScriptRoot\"
$perfslnpath = "WindowsPerformanceCountersForJava"
$perfsln = $perfslnpath + "\WindowsPerformanceCountersForJava.sln"
$perfdllpath = $perfslnpath +"\src\PerformanceCounters\bin\Debug\FreemanSoft.PerformanceCounters.dll"
$jni4netroot = "jni4net-0.8.6.0-bin\"
$jni4netbinpath = $projectroot+$jni4netroot+"bin\"
$jni4netlibpath = $projectroot+$jni4netroot+"lib\"
$targetdir = "generated\target"
$javactargerdir = "generated\classes"
$javadoctargerdir = "generated\docs"
$javagensourcedir = "generated\jvm"
$packagingdir = "packages"
# use .Net 3.5 or later
$dotnetpath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319"
$csc = $dotnetpath+"\csc.exe"
$msbuild = $dotnetpath+"\msbuild.exe"
# JDK 1.5 or later -- should use JAVA_HOME\bin if it exists or verify if already on path
$javacpath="$env:java_home\bin"
if ( Test-Path $csc)
{
	# echo "found csc.exe"
} else {
	echo "Can't find csc.exe in $csc.  Verify that is the right path for you"
	exit 1
}
if ( Test-Path $msbuild)
{
	# echo "found msbuild.exe"
} else {
	echo "Can't find msbuild.exe in $msbuild.  Verify that is the right path for you"
	exit 1
}
if ( Test-Path $perfsln)
{
	# echo "found solution file"
} else {
	echo "Can't find solution $perfsln.  Verify that is the right path for you"
	exit 1
}
if ( Test-Path $javacpath\javac.exe)
{
	# echo "found javac"
} else {
	echo "Can't find javac.exe in $javacpath.  Verify that is the right path for you"
	exit 1
}
$env:path=$jni4netbinpath+";"+$dotnetpath+";"+$javacpath+";"+$env:path
echo "Temporarily modified path"
#echo $env:path

# building the debug version
echo "Generating C# performance library that we will wrap"
& $msbuild $perfsln /target:Clean /target:Build

echo "Generating JNI code using proxygen"
# its on the path now.
# comment this out once you've built if you want to hand hack generated files while testing
proxygen.exe java-to-perf.proxygen.xml

# hack on the generated file to fix a "bug" in jni4net where the thread-to-thread binding is not retained across calls
.\3hackgeneratedcs.ps1

# hack on the generated java to patch in javadoc
.\4hackgeneratedjava.ps1

#compile classes
New-item -ItemType Directory -Force -Path $javactargerdir | Out-Null
echo "Compiling generated java code"
javac -g -nowarn -d $javactargerdir -sourcepath $javagensourcedir -cp $jni4netlibpath/jni4net.j-0.8.6.0.jar generated/jvm/freemansoft/performancecounters/WindowsPerformanceLiason.java generated/jvm/freemansoft/performancecounters/WindowsPerformanceFacade.java

#jar them up
New-item -ItemType Directory -Force -Path $packagingdir | Out-Null
echo "Creating generated jar file"
jar cf $packagingdir/FreemanSoft.PerformanceCounters.j4n.jar  -C generated\classes freemansoft

# create the javadoc
New-item -ItemType Directory -Force -Path $javadoctargerdir | Out-Null
javadoc -d $javadoctargerdir -sourcepath $javagensourcedir  -classpath $jni4netlibpath/jni4net.j-0.8.6.0.jar freemansoft.performancecounters
jar cf $packagingdir/FreemansSoft.PerformanceCounters.j4n-javadoc.jar -C $javadoctargerdir .

#compile the jni code into a dll
$cscreference_jni4net = "/reference:$jni4netlibpath\jni4net.n-0.8.6.0.dll"
$cscreference_perfdll = "/reference:$perfdllpath"
$cscout = "/out:$packagingdir\FreemanSoft.PerformanceCountersJNI.j4n.dll"
$csctarget = "/target:library"
$cscsourcefiles = "/recurse:generated\clr\*.cs"
echo "Compiling generated C# code"
#echo "csc.exe /warn:0 $cscreference_jni4net $cscreference_perfdll $cscout $csctarget $cscsourcefiles"
csc.exe /nologo /warn:0 $cscreference_jni4net $cscreference_perfdll $cscout $csctarget $cscsourcefiles

echo "copying jni4net libraries to target"
Copy-Item $jni4netlibpath\* $packagingdir
echo "copying original dll $perfdllpath to target"
Copy-Item $perfdllpath $packagingdir

######################################## end library construction ##########################
#
# This next section belongs in a different powershell script but I don't have enough 
# powershell fu to avoid copy/past of properties so I'm leaving it here
#
######################################## begin sample ######################################
echo "========================== Starting Samples ==================================="
# compiling sample
echo "Compiling Java CacheTest sample"
New-item -ItemType Directory -Force -Path $targetdir/classes | Out-Null
# java 6 and later support wildcards
javac -nowarn -cp "$packagingdir/*" -d $targetdir/classes java-sample/CacheTest.java java-sample/MultiThreadedLiasonTest.java java-sample/MultiThreadedFacadeTest.java
echo "------------------------------- Sample cache dirty pages retriever started -------------------"
#need $packagingdir/* for jars and $packagingdir for dll
java -cp "$packagingdir/*;$targetdir/classes;$packagingdir" CacheTest
echo "------------------------------- Sample cache dirty pages retriever finished-------------------"

$categoryexists = [System.Diagnostics.PerformanceCounterCategory]::Exists("FreemanSoft.JavaTestCategory")
if ($categoryexists)
{
	echo "------------------------------- Sample facade based load test started -------------------"
	#need $packagingdir/* for jars and $packagingdir for dll
	#echo 'java -cp "$packagingdir/*;$targetdir/classes;$packagingdir" MultiThreadedFacadeTest'
	java -cp "$packagingdir/*;$targetdir/classes;$packagingdir" MultiThreadedFacadeTest
	echo "------------------------------- Sample facade based load test finished-------------------"
	echo "------------------------------- Sample liason based load test started -------------------"
	#need $packagingdir/* for jars and $packagingdir for dll
	java -cp "$packagingdir/*;$targetdir/classes;$packagingdir" MultiThreadedLiasonTest
	echo "------------------------------- Sample liason based load test finished-------------------"
} else {
echo "Not running performance test because performance category does not exist."
echo "You must run the ps1 file in the java directory as administrator to create the category"
}

######################################## end sample ######################################

$env:path = $originalpath
echo "Restored path"
#echo $env:path

