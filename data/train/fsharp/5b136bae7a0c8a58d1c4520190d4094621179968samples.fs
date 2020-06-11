#light
open System
open System.Windows.Forms

// define a form
let form =
    // the temporary form defintion
    let temp = new Form(Text = "Events example")

    // define an event handler
    let stuff _ _ = MessageBox.Show("This is \"Doing Stuff\"") |> ignore
    let stuffHandler = new EventHandler(stuff)
    
    // define a button and the event handler
    let event = new Button(Text = "Do Stuff", Left = 8, Top = 40, Width = 80)
    event.Click.AddHandler(stuffHandler)
    
    
    // label to show the event status
    let label = new Label(Top = 8, Left = 96)
    
    // bool to hold the event status and function
    // to print the event status to the label
    let eventAdded = ref true
    let setText b = label.Text <- (Printf.sprintf "Event is on: %b" !b)
    setText eventAdded
    
    // define a second button and it's click event handler
    let toggle = new Button(Text = "Toggle Event", 
                            Left = 8, Top = 8, Width = 80)
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

// start the event loop and show the form
do Application.Run(form)