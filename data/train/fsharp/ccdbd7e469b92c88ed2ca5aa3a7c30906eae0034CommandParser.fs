namespace Bootstrap.CommandLine

open System
   
module CommandParser = 
    open Tokenizer

    let MissingDefaultHandler () =
        ArgumentException ("The default handler is missing") |> raise

    type Command<'ctx> = { 
        Name: string; 
        HelpText: string option; 
        Handler: 'ctx -> string seq -> 'ctx }

    type Config<'ctx> = { 
        DefaultHandler: ('ctx -> string seq -> 'ctx) option; 
        Commands: Command<'ctx> list }

    let internal createCommand name helpText handler =
        { Name = name; HelpText = optionString helpText; Handler = handler }

    let create () =
        { DefaultHandler = None; Commands = [] }

    let onDefaultCommand handler configuration =
        { configuration with DefaultHandler = Some handler }

    let onCommand name helpText handler configuration = 
        let head = createCommand name helpText handler
        { configuration with Commands = head :: configuration.Commands }

    let parse ctx args configuration =
        let commandMap = configuration.Commands |> Seq.map (fun c -> (c.Name, c.Handler)) |> Map.ofSeq
        let defaultHandler = configuration.DefaultHandler
        let isCommand name = commandMap |> Map.containsKey name
        let handleAny ctx handler tail =
            match handler with
                | Some f -> f ctx tail
                | _ -> MissingDefaultHandler ()
        let handleCommand ctx name tail = handleAny ctx (commandMap |> Map.tryFind name) tail
        let handleDefault ctx tail = handleAny ctx defaultHandler tail
        let parse ctx args =
            match args with
                | StringToken n :: tail when isCommand n -> handleCommand ctx n tail
                | _ -> handleDefault ctx args
        args |> List.ofSeq |> parse ctx
