
namespace thearch_android
open Android.App
open Android.OS

open thearch_api_wrapper

[<Activity (Label = "The Arch Climbing Wall",
    MainLauncher = true, 
    Theme = "@style/Theme.Splash", 
    NoHistory = true)>]
type SplashScreen() =
  inherit Activity()

  override x.OnResume() = 
    base.OnResume()
    async {
        //api.cragData |> ignore
        api.routeData |> ignore
        api.sectorData |> ignore
        x.RunOnUiThread(fun _ -> x.StartActivity(typedefof<CircuitProblemsActivity>))
    } |> Async.Start

  override x.OnCreate(bundle) =
    base.OnCreate (bundle)
    ProgressDialog.Show(x, "Loading", "Please wait...", true)  |> ignore
