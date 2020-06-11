#r "../packages/Suave/lib/net40/Suave.dll"
#load "helloHandler.fsx"

open Suave
open Suave.Filters
open Suave.Operators
open Suave.Successful

//let app = Successful.OK "boom boom boom"
let app = 
    choose
        [GET >=> choose
            [path "/hello" >=> request HelloHandler.helloHandler
             path "/bye" >=> OK "Bye GET"]
         GET >=> choose
            [path "/date" >=> OK (System.DateTime.Now.ToShortDateString())
             path "/time" >=> OK (System.DateTime.Now.ToShortTimeString())]
         POST >=> choose
            [path "/hello" >=> OK "Hello POST"
             path "/bye" >=> OK "Bye POST"]
         GET >=> choose
            [path "/" >=> OK "Default GET"
             path "/" >=> OK "Default POST"]
         Authentication.authenticateBasic
            (fun (usr, pwd) -> usr = "test" && pwd = "12345")
            (choose
                [GET  >=> path "/basicauth" >=> OK "Welcome GET user"
                 POST >=> path "/basicauth" >=> OK "Welcome POST user"])]
