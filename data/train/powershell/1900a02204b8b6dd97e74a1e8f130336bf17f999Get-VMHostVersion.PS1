Begin {
    $ProductNameExp = @{
        Name = "ProductName"
        Expression = { $_.Config.Product.Name }
    }
    $VersionExp = @{
        Name = "Version"
        Expression = { $_.Config.Product.Version }
    }
    $BuildExp = @{
        Name = "Build"
        Expression = { $_.Config.Product.Build }
    }
    $ApiVersionExp = @{
        Name = "ApiVersion"
        Expression = { $_.Config.Product.ApiVersion }
    }
}
Process {
    $InputTypeName = $_.GetType().Name
    if ( $InputTypeName -eq "VMHostImpl" ) {
        $_ | Get-View | Select-Object Name, $ProductNameExp, $VersionExp, $BuildExp,
            $ApiVersionExp
    }
    if ( $InputTypeName -eq "HostSystem" ) {
        $_ | Select-Object Name, $ProductNameExp, $VersionExp, $BuildExp, $ApiVersionExp
    }
}