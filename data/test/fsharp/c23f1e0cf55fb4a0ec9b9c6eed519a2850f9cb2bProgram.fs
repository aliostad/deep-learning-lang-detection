// Learn more about F# at http://fsharp.org
namespace CLI

open System
open Microsoft.Extensions.CommandLineUtils
open CLI.Utils

module Program =
    let isLive = Env.varDefault "ENV" "development" = "production"

    /// <summary>
    /// Takes an F# function and turns it into an Action<CommandLineApplication> which can be used to create a CLI command.
    /// </summary>
    let createAction command = Action<CommandLineApplication> command

    let configureLoginCommand (config: CommandLineApplication) =
        config.OnExecute (fun () ->
            printfn "Todo: send the user to a shopify oauth connection page."
            0
        )

    /// <summary>
    /// Parent command for listing Shop information.
    /// </summary>
    let configureShopCommand (config: CommandLineApplication) =
        config.OnExecute (fun () -> 
            printfn "Todo: print Shop information to the command line."
            0
        )

    let configureOrderCommand (config: CommandLineApplication) =
        config.OnExecute (fun () ->
            printfn "Todo: print Order information to the command line."
            0
        ) 
        
    let configureCustomerCommand (config: CommandLineApplication) =
        config.OnExecute (fun () ->
            printfn "Todo: print Customer information to the command line."
            0
        )

    [<EntryPoint>]
    let main argv =
        let app = CommandLineApplication false
        app.Name <- "shopify"
        app.FullName <- "Shopify Store CLI: Manage your Shopify store from the command line."
        app.Description <- "Manage your Shopify store from the command line."
        app.HelpOption "-h|--help" |> ignore
        
        let shop = 
            app.Command("shop", createAction configureShopCommand, false)
        let order = 
            app.Command("order", createAction configureOrderCommand, false)
        let customer =
            app.Command("customer", createAction configureCustomerCommand, false) 
        let customerAlias = 
            app.Command("cust", createAction configureCustomerCommand, false)    
        let login = 
            app.Command("login", createAction configureLoginCommand, false)                           

        app.OnExecute (fun () ->
            app.ShowHelp ()

            0
        )        

        let result = app.Execute argv 

        result // return an integer exit code
