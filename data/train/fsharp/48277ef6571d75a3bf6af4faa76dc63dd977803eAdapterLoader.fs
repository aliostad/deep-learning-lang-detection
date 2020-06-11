module R4nd0mApps.XTestPlatform.Api.AdapterLoader

open System
open System.IO
open System.Reflection

let private invokeAPI<'T> adapterPaths apiName packagesPath = 
    Assembly.GetExecutingAssembly().CodeBase
    |> Uri
    |> fun x -> x.LocalPath
    |> Path.GetDirectoryName
    |> fun x -> adapterPaths |> Seq.map (Prelude.tuple2 x)
    |> Seq.map (Path.Combine >> Assembly.LoadFrom)
    |> Seq.collect (fun a -> a.GetTypes())
    |> Seq.choose (fun x -> 
            if x.Name = "AdapterLoader" then Some x
            else Option.None)
    |> Seq.map 
           (fun t -> 
           t.GetMethod(apiName, BindingFlags.Public ||| BindingFlags.Static).Invoke(null, [| packagesPath |]) :?> seq<'T>)
    |> Seq.collect id

let LoadDiscoverersFromPath ap = invokeAPI<IXTestDiscoverer> ap "LoadDiscoverers"
let LoadExecutorsFromPath ap = invokeAPI<IXTestExecutor> ap "LoadExecutors"
let LoadDiscoverers x = LoadDiscoverersFromPath [ "Xtensions/VS/R4nd0mApps.XTestPlatform.VS.dll" ] x
let LoadExecutors x = LoadExecutorsFromPath [ "Xtensions/VS/R4nd0mApps.XTestPlatform.VS.dll" ] x
