Param(
  [string]$name ,
  [string]$version,
  [string]$environment,
  [string]$file
)

function Upload-Environment
{
    # ====== Get-Environment ====== #

    # Gets the environment either from Chef or from a file.
    #
    # If the -environment parameter is specified, we fetch that environment from Chef
    # Otherwise we fetch it from an already saved file.

    function Get-Environment
    {
        if ($environment -ne $null -and $environment -ne "") {
            & knife environment show $environment -F json
        }
        else {
            Get-Content $(Resolve-Path $file)
        }
    }


    # ====== Add-Version ====== #

    # Adds the package name and version to the environment.

    function Add-Version($env)
    {
        if ($env.cookbook_versions -eq $null) {
            $env | Add-Member -type NoteProperty `
                -name cookbook_versions `
                -value $(New-Object -type Object)
        }

        $env.cookbook_versions | Add-Member -type NoteProperty `
            -name $name `
            -value "= $version" `
            -force
    }

    # ====== Save-Environment ====== #

    # Saves the environment back to either Chef or the file
    # If the -file parameter is specified, we save the environment to that file.
    # Otherwise we save it to Chef.

    function Save-Environment($env)
    {
        $newJson = $env | ConvertTo-Json -Compress

        function Save-EnvironmentToFile($target) {
            $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
            [System.IO.File]::WriteAllLines($target, $newJson ,$Utf8NoBomEncoding)
        }

        function Save-EnvironmentToChef($target) {
            & knife environment from file $target
        }

        if ($file -ne $null -and $file -ne "") {
            Save-EnvironmentToFile $(Resolve-Path $file)
        }
        else {
            $scriptPath = Resolve-Path .
            $target = "$scriptPath\environment.json" 
            Save-EnvironmentToFile $target
            Save-EnvironmentToChef $target
            del $target
        }
    }


    $env = Get-Environment | out-string | ConvertFrom-Json
    Add-Version $env
    Save-Environment $env
}

Upload-Environment