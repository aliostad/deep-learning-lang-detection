module WorkingWithEventsFromDotnetLibraries

// in this chapter, we will cover the following topic 
//  1. how to work with the event type from the .net libraries 
//  2. how to create delegate types and addHandler, removeHandler in order to work with event handlers


open System.Windows.Forms

open System.Timers

let timer = 
    // define the timer 
    let temp = new Timer(Interval = 3000.0, Enabled = true)

    // a counter to hold the current message
    let messageNo = ref 0 

    // the mesage to be shown 
    let messages =["bet"; "this"; "gets"; 
                   "really"; "annoying"
                   "very"; "quickly"]
    // add an event to the timer 
    temp.Elapsed.Add(fun _ -> 
        // show the message box 
        MessageBox.Show(List.nth messages !messageNo) |> ignore 
        // update the message counter 
        messageNo := (!messageNo + 1) % (List.length messages))
    temp 

// print a message then wait for a user action 
//printfn "Whack the return return to finish!"
//System.Console.ReadLine() |> ignore 
//timer.Enabled <- false


open System
open System.Windows.Forms

// define a form 
let form =
    // the temporary form definition 
    let temp = new Form(Text = "Events example")

    // define an event handler 
    let stuff _ _ = MessageBox.Show("this is \"DOing stuff\"") |> ignore 
    let stuffHandler = new EventHandler (stuff) 

    // define a button and the event handler
    let event = new Button(Text = "Do Stuff", Left = 8, Top = 40, Width = 80)
    event.Click.AddHandler(stuffHandler)

    // label to show the event status 
    let label =new Label (Top = 8, Left = 96)

    // bool to hold the event status and function 
    // to print the event status to the label 
    let eventAdded = ref true 
    let setText b = label.Text <- (Printf.sprintf "Event is on: %b" !b)
    setText eventAdded

    // define a second button and it's click event handler 
    let toggle = new Button(Text = "Toggle Event", Left = 8, Top = 8, Width = 80)

    toggle.Click.Add(fun _ ->
        if !eventAdded then 
            event.Click.RemoveHandler(stuffHandler)
        else 
            event.Click.AddHandler(stuffHandler)
        eventAdded := not !eventAdded
        setText eventAdded)
    // add the controls to the form 
    let dc c = (c :> Control)
    temp.Controls.AddRange([| dc toggle; dc event; dc label; |])
    // return the form to the top level 
    temp  

// do Application.Run(form)
