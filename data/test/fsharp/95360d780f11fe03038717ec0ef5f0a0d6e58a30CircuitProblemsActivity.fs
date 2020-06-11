
namespace thearch_android

open System
open System.Collections.Generic
open System.Linq
open System.Text

open Android.App
open Android.Content
open Android.OS
open Android.Runtime
open Android.Views
open Android.Widget

open thearch_api_wrapper

[<Activity (Label = "Circuit Problems", Theme = "@style/Theme.GlobalTheme")>]
type CircuitProblemsActivity() =
  inherit ListActivity()

  let mutable items: (int*string*string) list = []
  override x.OnCreate(bundle) =
    base.OnCreate (bundle)
    items <- api.sectorData 
        |> List.sortBy (fun s -> snd s |> Map.find api.k_sortOrder |> int)
        |> List.map(fun s ->  
            (fst s, Map.find api.k_sectorName <| snd s, Map.find api.k_sectorInfoShort <| snd s))

    x.ListAdapter <- new SectorsAdapter(x, items.ToList())
    x.SetContentView(Resource_Layout.CircuitProblems)

  override x.OnListItemClick(listView, view, position, id) =
    let sectorId,_,_ = items.[position]
    let intent = new Intent(x, typedefof<RoutesActivity>) in
    intent.PutExtra("sector_id", sectorId) |> ignore
    x.StartActivity intent