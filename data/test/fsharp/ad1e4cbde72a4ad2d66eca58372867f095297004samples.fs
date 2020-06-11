#light
open System
open System.Windows.Forms
let form =
    let temp = new Form()
    let stuff _ _ = ignore(MessageBox.Show("This is \"Doing Stuff\""))
    let stuffHandler = new EventHandler(stuff)
    let event = new Button(Text = "Do Stuff", Left = 8, Top = 40, Width = 80)
    event.Click.AddHandler(stuffHandler)
    let eventAdded = ref true
    let label = new Label(Top = 8, Left = 96)
    let setText b = label.Text <- (Printf.sprintf "Event is on: %b" !b)
    setText eventAdded
    let toggle = new Button(Text = "Toggle Event", Left = 8, Top = 8, Width = 80)
    toggle.Click.Add(fun _ ->
        if !eventAdded then
            event.Click.RemoveHandler(stuffHandler)
        else
            event.Click.AddHandler(stuffHandler)
        eventAdded := not !eventAdded
        setText eventAdded)
    let dc c = (c :> Control)
    temp.Controls.AddRange([| dc toggle; dc event; dc label; |]);
    temp
do Application.Run(form)