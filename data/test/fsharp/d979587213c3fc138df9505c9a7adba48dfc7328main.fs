open System
open System.Threading

let spin (s : string) (x, y) = async {
    while true do
        for c in s do
            let pos = (Console.CursorLeft, Console.CursorTop)
            Console.SetCursorPosition(x, y)
            Console.Write(c)
            Console.SetCursorPosition pos
            do! Async.Sleep 50
}

let spinnerString = "/-\|"

let prompt() = 
    printf "1 2 or 3 to toggle spinners, q to quit > "
    
let clearBackground = async {
    while true do
        do! Async.Sleep 300
        Console.Clear()
        prompt()
}

let manageSpinner spinner status =
    match !status with
        | None ->
            status := Some (new CancellationTokenSource())
            Async.Start(spinner, (!status).Value.Token)
        | Some _ ->
            (!status).Value.Cancel()
            status := None

let spin1status : CancellationTokenSource option ref = ref None
let spin1 = spin spinnerString (Console.WindowLeft, Console.WindowHeight / 2)

let spin2status : CancellationTokenSource option ref = ref None
let spin2 = spin spinnerString ((Console.WindowWidth - 2) / 2, Console.WindowHeight / 2)

let spin3status : CancellationTokenSource option ref = ref None
let spin3 = spin spinnerString (Console.WindowWidth - 2, Console.WindowHeight / 2)

let main() = 
    Console.Clear()
    clearBackground |> Async.Start
    while true do
        prompt()
        while not Console.KeyAvailable do
            Thread.Sleep 100
        let keyInfo = Console.ReadKey false
        match keyInfo.Key with
            | ConsoleKey.Q -> Environment.Exit 0
            | ConsoleKey.D1 -> manageSpinner spin1 spin1status
            | ConsoleKey.D2 -> manageSpinner spin2 spin2status
            | ConsoleKey.D3 -> manageSpinner spin3 spin3status
            | _ -> ()

main()
