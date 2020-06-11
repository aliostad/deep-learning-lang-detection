namespace Katamari
    module MainModule =

        open System
        open Printer
        open GameData
        open Levels           

        let quit () =
            Printer.bid_adieu()
            false

        let load_level (level:Level) =
            let levelCopy = level;
            GameData.init levelCopy

        let try_level () =
            printf "Available levels are: "
            Levels.get_levels |> List.map (fun l -> l.name.Trim()) |> List.iter (printf "%s ")
            printfn ""
                        
            match Levels.get_level (Input.request "Which level would you like to play? ") with
            | Some l -> PlayGame.play <| load_level l
            | None -> printfn "I'm sorry that's not an available level"; true

        let handleInput (input:string) =
            match input with
            | "quit" | "q" -> quit()
            | "play" | "p" | "pl" -> try_level()
            | _ -> printfn "play, quit"; true

        [<EntryPoint>]
        let main argv = 
            Printer.welcome()            
            
            printfn "Time to start playing, what would you like to do? Valid commands are play, quit"            

            while handleInput (Input.request "> ") do
                1 |> ignore // We don't really want to do anything in the body, we just want to keep going until we say 'quit'

#if DEBUG
            Console.ReadLine() |> ignore
#endif

            0 // return an integer exit code
