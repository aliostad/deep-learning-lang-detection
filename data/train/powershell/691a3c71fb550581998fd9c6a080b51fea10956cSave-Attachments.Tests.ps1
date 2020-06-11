$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe -Tag 'Attachment' "Save-Attachments" {

    # arrange
    $url='http://apps/ReportRequests'
    $list='ReportRequests'
    $ItemId=7579
    $File='7579 - Results.xlsx'
    $Destination = 'TestDrive:\'

    It -Skip "Should save the attachment to the desired location" {
        # act
        Save-Attachments -WebUrl $url -listName $list -ItemId $ItemId -Name $File -Path $Destination -Verbose

        # assert
        Join-Path $Destination $File | Should Exist
    }

    It -Skip "Should return a FileInfo object if -Passthru is set" {
        # act
        $FileInfo=Save-Attachments -WebUrl $url -listName $list -ItemId $ItemId -Name $File -Path $Destination -Passthru
        #   Write-Host $FileInfo.FullName

        # assert
        $FileInfo.GetType()| Should Be System.Io.FileInfo
    }
}
