cd "C:\Program Files\Octopus Deploy\Tentacle"

# http://localhost/api/certificates/certificate-global 

& .\Tentacle.exe create-instance --console --instance "Tentacle" --config "C:\Octopus\Tentacle\Tentacle.config" --console
& .\Tentacle.exe new-certificate --console --instance "Tentacle" --console
& .\Tentacle.exe configure --console --instance "Tentacle" --home "C:\Octopus" --console
& .\Tentacle.exe configure --console --instance "Tentacle" --app "C:\Octopus\Applications" --console
& .\Tentacle.exe configure --console --instance "Tentacle" --port "10933" --console

<#
& .\Tentacle.exe configure --console --instance "Tentacle" --trust "YOUR_OCTOPUS_THUMBPRINT" --console
& .\Tentacle.exe register-with --console --instance "Tentacle" --server "http://YOUR_OCTOPUS" --apiKey="API-YOUR_API_KEY" --role "web-server" --environment "Staging" --comms-style TentaclePassive --console
& .\Tentacle.exe service --console --instance "Tentacle" --install --start --console
#>
