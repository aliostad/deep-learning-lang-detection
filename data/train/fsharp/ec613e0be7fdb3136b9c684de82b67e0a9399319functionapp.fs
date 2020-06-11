namespace CamdenTown

open System
open System.IO
open System.Diagnostics
open System.Threading
open Microsoft.Azure.WebJobs
open Microsoft.Azure.WebJobs.Host
open Microsoft.WindowsAzure.Storage
open CamdenTown.Rest
open CamdenTown.Storage
open CamdenTown.Manage
open CamdenTown.Checker
open CamdenTown.Compile

module FunctionApp =

  type TraceLocal(level: TraceLevel) =
    inherit TraceWriter(level)

    override __.Trace (traceEvent: TraceEvent) =
      let level = traceEvent.Level.ToString()
      let timestamp = traceEvent.Timestamp.ToShortTimeString()

      printfn "%s [%s] %s: %s"
        level
        timestamp
        traceEvent.Source
        traceEvent.Message

  type AzureFunctionApp
    (
      subId: string,
      tenantId: string,
      clientId: string,
      clientSecret: string,
      group: string,
      storage: string,
      replication: string,
      planName: string,
      plan: string,
      location: string,
      capacity: int,
      name: string,
      ?dir: string
    ) =

    let attempt resp =
      resp
      |> Async.RunSynchronously
      |> CheckResponse

    let result resp =
      resp
      |> Async.RunSynchronously
      |> AsyncChoice

    let rec retry n timeout f x =
      try
        f x
      with e ->
        if n > 0 then
          Async.Sleep timeout |> Async.RunSynchronously
          retry (n - 1) timeout f x
        else
          raise e

    let retryAttempt x = retry 5 1000 attempt x
    let retryResult x = retry 5 1000 result x

    let buildDir = defaultArg dir "output"
    let token =
      GetAuth tenantId clientId clientSecret
      |> retryResult

    do
      try Directory.Delete(buildDir, true) with _ -> ()

      CreateResourceGroup subId token group location
      |> retryAttempt
      CreateStorageAccount subId token group storage location replication
      |> retryAttempt
      CreateAppServicePlan subId token group planName plan location capacity
      |> retryAttempt
      CreateFunctionApp subId token group planName name location
      |> retryAttempt

    let kuduToken =
      KuduAuth subId token group name
      |> retryResult

    let storageKeys =
      StorageAccountKeys subId token group storage
      |> retryResult

    let connectionString =
      sprintf "DefaultEndpointsProtocol=https;AccountName=%s;AccountKey=%s"
        storage
        storageKeys.Head
    let storageAccount = CloudStorageAccount.Parse(connectionString)
    let queueClient = storageAccount.CreateCloudQueueClient()
    let blobClient = storageAccount.CreateCloudBlobClient()

    do
      attempt (
        SetAppSettings subId token group name
          [ "AzureWebJobsDashboard", connectionString
            "AzureWebJobsStorage", connectionString
            "FUNCTIONS_EXTENSION_VERSION", "~1"
            "AZUREJOBS_EXTENSION_VERSION", "beta"
            "WEBSITE_NODE_DEFAULT_VERSION", "4.1.2" ]
        )

    member __.Queue<'T, 'U> () =
      let ty = typeof<'T>
      let qt = NamedType "Queue" ty
      if qt.IsSome then
        let ty2 = typeof<'U>
        if qt.Value = ty2 then
          let name = ty.Name.ToLowerInvariant()
          let q = queueClient.GetQueueReference(name)
          q.CreateIfNotExists() |> ignore
          LiveQueue<'U>(q)
        else
          failwithf "%s is not a Queue of %s" ty.Name ty2.Name
      else
        failwith "Not a Queue"

    member __.Container<'T, 'U> () =
      let ty = typeof<'T>
      let bt = NamedType "Blob" ty
      if bt.IsSome then
        let ty2 = typeof<'U>
        if bt.Value = ty2 then
          let name = ty.Name.ToLowerInvariant()
          let c = blobClient.GetContainerReference(name)
          c.CreateIfNotExists() |> ignore
          LiveContainer<'U>(c)
        else
          failwithf "%s is not a Blob of %s" ty.Name ty2.Name
      else
        failwith "Not a Blob"

    member __.Deploy
      ( [<ReflectedDefinition(true)>] xs: Quotations.Expr<obj list>
        ) =
      // Restart the function app so that loaded DLLs don't prevent deletion
      match StopFunctionApp subId token group name |> Async.RunSynchronously with
      | OK _ ->
        let r = Compiler.CompileExpr(buildDir, xs)
        let ok = r |> List.forall (fun (_, _, _, errors) -> errors.IsEmpty)
        let resp =
          r
          |> List.map (fun (_, func, path, errors) ->
            if errors.IsEmpty then
              if ok then
                DeleteFunction subId token group name func
                |> Async.RunSynchronously
                |> ignore

                let target = sprintf "site/wwwroot/%s" func
                match
                  KuduVfsPutDir kuduToken name target path
                  |> Async.RunSynchronously
                  with
                | OK _ -> OK func
                | Error(reason, text) ->
                  Error((sprintf "%s: %s" func reason), text)
              else
                OK func
            else
              Error(func, String.concat "\n" errors)
          )
        (StartFunctionApp subId token group name |> Async.RunSynchronously)::resp
      | x -> [x]

    member __.Undeploy
      ( [<ReflectedDefinition(true)>] xs: Quotations.Expr<obj list>
        ) =
      // Restart the function app so that loaded DLLs don't prevent deletion
      match StopFunctionApp subId token group name |> Async.RunSynchronously with
      | OK _ ->
        let resp =
          Compiler.GetMI xs
          |> List.map (
            (fun (_, mi) -> mi.Name) >>
            (fun func ->
              DeleteFunction subId token group name func
              |> Async.RunSynchronously
              )
            )
        (StartFunctionApp subId token group name |> Async.RunSynchronously)::resp
      | x -> [x]

    member __.Start () =
      StartFunctionApp subId token group name |> Async.RunSynchronously

    member __.Stop () =
      StopFunctionApp subId token group name |> Async.RunSynchronously

    member __.Restart () =
      RestartFunctionApp subId token group name |> Async.RunSynchronously

    member __.Delete () =
      DeleteFunctionApp subId token group name |> Async.RunSynchronously

    member __.Log (f: string -> unit) =
      let cancel = new CancellationTokenSource()
      let loop =
        async {
          use! c = Async.OnCancel(fun () -> f "Log stopped")
          let! token = Async.CancellationToken
          let! stream = KuduAppLog kuduToken name

          while not token.IsCancellationRequested do
            let line = stream.ReadLine()
            if not token.IsCancellationRequested then
              f line
        }
      Async.Start(loop, cancel.Token)
      cancel
