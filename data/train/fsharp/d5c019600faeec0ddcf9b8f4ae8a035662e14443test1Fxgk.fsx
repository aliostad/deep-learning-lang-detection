

App.init()
           
let gui = Builder.loadFile "/home/arch/gtk/entry1.glade"

let win = Builder.getWindow gui "mainWindow" 
let btn = Builder.getButton gui "buttonClick"
let entry1 = Builder.getEntry gui "entryOne"

Window.setDefaultSize 400 300 win 


let tryParseInt s =
    try Some (int s)
    with _ -> None 

let updateSum () =
    Wdg.getEntryText entry1
    |> tryParseInt 
    |> Option.iter (fun a -> printfn "The sum = %d" <| a * 3 + 10)


// let asyncLoop delay handler =
//     let rec aux () = async {
//         do! handler()
//         do! Async.Sleep delay
//         do! aux ()
//         return ()
//         }
//     Async.Start <| aux ()

let runForever delay handler =
    let timer = new System.Timers.Timer ()
    timer.Interval <- delay
    timer.AutoReset <- true    
    ignore <| timer.Elapsed.Subscribe(fun _ -> handler ())
    timer.Enabled <- true
    timer.Start()
    timer 



// Signal.onDelete win (fun _ -> Gtk.Application.Quit())

let rec signalLoop () =
    let rnd = new System.Random()
    let rec aux () = async {
        let next = rnd.Next(1, 10)
        Wdg.setEntryText entry1 (next.ToString())
        do!  Async.Sleep (1000 * next)
        do! aux()
        }
    Async.Start (aux ())
    


let runAsyncLoop delay handler =
    let hnd = new System.EventHandler(fun _ -> handler)
    let rec aux () = async {
        Gtk.Application.Invoke(hnd)
        do! Async.Sleep(delay)
        do! aux()
        }
    Async.Start <| aux()



runAsyncLoop 1000 (fun _ -> Wdg.setEntryText entry1 <| System.DateTime.Now.ToString())    

Signal.onClick btn (fun _ ->
                    let dialog = new Gtk.AboutDialog(Authors = [| "Author1"; "Author 2" |]
                                                    ,Comments = "Application to run photos"
                                                     
                                                 )
                    ignore <| dialog.Run()
                    
                    )
                   
// Signal.onKeyRelease entry1 (fun _  -> updateSum())


win.ShowAll()

App.run()

