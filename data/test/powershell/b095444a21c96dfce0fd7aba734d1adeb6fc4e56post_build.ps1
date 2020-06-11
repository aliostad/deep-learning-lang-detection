mkdir udpgame -Force > $null
copy x64\Release\client.exe udpgame\
copy x64\Release\server.exe udpgame\
mkdir udpgame\resources -Force > $null
xcopy ..\resources\* udpgame\resources\ /s /e
copy packages\zlib.redist.1.2.8.6\build\native\bin\v110\x64\Release\dynamic\cdecl\zlib.dll udpgame\
copy packages\sfml.redist.2.1.0.0\build\native\bin\x64\v110\Release\Desktop\sfml-system-2.dll udpgame\
copy packages\sfml.redist.2.1.0.0\build\native\bin\x64\v110\Release\Desktop\sfml-network-2.dll udpgame\
copy packages\SDL_image.redist.1.2.12.1\build\native\bin\Release\x64\v110\SDL_image.dll udpgame\
copy packages\SDL.redist.1.2.15.15\build\native\bin\v110\x64\Release\dynamic\SDL.dll udpgame\
copy packages\libtiff.redist.4.0.1.9\build\native\bin\Release\x64\v110\libtiff.dll udpgame\
copy packages\libpng.redist.1.5.10.11\build\native\bin\x64\v110\dynamic\Release\libpng15.dll udpgame\
copy packages\libjpeg.redist.9.0.1.3\build\native\bin\v110\x64\Release\dynamic\cdecl\jpeg.dll udpgame\
copy packages\libjpeg.redist.9.0.1.3\build\native\bin\v110\x64\Release\dynamic\cdecl\jpeg.dll udpgame\libjpeg.dll
copy lib\x64_dll\msvcr110.dll udpgame\
copy lib\x64_dll\msvcp110.dll udpgame\
tools\7za.exe a -tzip ..\udpgame.zip udpgame
