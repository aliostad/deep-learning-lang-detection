open mForex.API
open mForex.API.FSharp
open System.Threading
open System

type Agent<'a> = MailboxProcessor<'a>

type Message =
    | Start of Credentials: int * string
    | Trade of Order: string * TradeCommand * float


type Api() =        
    
    let client = APIClient(ServerType.Demo)
    
    let connect login password = async {
            do! client.Connect()
            let! loggedIn = client.Login(login, password)
            return loggedIn
        }
    
    let trade symbol command volume = async {
            let! res = client.Trade.OpenOrder(symbol, command, 0.0, 0.0, 0.0, volume)
            return res
        }

    let agent = Agent.Start(fun a -> async {
            while true do
                let! msg = a.Receive()
                
                match msg with
                | Start (login,password)  ->
                    let! r  = (connect login password)
                    printfn "Logged in: %O" r.LoginStatus

                    let! reg = client.RequestTickRegistration("EURUSD", RegistrationAction.Register)
                    ()
                
                | Trade (symbol, command, volume) -> 
                    let! r = (trade symbol command volume)
                    printfn "Trade successful. order id: %i" r.Order
        })

    
    do agent.Error.Add(fun e -> printfn "Fatal error occured: %O" e)

    member this.Connect(login, password) =
        agent.Post(Start (login, password)) 

    member this.Stream symbol =
        client.Ticks.Add(fun p -> 
            p |> Seq.filter (fun x -> x.Symbol = symbol)
              |> Seq.iter (fun x -> printfn "%A %.5f/%.5f %A" x.Symbol x.Bid x.Ask x.Time))
    
    member this.Trade(symbol, command, volume) =
        agent.Post(Trade (symbol, command, volume) )
        

[<EntryPoint>]
let main argv =     
    let login = 0                   // Enter your login here    
    let password = "password"       // Enter your password here
    
    let symbol = "EURUSD"           // Enter instrument to be bought
    let volume = 0.1                // Select volume
    let command = TradeCommand.Buy      
    
    let api = Api()
    
    api.Connect(login, password)    
    api.Stream symbol
    
    api.Trade(symbol, command, volume)
    
    Console.ReadKey() |> ignore
    0