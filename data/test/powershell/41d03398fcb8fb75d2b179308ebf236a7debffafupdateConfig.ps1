Param([string] $azureSettingsFile, [string] $settingsConfig, [string] $node)

[xml]$settings = Get-Content $settingsConfig;
[xml]$configuration = Get-Content $azureSettingsFile;

$elements = $settings.SelectNodes("$node").ChildNodes

for ($i=0; $i -le ($elements.Count-1) ; $i++)
{
    if ($elements[$i].key -ne $null) {
        if ($configuration.configuration.clientSettings[$elements[$i].key]."#text" -ne $null){
            $value = $configuration.configuration.clientSettings[$elements[$i].key]."#text";
            $elements[$i].value = $value;
        }
    }
}

$settings.Save($settingsConfig);