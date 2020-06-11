
//------------------------------------------------------------------------------
// PP: Encapsulate state and return a function.
//------------------------------------------------------------------------------

let generateTicket =
    let mutable count = 0 // ??: Should I use ref here instead of mutable?
    (fun () -> count <- count + 1; count)

generateTicket ()

//------------------------------------------------------------------------------
// PP: Encapsulate state in a class type.
//------------------------------------------------------------------------------

type TicketGenerator() =
    let mutable count = 0

    member x.Next() =
        count <- count + 1
        count

    member x.Reset () =
        count <- 0

let tg = TicketGenerator()
tg.Next()
tg.Reset()

//------------------------------------------------------------------------------
// LF: Modules can be extended with functions.
//------------------------------------------------------------------------------

module List =
    let rec pairwise l =
        match l with
        | []            -> []
        | [h]           -> [(h,h)]
        | h1 :: h2 :: t -> (h1, h2) :: (pairwise t)

List.pairwise [1;2;3;4;5;6]
List.pairwise [1;2;3;4;5]

//------------------------------------------------------------------------------
// Interop with Win32 API
//------------------------------------------------------------------------------

open System.Runtime.InteropServices

type ControlEventHandler = delegate of int -> bool

[<DllImport("kernel32.dll")>]
extern void SetConsoleCtrlHandler(ControlEventHandler callback, bool add)

let ctrlSignal = ref false

let ctrlEventHandler =
    new ControlEventHandler(fun i ->
        if (i = 0) then
            printfn "Exiting..";
            ctrlSignal := true;
            true
        else
            false
    )

SetConsoleCtrlHandler(ctrlEventHandler, true)

printfn "Enter Ctrl+C to exit.."

while (ctrlSignal = ref false) do
    System.Threading.Thread.Sleep(1000)

//------------------------------------------------------------------------------
