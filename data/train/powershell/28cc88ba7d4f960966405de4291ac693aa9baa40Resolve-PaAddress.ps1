function Resolve-PaAddress {
    [CmdletBinding()]
    Param (
		[Parameter(Mandatory=$False,Position=0)]
		[array]$Name,
        
        [Parameter(Mandatory=$False)]
        [switch]$ShowNames
    )

    $ReturnObject = @()
    
    foreach ($n in $Name) {
        try {
            $CheckForAddress = Get-PaAddressObject $n
            
            $NewObject = "" | Select Name,Value
            $NewObject.Name = $CheckForAddress.Name
            $NewObject.Value = $CheckForAddress.Address
            
            if ($ShowNames) {
                $ReturnObject += $NewObject
            } else {
                $ReturnObject += $CheckForAddress.Address
            }
        } catch {
            try {
                $CheckForGroup = Get-PaAddressGroupObject $n
                if ($ShowNames) {
                    $ReturnObject += Resolve-PaAddress $CheckForGroup.Members -ShowNames
                } else {
                    $ReturnObject += Resolve-PaAddress $CheckForGroup.Members
                }
            } catch {
                $NewObject = "" | Select Name,Value
                $NewObject.Value = $n
                if ($ShowNames) {
                    $ReturnObject += $NewObject
                } else {
                    $ReturnObject += $n
                }
            }
        } 
    }
    
    return $ReturnObject
}