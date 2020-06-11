open System
open System.Windows.Forms

let mainForm = 

    let form = new Form(Text = "Main form")
    let button = new Button(Text = "Button", Left = 10,
                    Top = 10, Width = 80, Enabled = false)

    let textBox = new TextBox(Text = "abc",
                            Top = 50, Left = 10)                  
    let toggle = new Button(Text = "Toggle", Left = 100,
                    Top = 10, Width = 80)
                    
    toggle.Click.Add(fun _ ->
        button.Enabled <- not button.Enabled
        textBox.Enabled <- not textBox.Enabled)                   
                                                                
    let buttonPress _ _ = 
            MessageBox.Show(textBox.Text) |> ignore


    let eventHandler = new EventHandler(buttonPress)

    button.Click.AddHandler(eventHandler)               

    let dc c = (c :> Control)

    form.Controls.AddRange([| dc button; dc textBox; dc toggle |])

    form


do Application.Run(mainForm)