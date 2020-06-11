Param($path,$version)

$apikey = "API-NLITTOD95WSOKIT7FLWVSKTGIW"

set-alias nuget $path\src\.nuget\NuGet.exe
set-alias octo $path\src\.deploy\Octo.exe

function deploy{
	param($project)

	Get-ChildItem -Path "$path\src\$project\obj\octopacked" -Filter "*.nupkg" -Recurse | ForEach-Object { 

		Write-Output "pushing $_.fullname"

		nuget push $_.fullname -ApiKey $apikey -Source http://localhost/nuget/packages

		octo create-release --project=$project --version=$version --packageversion=$version --server=http://localhost/api --apikey $apikey
		octo deploy-release --project=$project --version=$version --deployto=Tim --server=http://localhost/api --apikey $apikey
		octo deploy-release --project=$project --version=$version --deployto=Richmond --server=http://localhost/api --apikey $apikey
	}
}

deploy "Antix.EczemaDiary.Api"
