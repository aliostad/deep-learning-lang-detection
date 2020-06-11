namespace fxExpense

open Android.App
open Android.Content
open Android.OS
open Android.Runtime
open Android.Views
open Android.Widget
open Android.Gms.Common.Apis
open Android.Gms.Drive
open Android.Gms.Common
open Android.Gms.Drive.Query
open Android.Util

//type GDriveCallbacks (context: Activity) =
//    inherit Java.Lang.Object ()    
//    interface Android.Runtime.IJavaObject with 
//        member this.Handle = base.Handle
//    interface GoogleApiClient.IOnConnectionFailedListener with
//        member this.OnConnectionFailed result =
//            match result.HasResolution with
//            | true -> 
//                try result.StartResolutionForResult(context, 101)
//                with | :? IntentSender.SendIntentException as ex -> Log.Error("[MainActivity]", ex.Message) |> ignore
//            | false -> GooglePlayServicesUtil.GetErrorDialog(result.ErrorCode, context, 0).Show()
//    interface GoogleApiClient.IConnectionCallbacks with
//        member this.OnConnectionSuspended cause = Log.Error("[MainActivity]", sprintf "Connection suspended %A" cause) |> ignore
//        member this.OnConnected bundle = Log.Error("[MainActivity]", "Connected") |> ignore    
    
[<Activity (Label = "MainActivity", MainLauncher = true)>]
type MainActivity () =
    inherit Activity ()      

    let mutable googleApi: GoogleApiClient option = Option.None

    let workWithGoogleApi someCallback =
        match googleApi with
        | Some a -> someCallback a            
        | None -> Log.Info("[MainActivity]", "Google api not retrived") |> ignore

    override this.OnCreate (bundle) =
        base.OnCreate (bundle)
        this.SetContentView (Resource_Layout.Main)

        //let driveCallbacks = new GDriveCallbacks(this)            
        let googleApiClient = new GoogleApiClient.Builder(this)
        googleApi <- googleApiClient.AddApi(DriveClass.API)
                    .AddScope(DriveClass.ScopeFile)
                    .AddScope(DriveClass.ScopeAppfolder)
                    .UseDefaultAccount()
                    //.AddConnectionCallbacks(driveCallbacks :> GoogleApiClient.IConnectionCallbacks)
                    //.AddOnConnectionFailedListener(driveCallbacks :> GoogleApiClient.IOnConnectionFailedListener)
                    .Build () |> Some                    

        let button = this.FindViewById<Button>(Resource_Id.MyButton)
        button.Click.Add (fun args -> 
            button.Text <- sprintf "Clicked!"      
            
            let someCallback api = 
                let rootFolder = DriveClass.DriveApi.GetRootFolder(api)
                
                let metaBuilder = new MetadataChangeSet.Builder()             
                let meta = metaBuilder.SetMimeType("text/plain").SetTitle(button.Text).Build() 
                rootFolder.CreateFile(api, meta, null).AsAsync<IDriveFolderDriveFileResult>() 
                |> Async.AwaitTask |> ignore

            workWithGoogleApi someCallback           
        )

    override this.OnStart () =
        base.OnStart ()
        workWithGoogleApi (fun api -> api.Connect())

    override this.OnActivityResult (requestCode, resultCode, data) =
       base.OnActivityResult(requestCode, resultCode, data)
       match (requestCode, resultCode) with
       | (101, Result.Ok) -> workWithGoogleApi (fun api -> api.Connect())
       | _ -> Log.Info("[MainActivity]", sprintf "RequestCode is %A" requestCode) |> ignore
