module YC.Bio.GoogleAPIQueries

open System.IO
open System.Threading
open System.Collections.Generic

open Google.Apis.Auth.OAuth2
open Google.Apis.Sheets.v4
open Google.Apis.Sheets.v4.Data
open Google.Apis.Services
open Google.Apis.Util.Store

let googleAuth appName =
    let scopes = [| SheetsService.Scope.Spreadsheets |]
    let credPath = Path.Combine(System.Environment.CurrentDirectory, 
                                "../.credentials/sheets.googleapis.com-dotnet-quickstart.json")
    use stream = new FileStream("client_secret.json", FileMode.Open, FileAccess.Read)
    let credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
                      GoogleClientSecrets.Load(stream).Secrets,
                      scopes,
                      "user",
                      CancellationToken.None,
                      new FileDataStore(credPath, true)).Result
    let baseService = new BaseClientService.Initializer()
    baseService.ApplicationName  <- appName
    baseService.HttpClientInitializer <- credential
    new SheetsService(baseService)

let update spreadsheetId range (service: SheetsService) (values: string[][]) =
    let requestValues = new List<IList<obj>>()
    for row in values do
        let requestRow = new List<obj>()
        for value in row do
            requestRow.Add(value)
        requestValues.Add(requestRow)
    let valueRange = new ValueRange()
    valueRange.Values <- requestValues
    let request = service.Spreadsheets.Values.Update(valueRange, spreadsheetId, range)
    request.ValueInputOption <- System.Nullable SpreadsheetsResource.ValuesResource.UpdateRequest.ValueInputOptionEnum.RAW
    request.Execute() |> ignore