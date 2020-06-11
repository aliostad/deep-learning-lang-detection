namespace FRest.Tests

open System

open Xunit

open FRest
open FRest.Contracts

/// IMPORTANT: you will have to run this with local admin rights (rebinding of htpp://localhost)
module ``Integrationstests using SelfHosting and Api`` =

    let testPort = 8084
    let waitMs = if System.Diagnostics.Debugger.IsAttached then 5 * 60 * 1000 else 1000
    
    let startService =
        let portLock = new System.Threading.Mutex ()
        fun handler ->
            if not <| portLock.WaitOne(5000) then failwith "port is blocked" else
            let disp = Server.SelfHosting.hostLocalService handler testPort
            { new IDisposable with
                member __.Dispose() =
                    disp.Dispose ()
                    portLock.ReleaseMutex ()
            }

    let getApi () =
        Client.Api.createApi <| sprintf "http://localhost:%d" testPort

    [<Fact>]
    let ``Echo returns the message``() =
        use service = startService Handler.initial
        let api = getApi ()
            
        let response = 
            Async.RunSynchronously (
                api.echo "hello", 
                10000)

        Assert.Equal ("hello", response.message)