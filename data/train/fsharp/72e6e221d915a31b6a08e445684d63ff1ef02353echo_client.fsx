// TODO: switch libzmq.dll to use relative paths!!!

// NOTE:  changing the current directory is the easiest way to ensure
//        the (native) libzmq.dll is available for use in the REPL 
System.Environment.CurrentDirectory <- 
   @"C:\working\projects\ThirdParty\fszmq\deploy"
#I @"C:\working\projects\ThirdParty\fszmq\deploy"
#r "fszmq.dll"
open fszmq
open fszmq.Context
open fszmq.Polling
open fszmq.Socket

type date = System.DateTime

let encode (s:string) = System.Text.Encoding.ASCII.GetBytes(s)
let recvAll' = recvAll >> Array.map System.Text.Encoding.ASCII.GetString
let scanfn = System.Console.ReadLine
let sleep = int >> System.Threading.Thread.Sleep

let request = [| "TITC01"B; "Echo"B; "2"B; "1024"B |]
let update  = [| "TITC01"B; "Echo"B; "3"B          |]

let main () =
  use context = new Context(1)
  use client  = context |> req
  "tcp://nyc-ws093:5555" |> connect client

  let rec getUpdate query = 
    printf "Waiting for result... "
    query |> sendAll client
    match recvAll' client with
    | [| _; _; _; _; status; _ |]
    | [| _; _; _; _; status;   |] ->  printfn "%s [%A]" status date.Now
                                      sleep 2000 // pause for effect
                                      match status with
                                      | "300" -> getUpdate query
                                      | _     -> printfn "good-bye."
    | x                           ->  printfn "Unable to process results."
                                      printfn "got: %A [%A]" x date.Now

  printf "Press <return> to send message"
  scanfn() |> ignore
  request |> sendAll client
  
  let ticket = client |> recvAll'
  ticket |> Array.iter (printfn "%s")
  match ticket with
  | [| _; _; _; "200"; uuid |] ->  

      printfn "[%A] Job created with id: %s" date.Now uuid
      let query = [| encode uuid |] |> Array.append update
      sleep 2000 // give the broker a chance to arrange things
      getUpdate query
  
  | x -> printfn "Unable to create job."
         printfn "got: %A [%A]" x date.Now

main()
