module internal AzureRmRest.Uri

open System

let ResourceGroupUri subscriptionId name =
  sprintf
    "https://management.azure.com/subscriptions/%s/resourceGroups/%s?api-version=2015-11-01"
    subscriptionId name
  |> Uri

let AppServicePlanUri subscriptionId resourceGroupName name =
  sprintf
    "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/serverfarms/%s?api-version=2015-08-01"
    subscriptionId resourceGroupName name
  |> Uri

let AppServiceUri subscriptionId resourceGroupName name =
  sprintf
    "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s?api-version=2015-08-01"
    subscriptionId resourceGroupName name
  |> Uri

let VfsUri name path =
  sprintf
    "https://%s.scm.azurewebsites.net/api/vfs/%s/"
    name
    path
  |> Uri

let SqlServerUri subscriptionId resourceGroupName serverName = 
  sprintf 
    "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Sql/servers/%s?api-version=2014-04-01-preview"
    subscriptionId
    resourceGroupName
    serverName
  |> Uri

let SqlDatabaseUri subscriptionId resourceGroupName serverName databaseName = 
  sprintf 
    "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Sql/servers/%s/databases/%s?api-version=2014-04-01-preview"
    subscriptionId
    resourceGroupName
    serverName
    databaseName
  |> Uri

let AppSettings subscriptionId resourceGroupName appServiceName = 
  sprintf
    "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s/config/appsettings?api-version=2015-08-01"
    subscriptionId
    resourceGroupName
    appServiceName
  |> Uri

let PublishCredentials subscriptionId resourceGroupName appServiceName = 
  sprintf
    "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s/config/publishingcredentials/list?api-version=2015-08-01"
    subscriptionId
    resourceGroupName
    appServiceName
  |> Uri

let ApplicationInsightsUri subscriptionId resourceGroupname instanceName =
  sprintf 
    "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/microsoft.insights/components/%s?api-version=2015-05-01"
    subscriptionId
    resourceGroupname
    instanceName
  |> Uri