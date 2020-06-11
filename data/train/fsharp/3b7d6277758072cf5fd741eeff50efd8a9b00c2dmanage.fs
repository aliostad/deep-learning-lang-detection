namespace CamdenTown

open System
open System.IO
open System.IO.Compression
open System.Net
open System.Net.Http
open System.Text
open Newtonsoft.Json
open Newtonsoft.Json.Linq
open CamdenTown.Rest

module Manage =

  let ResourceGroupUri subscriptionId name =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s?api-version=2015-11-01"
      subscriptionId name

  let StorageAccountUri subscriptionId rgName name =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Storage/storageAccounts/%s?api-version=2016-01-01"
      subscriptionId rgName name

  let AppServicePlanUri subscriptionId rgName name =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/serverfarms/%s?api-version=2015-08-01"
      subscriptionId rgName name

  let AppServiceUri subscriptionId rgName name =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s?api-version=2015-08-01"
      subscriptionId rgName name

  let VfsUri name path =
    sprintf
      "https://%s.scm.azurewebsites.net/api/vfs/%s/"
      name
      path

  let AsyncChoice choice =
    match choice with
    | Choice1Of2 x -> x
    | Choice2Of2 (OK(text)) ->
      failwith text
    | Choice2Of2 (Error(reason, text)) ->
      failwithf "%s: %s" reason text

  let CheckResponse response =
    match response with
    | OK _ -> ()
    | Error(reason, text) -> failwithf "%s: %s" reason text

  let GetAuth tenantId clientId clientSecret =
    async {
      use client = new HttpClient()
      let uri =
        sprintf
          "https://login.windows.net/%s/oauth2/token"
          tenantId

      let text =
        sprintf
          "resource=%s&client_id=%s&grant_type=client_credentials&client_secret=%s"
          (WebUtility.UrlEncode("https://management.core.windows.net/"))
          (WebUtility.UrlEncode(clientId))
          (WebUtility.UrlEncode(clientSecret))

      let content = new StringContent(text, Encoding.UTF8, "application/x-www-form-urlencoded")

      let! r =
        client.PostAsync(uri, content)
        |> Async.AwaitTask
        |> parseResponse

      match r with
      | OK text ->
        let json = JObject.Parse(text)
        let token = json.["access_token"].Value<string>()
        return Choice1Of2 (sprintf "Bearer %s" token)
      | err ->
        return Choice2Of2 err
    }

  let CreateResourceGroup subId token name location =
    ResourceGroupUri subId name
    |> put token (
      sprintf """
  {
    "location": "%s"
  }
  """
        location)
    |> parseResponse

  let DeleteResourceGroup subId token name =
    ResourceGroupUri subId name
    |> delete token
    |> parseResponse

  let CreateStorageAccount subId token group name location replication =
    StorageAccountUri subId group name
    |> put token (
      sprintf """
  {
    "location": "%s",
    "properties": {
      "encryption": {
        "services": {
          "blob": {
            "enabled": true
          }
        },
        "keySource": "Microsoft.Storage"
      }
    },
    "sku": {
      "name": "%s"
    },
    "kind": "Storage"
  }
  """
        location
        replication
      )
    |> parseResponse

  let DeleteStorageAccount subId token group name =
    StorageAccountUri subId group name
    |> delete token
    |> parseResponse

  let StorageAccountKeys subId token group name =
    async {
      let! r =
        sprintf
          "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Storage/storageAccounts/%s/listKeys?api-version=2016-01-01"
          subId group name
        |> post token ""
        |> parseResponse

      match r with
      | OK text ->
        let json = JObject.Parse(text)
        let keys = json.["keys"].Value<JArray>()
        let tokens =
          keys.Children()
          |> Seq.filter (fun key ->
            let prop = key.Value<JObject>()
            let perm = prop.["permissions"].Value<string>()
            String.Compare(perm, "full", StringComparison.OrdinalIgnoreCase) = 0
            )
          |> Seq.map (fun key ->
            let prop = key.Value<JObject>()
            prop.["value"].Value<string>()
            )
          |> List.ofSeq
        return Choice1Of2 tokens
      | err ->
        return Choice2Of2 err
    }

  let CreateAppServicePlan subId token group name plan location capacity =
    AppServicePlanUri subId group name
    |> put token (
      sprintf """
  {
    "location": "%s",
    "Sku": {
      "Name": "%s",
      "Capacity": %d
    }
  }
  """
        location
        plan
        capacity
      )
    |> parseResponse

  let DeleteAppServicePlan subId token group name =
    AppServicePlanUri subId group name
    |> delete token
    |> parseResponse

  let SetAppSettings subId token group name (settings: (string * string) list) =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s/config/appsettings?api-version=2015-08-01"
      subId
      group
      name
    |> put token (
      let props =
        settings
        |> List.map (fun (key, value) ->
          sprintf
            "%s: %s"
            (JsonConvert.ToString(key))
            (JsonConvert.ToString(value))
          )
        |> String.concat ",\n    "

      sprintf """
  {
    "properties": {
      %s
    }
  }
  """
        props
      )
    |> parseResponse

  let CreateFunctionApp subId token group plan name location =
    AppServiceUri subId group name
    |> put token (
      sprintf """
  {
    "kind": "functionapp",
    "location": "%s",
    "properties": { "serverFarmId": "%s" }
  }
  """
        location
        plan
      )
    |> parseResponse

  let StartFunctionApp subId token group name =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s/start?api-version=2015-08-01"
      subId group name
    |> post token ""
    |> parseResponse

  let StopFunctionApp subId token group name =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s/stop?api-version=2015-08-01"
      subId group name
    |> post token ""
    |> parseResponse

  let RestartFunctionApp subId token group name =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s/restart?api-version=2015-08-01"
      subId group name
    |> post token ""
    |> parseResponse

  let DeleteFunctionApp subId token group name =
    AppServiceUri subId group name
    |> delete token
    |> parseResponse

  let ListFunctions subId token group name =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s/functions?api-version=2015-08-01"
      subId group name
    |> get token
    |> parseResponse

  let DeleteFunction subId token group name func =
    sprintf
      "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s/functions/%s?api-version=2015-08-01"
      subId group name func
    |> delete token
    |> parseResponse

  type KuduAuth = {
    Token: string
    Name: string
  }

  let KuduAuth subId token group name =
    async {
      let! r =
        sprintf
          "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/sites/%s/config/publishingcredentials/list?api-version=2015-08-01"
          subId
          group
          name
        |> post token ""
        |> parseResponse

      match r with
      | OK text ->
        let json = JObject.Parse(text)
        let user = json.["properties"].["publishingUserName"].Value<string>()
        let pass = json.["properties"].["publishingPassword"].Value<string>()
        let bytes = Encoding.ASCII.GetBytes(sprintf "%s:%s" user pass)
        return Choice1Of2("Basic " + Convert.ToBase64String(bytes))
      | err ->
        return Choice2Of2 err
    }

  let KuduVersion token name =
    sprintf
      "https://%s.scm.azurewebsites.net/api/environment"
      name
    |> get token
    |> parseResponse

  let KuduVfsGet token name path =
    sprintf
      "https://%s.scm.azurewebsites.net/api/vfs/%s"
      name
      path
    |> get token
    |> parseResponse

  let KuduVfsLs token name path =
    VfsUri name path
    |> get token
    |> parseResponse

  let KuduVfsMkdir token name path =
    VfsUri name path
    |> put token ""
    |> parseResponse

  let KuduVfsPutDir token name target source =
    async {
      let zip = source + ".zip"
      if File.Exists(zip) then
        File.Delete(zip)
      ZipFile.CreateFromDirectory(source, zip)
      let! _ = KuduVfsMkdir token name target

      let uri =
        sprintf
          "https://%s.scm.azurewebsites.net/api/zip/%s"
          name
          target

      use client = makeClient token
      let data = File.ReadAllBytes(zip)
      File.Delete(zip)

      return!
        client.PutAsync(uri, new ByteArrayContent(data))
        |> Async.AwaitTask
        |> parseResponse
    }

  let KuduAppLog token name =
    async {
      let! resp =
        sprintf
          "https://%s.scm.azurewebsites.net/api/logstream/application"
          name
        |> getStream token

      if not resp.IsSuccessStatusCode then
        failwithf "Couldn't start log: %d %s"
          (int resp.StatusCode) resp.ReasonPhrase

      let! stream = resp.Content.ReadAsStreamAsync() |> Async.AwaitTask
      return new StreamReader(stream)
    }
