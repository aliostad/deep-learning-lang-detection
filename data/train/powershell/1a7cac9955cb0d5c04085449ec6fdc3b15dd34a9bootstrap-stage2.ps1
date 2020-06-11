# Invokes a Cmd.exe shell script and updates the environment.
function Invoke-CmdScript {
  param(
    [String] $scriptName
  )
  $cmdLine = """$scriptName"" $args & set"
  & $Env:SystemRoot\system32\cmd.exe /c $cmdLine |
  select-string '^([^=]*)=(.*)$' | foreach-object {
    $varName = $_.Matches[0].Groups[1].Value
    $varValue = $_.Matches[0].Groups[2].Value
    set-item Env:$varName $varValue
  }
}

# detect VC++2015 Build Tools
if (Test-Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualCppBuildTools\14.0){
    $hasvc14tools = $False -and [bool](gp HKLM:\SOFTWARE\Wow6432Node\Microsoft\VisualCppBuildTools\14.0).Installed
    Write-Warning "Visual C++ Build Tools 2015 were detected, but are not yet supported, sorry"
    Write-Warning "Will use Visual Studio 2013 if available"
    pause
}

# change to working directory
pushd ..\..

# clone latest sources from github
git clone https://github.com/deniskoronchik/sc-machine
git clone https://github.com/deniskoronchik/sc-web
git clone https://github.com/deniskoronchik/ims.ostis.kb
mkdir kb.bin

# cleanup sc-machine
pushd sc-machine
git clean -d -f -x
popd

# pull a minimum required subset of ims.ostis KB {

# recreate a target location anew
del -Recurse -Force -ErrorAction SilentlyContinue ims.ostis.kb_copy
mkdir ims.ostis.kb_copy

copy -Recurse ims.ostis.kb/ims/doc_technology_ostis/semantic_network_represent/ ims.ostis.kb_copy/
copy -Recurse ims.ostis.kb/ims/doc_technology_ostis/unificated_models/ ims.ostis.kb_copy/
copy -Recurse ims.ostis.kb/ims/doc_technology_ostis/semantic_networks_processing/ ims.ostis.kb_copy/
copy -Recurse ims.ostis.kb/ims/doc_technology_ostis/library_OSTIS/components_interface/ui_menu/ ims.ostis.kb_copy/
copy -Recurse ims.ostis.kb/ims/doc_technology_ostis/library_OSTIS/components_kpm/lib_c_agents/ ims.ostis.kb_copy/
copy -Recurse ims.ostis.kb/ims/doc_technology_ostis/library_OSTIS/components_kpm/lib_scp_agents/ ims.ostis.kb_copy/
copy -Recurse ims.ostis.kb/ims/doc_technology_ostis/library_OSTIS/components_kpm/programs_for_sc_text_processing/scp_program/ ims.ostis.kb_copy/
copy -Recurse ims.ostis.kb/to_check/ ims.ostis.kb_copy/
copy -Recurse ims.ostis.kb/ui/ ims.ostis.kb_copy/
del -Recurse ims.ostis.kb_copy\ui\menu
# }

# prepare GUI
pushd sc-web\scripts
.\client.bat
popd

copy config\server.conf sc-web\server

pushd sc-machine

# cleanup build directory
git clean -d -f -x

# ask user for QT installation directory and try to find msvc2013_64 there ourselves
$qtdir = Read-Host -Prompt "Qt5 install location"
$env:CMAKE_PREFIX_PATH = (dir -Path $qtdir -Filter msvc2013_64 -Directory -Recurse)[0].FullName

if($hasvc14tools){
    # pull in environment for vc++ 2015 build tools
    pushd "${env:ProgramFiles(x86)}\Microsoft Visual C++ Build Tools"
    Invoke-CmdScript vcbuildtools.bat amd64 
    popd
    # generate makefiles for x64 vs2015
    & "${env:ProgramFiles(x86)}\CMake\bin\cmake" -G 'Visual Studio 14 2015 Win64' .
}
else{
    # pull in environment for vs2013
    pushd $env:VS120COMNTOOLS\..\..\VC
    Invoke-CmdScript vcvarsall.bat amd64
    popd
    # generate makefiles for x64 vs2013
    & "${env:ProgramFiles(x86)}\CMake\bin\cmake" -G 'Visual Studio 12 2013 Win64' .
}

# build generated solution
msbuild /m sc-machine.sln /property:Configuration=Release

# copy required qt5 runtime libs
copy $env:CMAKE_PREFIX_PATH\bin\Qt5Core.dll bin\
copy $env:CMAKE_PREFIX_PATH\bin\Qt5Network.dll bin\
popd