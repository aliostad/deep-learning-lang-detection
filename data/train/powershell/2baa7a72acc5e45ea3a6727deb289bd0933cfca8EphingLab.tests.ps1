. C:\Users\rephgrave.CONCURRENCY\Documents\EphingLab\EphingLab.ps1

Describe "Mount-EphingDrive" {
    It "Returns drive letter when one drive returned" {
        Mock Mount-VHD { [PSCustomObject]@{ DiskNumber = 2 } }
        Mock Get-Partition { [PSCustomObject]@{ DriveLetter = 'C' } }
        $Drive = Mount-EphingDrive -Path 'C:\PathToVHD.vhdx'
        $Drive | Should Be 'C'
    }
}

Describe "Write-EphingLog" {
    It "Returns the message" {
        $Log = Write-EphingLog -Message 'This is a test'
        $Log | Should Be 'This is a test'
    }
    It "Returns the error message" {
        $Log = Write-EphingLog -Message 'This is a test' -ErrorMessage 'This is an error test' 
        $Log | Should Be 'This is an error test'
    }
}

