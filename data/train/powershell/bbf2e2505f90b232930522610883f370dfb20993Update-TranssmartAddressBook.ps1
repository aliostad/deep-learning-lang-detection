<#
.Synopsis
Updates an address book entry
#>
function Update-TranssmartAddressBook
{
    Param
    (
        [Parameter(Mandatory)]
        [string]$Url,

        [Parameter(Mandatory)]
        [string]$UserName,

        [Parameter(Mandatory)]
        [AllowNull()]
        [string]$Password,

        [Parameter(Mandatory, ValueFromPipeLine)]
        [Transsmart.Api.Models.AddressBook]$AddressBook        
    )

    $Client = New-Object -TypeName Transsmart.Api.Client -ArgumentList $Url, $UserName, $Password
    $Client.UpdateAddressBook($AddressBook.ID, $AddressBook)
}