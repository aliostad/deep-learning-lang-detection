// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.

open Microsoft.Owin.Hosting

[<EntryPoint>]
let main argv = 
    let schedulingApiAddress = "http://localhost:8050"
    let managingApiAddress = "http://localhost:8051"

    try 
        printfn "Starting web server at [%s]" schedulingApiAddress
        let schedulingApi = WebApp.Start<Tododo.Scheduling.Api.OwinHost.Startup>(new StartOptions(schedulingApiAddress))

        printfn "Starting web server at [%s]" managingApiAddress
        let managingApi = WebApp.Start<Tododo.Managing.Api.OwinHost.Startup>(new StartOptions(managingApiAddress))
        ()
    with e -> 
        printfn "Error while starting web server\n%A" e
        reraise()

    printfn "Server started"

    System.Console.ReadLine() |> ignore
    1
