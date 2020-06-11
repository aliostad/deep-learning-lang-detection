// Learn more about F# at http://fsharp.org

open System
open System.Diagnostics
open System.Runtime.Loader
open System.IO

// System.AppDomain.CurrentDomain.ProcessExit.Add (fun _ -> killProcessAndServer p)

AssemblyLoadContext.Default.add_Unloading(fun x -> 
    printfn "Unload %A" <| x.GetType()
    File.WriteAllText("Hello.txt", "Hello, world!")
)

[<EntryPoint>]
let main argv =
    printfn "Hello World from F#!"
    while Console.ReadLine() <> "q" do
        printf ">> "
    0 // return an integer exit code
