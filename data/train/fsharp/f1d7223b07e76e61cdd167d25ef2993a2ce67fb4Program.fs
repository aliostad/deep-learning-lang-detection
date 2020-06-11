module Program

open System
open FSharp.ConsoleApp

///Convert a function to a console application handler e.g. - returns 0 for success or 1 for errors.
let handler f = 
        fun args -> 
            try
                printfn ""
                f args
                0
            with
            | e -> 
                printfn "Error: %s" e.Message
                1

///Contains a handler that prints the application usage
module Usage =

    ///Prints the usage to the console
    let print () = 
        printfn "Usage:"
        printfn "  example <command> [--<flag> ...] [-<setting> value ...]"
        printfn ""
        printfn "Commands:"
        printfn "  echo -message <Text> [--upper]"
        printfn "  now [--mask <Mask>]"
        printfn "  indexOf -haystack <Text> -needle <Text>"

    ///A handler which prints the usage to the console
    let exec = 
        handler (fun _ ->
            print ()
        )

///Contains a handler that prints the current date/time
module Now = 
    
    ///The default date/time format mask
    let [<Literal>] DefaultMask = "yyyy-MM-dd HH:mm"

    ///The key for the format mask setting
    let [<Literal>] MaskKey = "mask"

    ///A handler which prints the current date/time to the console
    let exec = 
        handler (fun args ->
            
            let mask = 
                match (App.tryGetSetting MaskKey args) with
                | Some mask' -> mask'
                | _ -> DefaultMask

            Console.WriteLine (DateTime.Now.ToString mask)
        )

///Contains a handler that prints a given message
module Echo = 

    ///The key used for the message setting
    let [<Literal>] MessageKey = "message"

    ///The key used for the upper case flag
    let [<Literal>] UpperFlag = "upper"

    ///A handler that prints a given message to the console
    let exec = 
        handler (fun args ->
            match (App.tryGetSetting MessageKey args) with
            | Some message -> 

                let message' = 
                    if (App.isFlagged UpperFlag args) then
                        message.ToUpper ()
                    else
                        message
            
                Console.WriteLine (message')

            | _ -> Usage.print ()
        )

///Contains a handler which prints the index of a needle in a given haystack
module IndexOf = 

    ///A handle which prints the index of a given needle in a given haystack to the console
    let exec = 
        handler (fun args ->
            if (App.hasSettings [ "haystack"; "needle" ] args) then

                let needle = App.getSetting "needle" args
                let haystack = App.getSetting "haystack" args

                Console.WriteLine (haystack.IndexOf needle)

            else
                Usage.print ()
        )

///Contains literals of commands
module Commands = 
    let [<Literal>] Now = "now"
    let [<Literal>] Echo = "echo"
    let [<Literal>] IndexOf = "indexof"

///Application entry point
[<EntryPoint>]
let main argv = 
    App.run Usage.exec [
        (Commands.Echo, Echo.exec);
        (Commands.Now, Now.exec);
        (Commands.IndexOf, IndexOf.exec);
    ] argv

    //NOTE That you cannot do this: main = App.run Usage.exe [ .. ] - although the type signature will
    //be correct, F# will not invoke the function and your console app will just exit as soon as it starts.

