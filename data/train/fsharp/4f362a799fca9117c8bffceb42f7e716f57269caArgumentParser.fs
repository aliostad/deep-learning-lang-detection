namespace Bootstrap.CommandLine

open System

module ArgumentParser = 
    open Tokenizer

    type Switch<'ctx> = { 
        Names: string array; 
        HelpText: string option; 
        Handler: 'ctx -> 'ctx }

    type Option<'ctx> = { 
        Names: string array; 
        HelpText: string option; 
        Handler: 'ctx -> string -> 'ctx }

    type Config<'ctx> = { 
        DefaultHandler: ('ctx -> string -> 'ctx) option; 
        Switches: Switch<'ctx> list; 
        Options: Option<'ctx> list }

    let private UnhandledArgument arg = 
        ArgumentException (sprintf "Unhandled argument '%s'" arg) |> raise
    let private UnrecognizedOption name = 
        ArgumentException (sprintf "Unrecognized option '%s'" name) |> raise
    let private UnrecognizedSwitch name = 
        ArgumentException (sprintf "Unrecognized switch '%s'" name) |> raise
    let private MissingOptionValue name = 
        ArgumentException (sprintf "Option '%s' expect value" name) |> raise

    let private createSwitch names helpText handler = 
        { Switch.Names = splitNames names; HelpText = optionString helpText; Handler = handler }

    let private createOption names helpText handler =
        { Option.Names = splitNames names; HelpText = optionString helpText; Handler = handler }

    let create () =
        { DefaultHandler = None; Switches = []; Options = [] }

    let onString handler configuration =
        { configuration with DefaultHandler = Some handler }

    let onSwitch names helpText handler configuration =
        let head = createSwitch names helpText handler
        { configuration with Switches = head :: configuration.Switches }

    let onOption names helpText handler configuration = 
        let head = createOption names helpText handler
        { configuration with Options = head :: configuration.Options }

    let parse ctx args configuration =
        let buildNameMap func list =
            list
            |> Seq.map func
            |> Seq.collect (fun (l, f) -> l |> Seq.map (fun n -> (n, f)))
            |> Map.ofSeq

        let switchMap = configuration.Switches |> buildNameMap (fun s -> (s.Names, s.Handler))
        let optionMap = configuration.Options |> buildNameMap (fun s -> (s.Names, s.Handler))
        let defaultHandler = configuration.DefaultHandler

        let isSwitch name = switchMap |> Map.containsKey name
        let isOption name = optionMap |> Map.containsKey name
        let hasDefaultHandler = defaultHandler.IsSome

        let handleString ctx arg =
            match defaultHandler with 
            | Some handler -> handler ctx arg 
            | _ -> UnhandledArgument arg
        let handleOption ctx (name, value) =
            match optionMap |> Map.tryFind name with 
            | Some handler -> handler ctx value 
            | _ -> UnrecognizedOption name
        let handleSwitch ctx name =
            match switchMap |> Map.tryFind name with 
            | Some handler -> handler ctx 
            | _ -> UnrecognizedSwitch name

        let rec loop ctx args =
            match args with
            | [] -> ctx
            | OptionToken p :: tail -> 
                loop (handleOption ctx p) tail
            | SwitchToken n :: StringToken v :: tail when isOption n -> 
                loop (handleOption ctx (n, v)) tail
            | SwitchToken n :: tail when isSwitch n -> 
                loop (handleSwitch ctx n) tail
            | StringToken v :: tail when hasDefaultHandler -> 
                loop (handleString ctx v) tail
            | SwitchToken n :: _ when isOption n -> MissingOptionValue n
            | SwitchToken n :: _ -> UnrecognizedSwitch n
            | StringToken v :: _ -> UnhandledArgument v

        args |> List.ofSeq |> loop ctx
