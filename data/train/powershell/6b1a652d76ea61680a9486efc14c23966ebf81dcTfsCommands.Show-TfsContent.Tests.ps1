# TfsCommands - PowerShell wrappers around tf.exe
#               - Pester unit tests for Show-TfsContent

# Copyright (c) 2014-2016 Trevor Barnett

# Released under terms of the MIT License - see LICENSE for details.

# Apart from parameter construction, almost all work in the module is ultimately
# delegated to tf.exe, which don't want to call in these tests.  Therefore the
# tests make a large use of mocks to verify that the correct command line is
# constructed.  This inevitably creates brittle tests, but best can do without
# actually integrating with a real TFS instance.

Param (
  [switch] $NoModuleImport
)

if (-not $NoModuleImport) {
  Import-Module TfsCommands -Force
}

Describe 'Show-TfsContent' {

  Mock -ModuleName TfsCommands Invoke-TfsCommand { }
  Mock -ModuleName TfsCommands Invoke-TfsCommandAtLocation { }

  It 'shows source controlled content of specified server or local directory' {
    $localOrServerPath = '$/project/directory'

    Show-TfsContent $localOrServerPath

    $assertArgs = @{
      ModuleName = 'TfsCommands'
      CommandName = 'Invoke-TfsCommand'
      ParameterFilter = {
        $Command -ieq 'dir' -and
        $Arguments -icontains $localOrServerPath -and
        $Arguments.Count -eq 1
      }
    }
    Assert-MockCalled @assertArgs
  }
  
  It 'defaults to current directory if path not specified' {
    Show-TfsContent

    $assertArgs = @{
      ModuleName = 'TfsCommands'
      CommandName = 'Invoke-TfsCommand'
      ParameterFilter = {
        $Command -ieq 'dir' -and
        $Arguments -icontains '.' -and
        $Arguments.Count -eq 1
      }
    }
    Assert-MockCalled @assertArgs
  }
  
  It 'optionally accepts version spec' {
    $version = 'C12345'

    Show-TfsContent -Version $version
    
    $assertArgs = @{
      ModuleName = 'TfsCommands'
      CommandName = 'Invoke-TfsCommand'
      ParameterFilter = { $Arguments -icontains "/version:$version" }
    }
    Assert-MockCalled @assertArgs
  }
  
  It 'optionally recurses sub-directories' {
    # PowerShell convention calls parameter "Recurse" not "Recursive"
    Show-TfsContent -Recurse
    
    $assertArgs = @{
      ModuleName = 'TfsCommands'
      CommandName = 'Invoke-TfsCommand'
      ParameterFilter = { $Arguments -icontains "/recursive" }
    }
    Assert-MockCalled @assertArgs
  }

  It 'optionally shows only folders' {
    Show-TfsContent -FoldersOnly
    
    $assertArgs = @{
      ModuleName = 'TfsCommands'
      CommandName = 'Invoke-TfsCommand'
      ParameterFilter = { $Arguments -icontains "/folders" }
    }
    Assert-MockCalled @assertArgs
  }

  It 'optionally shows deleted items' {
    Show-TfsContent -IncludeDeleted
    
    $assertArgs = @{
      ModuleName = 'TfsCommands'
      CommandName = 'Invoke-TfsCommand'
      ParameterFilter = { $Arguments -icontains "/deleted" }
    }
    Assert-MockCalled @assertArgs
  }

  It 'List-TfsContent is an alias' {
    $localOrServerPath = '$/project/directory'

    List-TfsContent $localOrServerPath

    $assertArgs = @{
      ModuleName = 'TfsCommands'
      CommandName = 'Invoke-TfsCommand'
      ParameterFilter = {
        $Command -ieq 'dir' -and
        $Arguments -icontains $localOrServerPath -and
        $Arguments.Count -eq 1
      }
    }
    Assert-MockCalled @assertArgs
  }
}
