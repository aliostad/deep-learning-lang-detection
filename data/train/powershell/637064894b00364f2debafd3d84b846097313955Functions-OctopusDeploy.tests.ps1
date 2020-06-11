$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -ireplace "tests.", ""
. "$here\$sut"

. "$currentDirectoryPath\_Find-RootDirectory.ps1"
$rootDirectory = Find-RootDirectory $here

. "$here\Functions-Credentials.ps1"

function Get-OctopusCredentials
{
    $keyLookup = "OCTOPUS_API_KEY"
    $urlLookup = "OCTOPUS_URL"

    $creds = @{
        ApiKey = (Get-CredentialByKey $keyLookup);
        Url = (Get-CredentialByKey $urlLookup);
    }
    return New-Object PSObject -Property $creds
}

function New-OctopusMachine
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$octopusServerUrl,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$octopusApiKey,
        [string]$name=([Guid]::NewGuid().ToString("N")),
        [string]$role,
        [string]$environmentId
    )

    if ($rootDirectory -eq $null) { throw "rootDirectory script scoped variable not set. Thats bad, its used to find dependencies." }

    $rootDirectoryPath = $rootDirectory.FullName
    $commonScriptsDirectoryPath = "$rootDirectoryPath\scripts\common"

    . "$commonScriptsDirectoryPath\Functions-Strings.ps1"

    Ensure-OctopusClientClassesAvailable

    $endpoint = new-object Octopus.Client.OctopusServerEndpoint $octopusServerUrl,$octopusApiKey
    $repository = new-object Octopus.Client.OctopusRepository $endpoint

    $properties = @{
        Name="$name";
        Roles=(new-object Octopus.Platform.Model.ReferenceCollection(@($role)));
        EnvironmentIds=(new-object Octopus.Platform.Model.ReferenceCollection(@($environmentId)));
        Thumbprint=[Guid]::NewGuid().ToString("N");
        Uri="https://notarealuri.console.othsolutions.com.au"
    }
 
    $machine = New-Object Octopus.Client.Model.MachineResource -Property $properties

    write-verbose "Creating Octopus Machine with Name [$name]."
    $result = $repository.Machines.Create($machine)

    return $result
}

Describe "Get-OctopusToolsExecutable" {
    Context "When function executed" {
        It "Returns valid Octo executable" {
            $executable = Get-OctopusToolsExecutable

            $executable.FullName | Should Match "octo\.exe"
            $executable.FullName | Should Exist
        }
    }
}

Describe "New-OctopusDeployment" {
    Context "When supplied server does not exist" {
        It "Throws error with appropriate exit code as recieved from Octopus" {
            try
            {
                $result = New-OctopusDeployment -OctopusServerUrl "http://thisdoesnotexist.com:8084" -OctopusApiKey "THISAPIKEYISINVALID" -ProjectName "Non-existent Project" -Environment "CI" -Version "latest"
            }
            catch
            {
                $errorMessage = $_.Exception.Message
            }

            $errorMessage | Should Match "\[\-3\]"
        }
    }

    Context "When variables supplied via hashtable parameter" {
        It "Translates variables into valid format for underlying call to Octopus server" {
            $creds = Get-OctopusCredentials

            $result = New-OctopusDeployment -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -ProjectName "PowershellUnitTestsProject" -Environment "CI" -Variables @{TestVariable="VariableValue";AnotherVariable="VariableValue2"} -Wait
        }
    }
}

Describe "New-OctopusEnvironment" {
    Context "When supplied with a valid Octopus URL, Api Key and Environment that does not already exist" {
        It "Creates a new environment" {
            try
            {
                $creds = Get-OctopusCredentials

                $environmentName = [Guid]::NewGuid().ToString("N")
                $result = New-OctopusEnvironment -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -EnvironmentName $environmentName -EnvironmentDescription "[SCRIPT][TEST] Environment automatically created as part of a Unit test. It should be cleaned up, but if you're seeing this the cleanup probably failed."

                $result.Id | Should Not BeNullOrEmpty
                $result.Name | Should Be $environmentName
            }
            finally
            {
                if ($result -ne $null -and (![string]::IsNullOrEmpty($result.Id)))
                {
                    Delete-OctopusEnvironment -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -EnvironmentId $result.Id
                }
            }
        }
    }
}

Describe "Get-OctopusMachinesInRole" {
    Context "When supplied with a valid Octopus URL, Api Key and Role" {
        It "Returns all machines currently filling the specified Role" {
            try
            {
                $creds = Get-OctopusCredentials

                $role = [Guid]::NewGuid().ToString("N")
                $environment = New-OctopusEnvironment -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -EnvironmentName ([Guid]::NewGuid().ToString("N")) -EnvironmentDescription "[SCRIPT][TEST] Environment automatically created as part of a Unit test. It should be cleaned up, but if you're seeing this the cleanup probably failed."
                $a = New-OctopusMachine -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -Role $role -EnvironmentId $environment.Id
                $b = New-OctopusMachine -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -Role $role -EnvironmentId $environment.Id

                $result = Get-OctopusMachinesByRole -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -Role $role

                $result.Count | Should Be 2
                $result | Where-Object { $_.Id -eq $a.Id } | Should Not BeNullOrEmpty
                $result | Where-Object { $_.Id -eq $b.Id } | Should Not BeNullOrEmpty
            }
            finally
            {
                if ($a -ne $null)
                {
                    Delete-OctopusMachine -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -MachineId $a.Id
                }

                if ($b -ne $null)
                {
                    Delete-OctopusMachine -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -MachineId $b.Id
                }

                if ($environment -ne $null)
                {
                    Delete-OctopusEnvironment -OctopusServerUrl $creds.Url -OctopusApiKey $creds.ApiKey -EnvironmentId $environment.Id
                }
            }
        }
    }
}

Describe "Get-LastReleaseToEnvironment" {
    Context "When no releases have been made to an environment" {
        It "Returns the special string: latest" {
            $creds = Get-OctopusCredentials

            $result = Get-LastReleaseToEnvironment -octopusServerUrl $creds.Url -octopusApiKey $creds.ApiKey -environment "NotARealEnvironment" -project "PowershellUnitTestsProject"
            $result | Should Be "latest"
        }
    }

    Context "When releases have been made to an environment" {
        It "Returns the release version number" {
            $creds = Get-OctopusCredentials

            $result = Get-LastReleaseToEnvironment -octopusServerUrl $creds.Url -octopusApiKey $creds.ApiKey -environment "CI" -project "PowershellUnitTestsProject"
            $result | Should Be "1.0.0"
        }
    }
}