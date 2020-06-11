Set-StrictMode -Version Latest

<# Import function file #>
$srcFile = $MyInvocation.MyCommand.Path `
        -replace 'tests\\modules\\(.*?)\.Test\\(.*?)\.Tests\.ps1', `
                 'src\modules\$1\$2.ps1'
. $srcFile

<# Tests #>
Describe 'New-InvalidDataException' {

    It 'should have a default message' {
        $errorObject = New-InvalidDataException -SourceObject 'foo'
        $errorObject.toString() | Should Be 'No error message set'
    }

    It 'should have a default source object' {
        $errorObject = New-InvalidDataException -Message 'foo'
        $errorObject.targetObject | Should Be 'No source object set'
    }

    It 'should have InvalidData category' {
        $errorObject = New-InvalidDataException -Message 'foo'
        $errorObject.categoryInfo | Should Match 'InvalidData'
    }
}
