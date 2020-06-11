#if INTERACTIVE
#r "PresentationCore.dll"
#r "PresentationFramework.dll"
#r "System.Xaml.dll"
#r "WindowsBase.dll"
#r "UIAutomationTypes.dll"
#load "Bindings.fs"
#endif

open Bindings
open Microsoft.Win32
open System
open System.IO
open System.Text
open System.Diagnostics
open System.ComponentModel
open System.Windows
open System.Windows.Input
open System.Windows.Controls
open System.Windows.Controls.Primitives
open System.Windows.Media
open System.Windows.Media.Imaging
open System.Windows.Shapes
open System.Windows.Documents
open System.Windows.Threading
open System.Windows.Data

[<STAThreadAttribute>]
try 
    let dock = DockPanel()
    let win = Window(Title = "ControlXCV", Content = dock)

    let menu = Menu() |> DockPanel.DockTop |> addChildren dock
    let text = 
        TextBlock(Text = "Sample clipboard text",HorizontalAlignment=HorizontalAlignment.Center,
                  VerticalAlignment=VerticalAlignment.Center,FontSize=32.0,TextWrapping=TextWrapping.Wrap)
        |> addChildren dock

    let itemEdit = MenuItem(Header="_Edit") |> addItems menu
    
    let itemCut = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/CutHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","Images""CutHS.png")))
        #endif
        MenuItem(Header="Cu_t",Icon=img,InputGestureText="Ctrl+X") |> addItems itemEdit

    let itemCopy = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/CopyHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","Images""CopyHS.png")))
        #endif
        MenuItem(Header="_Copy",Icon=img,InputGestureText="Ctrl+C") |> addItems itemEdit
        
    let itemPaste = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/PasteHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","Images""PasteHS.png")))
        #endif
        MenuItem(Header="_Paste",Icon=img,InputGestureText="Ctrl+V") |> addItems itemEdit
        
    let itemDelete = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/DeleteHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","Images""DeleteHS.png")))
        #endif
        MenuItem(Header="_Delete",Icon=img,InputGestureText="Delete") |> addItems itemEdit

    itemEdit.SubmenuOpened.Add(fun _ ->
        let f (x: MenuItem) v = x.IsEnabled <- v; v
        (text.Text <> null && text.Text.Length > 0)
        |> f itemCut |> f itemCopy |> f itemDelete |> ignore
        Clipboard.ContainsText() |> f itemPaste |> ignore)

    let copyOnClick _ =
        if text.Text <> null && text.Text.Length > 0 then
            Clipboard.SetText text.Text

    let deleteOnClick _ =
        if text.Text <> null && text.Text.Length > 0 then
            text.Text <- null

    let pasteOnClick _ =
        if Clipboard.ContainsText() then
            text.Text <- Clipboard.GetText()

    let cutOnClick args =
        copyOnClick args
        deleteOnClick args

    itemCut.Click.Add pasteOnClick
    itemCopy.Click.Add copyOnClick
    itemDelete.Click.Add deleteOnClick
    itemPaste.Click.Add pasteOnClick


    let gestCut = KeyGesture(Key.X,ModifierKeys.Control)
    let gestCopy = KeyGesture(Key.C,ModifierKeys.Control)
    let gestPaste = KeyGesture(Key.V,ModifierKeys.Control)
    let gestDelete = KeyGesture(Key.Delete)

    win.PreviewKeyDown.Add <| fun args ->
        args.Handled <- true
        if gestCut.Matches(null, args) then cutOnClick args
        elif gestCopy.Matches(null, args) then copyOnClick args
        elif gestPaste.Matches(null, args) then pasteOnClick args
        elif gestDelete.Matches(null, args) then deleteOnClick args
        else args.Handled <- false

    win.Show()
    Application().Run(win) |> ignore
with e -> MessageBox.Show(e.Message,"Exception Error") |> ignore
