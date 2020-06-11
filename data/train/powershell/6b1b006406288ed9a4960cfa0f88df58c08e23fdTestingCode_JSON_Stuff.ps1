function Try-Stuff
{

    $name = "Dev_Four API - IAD-WEB-01"
    $category = "Development_IIS"
    $hostName = "IAD-WEB-01"
    $pathExpression = "\\IAD-WEB-01\c$\\Web\dev_three\Logs\API\*.txt"
    $sourceType = "LocalFile"

$JSONBuildSource = [ordered]@{source = @{name=$name;
                                category=$category;
                                hostName=$hostName;
                                pathExpression=$pathExpression;
                                sourceType=$sourceType
                                filters = @{filterType="Exclude";
                                            name="Remove CheckForUpdates";
                                            regexp=".*CheckForUpdates.*"},
                                          @{filterType= "Exclude";
                                            name="Remove Akami Check";
                                            regexp=".*akamai.html.*"}

                                }
                                
                                
                                
                                } | ConvertTo-Json -Depth 30


$JSONNewSource = @{source = @{name="Dev_Three API - IAD-WEB-01";
                                category="Development_IIS";
                                hostName="IAD-WEB-01";
                                pathExpression="\\IAD-WEB-01\c$\\Web\dev_three\Logs\API\*.txt";
                                sourceType="LocalFile"}} | ConvertTo-Json

}

$JSON = @{source = @{name='test'},@{name='test2'}} | ConvertTo-Json

$Filters = 'regexp:.*CheckForUpdates.*,filtertype:Exclude,name:Remove CheckForUpdates;regexp:.*akamai.html.*,filtertype:Exclude,name:Remove Akami Check'.split(';')

Foreach($filter in $filters)
{
   #write-host $Filter    
   $TotalFilter += $Filter
   
}
write-host $TotalFilter