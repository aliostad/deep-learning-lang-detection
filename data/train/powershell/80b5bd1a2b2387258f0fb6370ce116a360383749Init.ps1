param($installPath, $toolsPath, $package, $project)

$localAppData = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::LocalApplicationData);
$modulesPath = $localAppData+"\Soneta\Modules.xml"
$propsFile = $toolsPath+"\..\build\Soneta_enova-ReferencePaths.props"

$xslt = New-Object System.Xml.Xsl.XslCompiledTransform;
$xslt.Load($toolsPath+"\modules-to-props.xsl");
$xslt.Transform($modulesPath, $propsFile);

Write-Host [Soneta enova ReferencePath resolver]: $modulesPath has been transformed.