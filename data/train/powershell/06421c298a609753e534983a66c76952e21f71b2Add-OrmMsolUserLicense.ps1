function Add-OrmMsolUserLicense
{
    [cmdletbinding()]
    param (
        [parameter(
            Mandatory=$true,
            Position=0,
            ValueFromPipelineByPropertyName=$true
        )]
        [string]$UserPrincipalName,
        [parameter(
            Mandatory=$true,
            Position=1
        )]
        [string]$License,
        [parameter(
            Mandatory=$false,
            Position=2
        )]
        [string]$UsageLocation
    )
    begin
    {
        New-OrmLog -logvar $logvar -Status 'Start' -LogDir $KworkingDir -ErrorAction Stop -Message "Starting procedure: $($procname)"
    }
    process
    {
        New-OrmLog -logvar $logvar -Status 'Info' -LogDir $KworkingDir -ErrorAction Stop -Message "Verifying if AccountSku contains $License"
        $MSOLAccountSkuId = try {(Get-MsolAccountSku -ErrorAction SilentlyContinue).AccountSkuId} catch {}
        if ($MsolAccountSkuId -contains "$License")
        {
            New-OrmLog -logvar $logvar -Status 'Success' -LogDir $KworkingDir -ErrorAction Stop -Message "AccountSku contains $License"
            New-OrmLog -logvar $logvar -Status 'Info' -LogDir $KworkingDir -ErrorAction Stop -Message "Verifying if $UserPrincipalName already exists"
            $MsolUser = try {Get-MsolUser -UserPrincipalName "$UserPrincipalName" -ErrorAction SilentlyContinue} catch {}
            if ($MsolUser -ne $null)
            {
                New-OrmLog -logvar $logvar -Status 'Success' -LogDir $KworkingDir -ErrorAction Stop -Message "$UserPrincipalName does not yet exist" 
                New-OrmLog -logvar $logvar -Status 'Info' -LogDir $KworkingDir -ErrorAction Stop -Message "Verifying if UsageLocation is set on $UserPrincipalName" 
                #If usage location is not set, adding the license will fail
                if (($MsolUser).UsageLocation -ne $null)
                {
                    New-OrmLog -logvar $logvar -Status 'Success' -LogDir $KworkingDir -ErrorAction Stop -Message "UsageLocation is set on $UserPrincipalName" 
                    New-OrmLog -logvar $logvar -Status 'Info' -LogDir $KworkingDir -ErrorAction Stop -Message "Adding license $License to $UserPrincipalName" 
                    try
                    {
                        Set-MsolUserLicense -UserPrincipalName $UserPrincipalName -AddLicenses $License
                        New-OrmLog -logvar $logvar -Status 'Success' -LogDir $KworkingDir -ErrorAction Stop -Message "Added license $License to $UserPrincipalName" 
                    }
                    catch
                    {
                        New-OrmLog -logvar $logvar -Status 'Failure' -LogDir $KworkingDir -ErrorAction Stop -Message "Failed to add license $License to $UserPrincipalName" 
                    }
                }
                else
                {
                    New-OrmLog -logvar $logvar -Status 'Error' -LogDir $KworkingDir -ErrorAction Stop -Message "Usagelocation not set to $UserPrincipalName" 
                }   
            }
            else
            {
                New-OrmLog -logvar $logvar -Status 'Error' -LogDir $KworkingDir -ErrorAction Stop -Message "$UserPrincipalName not found!" 
            }
        }
        else
        {
            New-OrmLog -logvar $logvar -Status 'Error' -LogDir $KworkingDir -ErrorAction Stop -Message "$License not available" 
        }
    }
    end
    {
    }
}
Add-OrmMsolUserLicense -UserPrincipalName 'JeffWouters@ormer.onmicrosoft.com' -UsageLocation 'NL' -License 'Ormer:ENTERPRISEPACK'