function edit-xml {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)] [string]$filename,
        [Parameter(Position=1,Mandatory=1)] [string]$xpath,
        [Parameter(Position=2,Mandatory=1)] [scriptblock]$action
    )

    if( -not (test-path $filename)) {
        throw "XML file $filename not found"
    }

    $xml = new-object -typename xml

    try {
        $xml.load((resolve-path $filename))
    } catch {
        throw "Specified file $filename is not valid XML"
    }

    $node = select-xml $xpath $xml -namespace $namespaces

    if( $node -ne $null ) {
        & $action $node.node
        $xml.save((resolve-path $filename))
    }
}

