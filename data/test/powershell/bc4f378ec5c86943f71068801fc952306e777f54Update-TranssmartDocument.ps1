<#
.Synopsis
Updates a document
#>
function Update-TranssmartDocument
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
        [Transsmart.Api.Models.Document]$Document
    )

    $Client = New-Object -TypeName Transsmart.Api.Client -ArgumentList $Url, $UserName, $Password
    $Client.UpdateDocument($Document.ID, $Document)
}