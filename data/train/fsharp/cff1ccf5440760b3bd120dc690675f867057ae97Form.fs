namespace FShapApp

open System
open System.Drawing
open System.Windows
open System.Windows.Forms

module Form =
    let winForm = new Form()
    winForm.Height <- 500
    winForm.Width <- 800
    let mutable x = 20
    let mutable y = 20
    for i in [|0..8|] do
        match i with 
                | (3 | 6) -> y <- y + 10
                | _ -> ()
        for j in [|0..8|] do
            match j % 3 with 
                | 0 -> x <- x + 10
                | _ -> ()
            x <- x + 20
            let t = new TextBox()
            t.MaxLength <- 1
            t.TextAlign <- HorizontalAlignment.Left





            t.TextChanged.AddHandler(new System.EventHandler 
                (fun s e ->
                    match t.Text with 
                        | ("1" | "2" | "3" | "4" | "5" 
                            | "6" | "7" | "8"| "9") -> ()
                        | _ -> t.Text <- "" ))
                            
            t.Location <- new Point(x, y)
            t.Height <- 20
            t.Width <- 20
            winForm.Controls.Add(t)
        y <- y + 20
        x <- 20
    Application.Run(winForm)    