open System
open Parcel

printfn "Excel Parser Console"
printfn "Type a formula expression or 'quit'."

let rec readAndProcess() =
    printf "excel: "
    match Console.ReadLine() with
    | "quit" -> ()
    | expr ->
        try
            printfn "Parsing..."
            Parcel.consoleParser expr
            
        with
        | :? AST.IndirectAddressingNotSupportedException as ex ->
            printfn "Indirect addressing mode is not presently supported:\n%s" ex.Message
        | _ as ex ->
            printfn "Unhandled Exception: %s" ex.Message
            if (ex.InnerException <> null) then
                printfn "Inner Exception: %s" ex.InnerException.Message

        readAndProcess()

readAndProcess()