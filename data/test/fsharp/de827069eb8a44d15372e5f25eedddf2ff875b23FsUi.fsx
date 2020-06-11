#load "FsUiObject.fsx"

open FSWpf

open System.Windows
open System.IO

type MainWindow() as this = 
    inherit FsUiObject<Window>(Path.Combine(__SOURCE_DIRECTORY__, "FsUiMainWindow.xaml"))

    [<DefaultValue>]
    [<UiElement("run")>]
    val mutable runButton : Controls.Button

    [<DefaultValue>]
    [<UiElement>]
    val mutable text : Controls.TextBox

    let clickHandler _ = 
        let txt = this.text.Text
        MessageBox.Show(this.UiObject, txt) |> ignore
    
    do
        this.runButton.Click.Add(clickHandler)
let window = new MainWindow()
window.UiObject.ShowDialog() |> ignore  