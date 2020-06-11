//
// Data for dusts are available from dati.arpae.it in two forms:
// 1. as a realtime flow (queryurl = """https://dati.arpae.it/api/action/datastore_search_sql?sql=SELECT * from "a1c46cfe-46e5-44b4-9231-7d9260a38e68" WHERE station_id=%s""" % station_id)
// 2. as historical csv files from a google drive account (https://drive.google.com/drive/folders/0B-owdnU_9_lpei1wbTBpS3RyTW8)
//

#r@"..\packages\Newtonsoft.Json.9.0.1\lib\net45\Newtonsoft.Json.dll"
#r@"..\packages\Google.Apis.1.21.0\lib\net45\Google.Apis.dll"
#r@"..\packages\Google.Apis.1.21.0\lib\net45\Google.Apis.PlatformServices.dll"
#r@"..\packages\Google.Apis.Core.1.21.0\lib\net45\Google.Apis.Core.dll"
#r@"..\packages\Google.Apis.Auth.1.21.0\lib\net45\Google.Apis.Auth.dll"
#r@"..\packages\Google.Apis.Drive.v3.1.21.0.768\lib\net45\Google.Apis.Drive.v3.dll"
#r@"..\packages\Google.Apis.Auth.1.21.0\lib\net45\Google.Apis.Auth.PlatformServices.dll"

open Google.Apis.Auth.OAuth2
open Google.Apis.Drive.v3
open Google.Apis.Drive.v3.Data
open Google.Apis.Services
open Google.Apis.Util.Store
open System
open System.Collections.Generic
open System.IO
open System.Linq
open System.Text
open System.Threading
open System.Threading.Tasks

let pc = Path.Combine
let folderid = "0B-owdnU_9_lpei1wbTBpS3RyTW8"
let secrets = GoogleClientSecrets.Load(File.OpenRead(pc([|__SOURCE_DIRECTORY__;"client_secret.json"|]))).Secrets
let credential = 
    GoogleWebAuthorizationBroker.AuthorizeAsync(secrets,[DriveService.Scope.DriveReadonly],"user",CancellationToken.None).Result

let init = BaseClientService.Initializer()
init.HttpClientInitializer <- credential
init.ApplicationName <- "DustDustDust"
let service = new DriveService(init)
let req = service.Files.List()
let rec iterPages ptoken strcontent acc =
    req.Q <- "'0B-owdnU_9_lpei1wbTBpS3RyTW8' in parents and name contains 'storico'"
    req.PageToken <- ptoken
    let res = req.Execute()
    let entries =
        seq {
            for entry in res.Files do
                if entry.Name.Contains(strcontent) then
                    yield entry
            } |> List.ofSeq
    let tkn = res.NextPageToken
    if tkn <> null then
        iterPages res.NextPageToken strcontent (entries @ acc)
    else
        entries @ acc
for statid in ["2000003";"2000004"] do // 2000232
    printfn "-> statid %s" statid
    let tmp = iterPages null statid []
    for entry in tmp do
        printfn "-> downloading %s" entry.Name
        let req = service.Files.Get(entry.Id)
        use ofile = File.OpenWrite(pc([|__SOURCE_DIRECTORY__;sprintf "data/%s" entry.Name|]))
        req.Download(ofile)
        ofile.Flush()
        ofile.Close()