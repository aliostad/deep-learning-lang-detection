 #!/bin/bash
(set -o igncr) 2>/dev/null && set -o igncr; # For Cygwin on Windows compaibility

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    gcc -c src/InstallUpdateProcess/installUpdateProcess.c
    gcc -o installUpdateProcess installUpdateProcess.o
    if [ $? != 0 ]; then
		exit 1
	fi
    cp installUpdateProcess dist
    cp src/InstallUpdateProcess/*.py dist

    rm installUpdateProcess.o
    rm installUpdateProcess
fi

if [[ "$OSTYPE" == "cygwin" ]]; then
    cd src/InstallUpdateProcess
    ./build.bat
    cd ../
    cd ../
    mv src/InstallUpdateProcess/installUpdateProcess.exe dist
    mv src/InstallUpdateProcess/installUpdate.exe dist
    cp --preserve=all src/InstallUpdateProcess/ICSharpCode.SharpZipLib.dll phat-win32-x64/resources/app
fi