# ensure directories exist
New-Item -ItemType Directory -Force -Path Kola.Application\lib\net40
New-Item -ItemType Directory -Force -Path .\packages

# copy dlls
remove-item Kola.Application\lib\net40\*
Copy-Item  ..\Kola.Client\bin\debug\Kola.Client.dll Kola.Application\lib\net40\
Copy-Item  ..\Kola.Nancy\bin\debug\Kola.Nancy.dll Kola.Application\lib\net40\
Copy-Item  ..\Kola.Persistence\bin\debug\Kola.Persistence.dll Kola.Application\lib\net40\
Copy-Item  ..\Kola.Resources\bin\debug\Kola.Resources.dll Kola.Application\lib\net40\
Copy-Item  ..\Kola.Service\bin\debug\Kola.Service.dll Kola.Application\lib\net40\

# package
.\NuGet.exe pack .\Kola.Application\Kola.Application.nuspec -OutputDirectory .\packages
