Function Parse-ROOT-Set-Zone
{
    [CmdletBinding()]
    param(
        [string[]]
        [parameter(Mandatory=$true)]
        $params
    )

    [ZoneProfile]$zone_instance = $Null
    if(PhraseMatch $params 'name',$RE_QUOTED_NAME) {
        $zone_name = $last_matches[0]['QUOTED_NAME']

        if(-not $ZoneDic.Contains($zone_name)) {
            $zone_instance = New-Object ZoneProfile
            $zone_instance.Name = $zone_name
            [ZoneProfile]$ZoneDic[$zone_name] = $zone_instance
        }
        return
    } elseif(PhraseMatch $params $RE_QUOTED_NAME -prefix) {
        $zone_name = $last_matches[0]['QUOTED_NAME']

        if(-not $ZoneDic.Contains($zone_name)) {
            $zone_instance = New-Object ZoneProfile
            $zone_instance.Name = $zone_name
            [ZoneProfile]$ZoneDic[$zone_name] = $zone_instance
        } else {
            $zone_instance = $ZoneDic[$zone_name]
        }

        if(PhraseMatch $params 'vrouter',$RE_QUOTED_OR_NOT_QUOTED_NAME -offset 1) {
            $zone_instance.VRouter = $last_matches[0]['QUOTED_OR_NOT_QUOTED_NAME']
        } elseif(PhraseMatch $params 'tcp-rst' -offset 1) {
            $zone_instance.TCPRst = $True
        } elseif(PhraseMatch $params 'block' -offset 1) {
            $zone_instance.Block = $True
        } elseif(PhraseMatch $params 'screen' -offset 1 -prefix) {
            Parse-ROOT-Set-Screen @(ncdr $params 2) $zone_name
        } elseif(PhraseMatch $params 'manage',$RE_MANAGEMENT_SERVICE -offset 1) {
            New-ObjectUnlessDefined ([ref]$zone_instance) ManagementService
            $zone_instance.ManagementService.Set($params[2])
        } else {
            throw "SYNTAX ERROR @ $($myinvocation.mycommand.name): $line"
        }
    } elseif(PhraseMatch $params 'id',$RE_INTEGER,$RE_QUOTED_NAME) {
        $zone_name = $last_matches[1]['QUOTED_NAME']

        if(-not $ZoneDic.Contains($zone_name)) {
            $zone_instance = New-Object ZoneProfile
            $zone_instance.Name = $zone_name
            [ZoneProfile]$ZoneDic[$zone_name] = $zone_instance
        } else {
            $zone_instance = $ZoneDic[$zone_name]
        }

        $zone_instance.id = [int]$params[1]
    } else {
        throw "SYNTAX ERROR @ $($myinvocation.mycommand.name): $line"
    }
}

Function Parse-ROOT-Unset-Zone
{
    [CmdletBinding()]
    param(
        [string[]]
        [parameter(Mandatory=$true)]
        $params
    )

    [ZoneProfile]$zone_instance = $Null
    if(PhraseMatch $params 'name',$RE_QUOTED_NAME) {
        $zone_name = $last_matches[0]['QUOTED_NAME']

        if($ZoneDic.Contains($zone_name)) {
            $ZoneDic.Remove($zone_name)
            return
        }
    } elseif(PhraseMatch $params $RE_QUOTED_NAME -prefix) {
        $zone_name = $last_matches[0]['QUOTED_NAME']

        if($params.Count -eq 1 -and $ZoneDic.Contains($zone_name)) {
            $ZoneDic.Remove($zone_name)
            return
        } else {
            if(-not $ZoneDic.Contains($zone_name)) {
                $zone_instance = New-Object ZoneProfile
                $zone_instance.Name = $zone_name
                [ZoneProfile]$ZoneDic[$zone_name] = $zone_instance
            } else {
                $zone_instance = $ZoneDic[$zone_name]
            }

            if(PhraseMatch $params 'vrouter' -offset 1) {
                $zone_instance.VRouter = $Null
            } elseif(PhraseMatch $params 'tcp-rst' -offset 1) {
                $zone_instance.TCPRst = $False
            } elseif(PhraseMatch $params 'block' -offset 1) {
                $zone_instance.Block = $False
            } elseif(PhraseMatch $params 'screen' -offset 1 -prefix) {
                Parse-ROOT-Unset-Screen @(ncdr $params 2) $zone_name
            } elseif(PhraseMatch $params 'manage',$RE_MANAGEMENT_SERVICE -offset 1) {
                New-ObjectUnlessDefined ([ref]$zone_instance) ManagementService
                $zone_instance.ManagementService.Unset($params[2])
            } else {
                throw "SYNTAX ERROR @ $($myinvocation.mycommand.name): $line"
            }
        }
    } else {
        throw "SYNTAX ERROR @ $($myinvocation.mycommand.name): $line"
    }
}
