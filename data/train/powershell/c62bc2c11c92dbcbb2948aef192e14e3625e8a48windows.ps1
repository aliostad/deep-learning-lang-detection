#### CONFIGURATION ####
## Warning: you must not have space in paths
$qt_path = "C:\Qt\5.4\mingw491_32"
$mingw_path = "C:\Qt\Tools\mingw491_32"
$build_path = "C:\Users\Aroquemaurel\Documents\build-FactDev-Desktop_Qt_5_4_1_MinGW_32bit-Release"
$repo_path = "C:\Users\Aroquemaurel\Documents\FactDev"
$innosetup_path = "& 'C:\Program Files (x86)\Inno Setup 5\ISCC.exe'"

$nb_process = 3



function call
{
    iex $args[0]  
}

function mkdirIfNotExist
{
    $dir = $args[0]
    $ret = Test-Path $dir 
    if (-not $ret) {
       mkdir $dir
    } 
}

function rmdirIfExist
{
    $dir = $args[0]
    $ret = Test-Path $dir 
    if ($ret) {
       rmdir -r $dir
    } 
}

function rmIfExist
{
    $file = $args[0]
    $ret = Test-Path $file 
    if ($ret) {
       rm $file
    } 
}

function copyPlugin 
{
    $plugin_name = $args[0]
    mkdirIfNotExist $plugin_name
    call ("cp "+$qt_path+"\plugins\"+$plugin_name+"\*.dll "+$plugin_name)
    call ("rm """+$plugin_name+"/*d.dll""")
}

function copyQtDll 
{
    $dll_name = $args[0]
    call ("cp "+$qt_path+"\bin\"+$dll_name+".dll .")
}



$make_path = $mingw_path + "\bin\mingw32-make.exe"
$qmake_path = $qt_path + "\bin\qmake.exe"
$make_nbprocess = " -j"+$nb_process

cd $build_path

#### COMPILATION ####
## WARNING: We assume that FactDev is already compilled and is work correctly.
# Create build folder
#mkdirIfNotExist build
#cd build

# QMake execution
#call  ($qmake_path + " """ +$repo_path + "\FactDev.pro"" -config release -r -spec win32-g++")

# Make clean, just in case
#call ($make_path + " clean")



#### Copy dll files ####
cd app/release
# Copy plugins folders
copyPlugin "imageformats"
copyPlugin "platforms"
copyPlugin "sqldrivers"

# Copy dll 
copyQtDll "icudt53"
copyQtDll "icuin53"
copyQtDll "icuuc53"
copyQtDll "libgcc_s_dw2-1"
copyQtDll "libstdc++-6"
copyQtDll "libwinpthread-1"
copyQtDll "Qt5Concurrent"
copyQtDll "Qt5Core"
copyQtDll "Qt5Gui"
copyQtDll "Qt5PrintSupport"
copyQtDll "Qt5Sql"
copyQtDll "Qt5Widgets"

rmdirIfExist sql
call ("cp "+$build_path+"\src\release\FactDev.dll .") # Copy FactDev.dll
call ("cp -Recurse "+$repo_path+"\src\sql .") # Copy sql files
call ("cp "+$repo_path+"\fact-team.github.io\doc\usermanual.pdf manuel.pdf") # Copy sql files
cp app.exe FactDev.exe


# Innosetup execution : creation of installer
call ("cd "+$repo_path+"\deploy") 
call ($innosetup_path+" .\setup.iss")

