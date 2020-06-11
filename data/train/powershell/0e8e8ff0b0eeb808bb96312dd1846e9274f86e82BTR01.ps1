<#
.Synopsis 
(WIP) Displays the content of the passed-in BTR file - currently only 4B and 4C records, and a partial 3A record 
.Description 
Display the content of all 4B and 4C BTR records found in the file, based on the specification referenced elsewhere on the blog 
. Example 
(cd C:\sandbox\GitRepos\BTRTaser)
Show-ComplianceFileContent -fileType "RAS" -filePath .\TestData\RAS001.TXT
#>
# constants: 
$separatorLine = "---------------------------------------------------------------------------------------"

$RAS = "RAS"
$BTR = "BTR"

. .\ComplianceSpecifications.ps1

function Show-ComplianceRecord ($currentRecord, $startPos, $columnLength, $displayName) {
    $len = $currentRecord.length
    if ($len -lt ([int] $startPos + $columnLength)) {
        Write-Host "The current record only contains [$len] characters, but you have asked for a column [$displayName] at position [$startPos, $columnLength]. Exiting..."
        $msg = Read-Host "Press a key to exit the program"
        break
    }
    $columnValue = $currentRecord.substring($startpos, $columnLength) 
    Write-Host "$DisplayName [$columnLength]: [" -Foregroundcolor White -NoNewline; write-Host "$columnValue" -ForegroundColor Cyan -NoNewLine; write-Host "]" -ForegroundColor White 
}


function Process-ComplianceRecord ($currentRecord, $fileType) {

    $recordType = Get-RecordType $currentRecord
    Write-Host "$separatorLine"
    Get-ComplianceRecordDefinition $recordType $fileType | % {
        $columnDefinition = $_ -split ","

        $offset = [int] $columnDefinition[0] - 1
        $columnLength = $columnDefinition[1] 
        $columnName = $columnDefinition[2] -replace "`"" 

        Confirm-RecordSize $currentRecord $fileType
        Show-ComplianceRecord $currentRecord $offset $columnLength $columnName
    }
}

function Confirm-RecordSize ($currentRecord, $fileType) {

    $recordType = Get-RecordType $currentRecord
    $expectedRecordSize = Get-ComplianceRecordSize $recordType $fileType 
    $currentRecordSize = $currentRecord.length
    if ($currentRecordSize -ne $expectedRecordSize) {
        Write-Host "Confirming [$fileType] [$recordType]"
        Write-Host "Record size should be [$expectedRecordSize] but is [$currentRecordSize]"
        break
    }
}

function Get-ComplianceModel ($filePath) {
    Write-Host "Found in file [$filePath]"
    return Get-Content $filePath
}

function Get-RecordType ($currentRecord) {
    return $currentRecord.substring(0,2)
}

# Entry point:
function Show-ComplianceFileContent ($fileType, $filePath) {
    Clear-Host
    Write-Host "$separatorLine"
    $validFileTypes = $BTR,$RAS
    if ($validFileTypes -notcontains $fileType ) {
       Write-Host "File type [$fileType] not recognised. Exiting..."
       return
    }
    Get-ComplianceModel $filePath | foreach { Process-ComplianceRecord $_ $fileType }
    Write-Host "$separatorLine"
    return
}

#Show-ComplianceFileContent -fileType "RAS" -filePath "C:\sandbox\GitRepos\BTRTaser\TestData\RAS001.TXT" 
#Show-ComplianceFileContent -fileType "BTR" -filePath "C:\sandbox\GitRepos\BTRTaser\TestData\BTR001.TXT" 

