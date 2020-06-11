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
    let win = Window(Title = "Select Color from Menu Grid", Content = dock)

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
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","CutHS.png")))
        #endif
        MenuItem(Header="Cu_t",Icon=img) |> addItems itemEdit

    let itemCopy = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/CopyHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","CopyHS.png")))
        #endif
        MenuItem(Header="_Copy",Icon=img) |> addItems itemEdit
        
    let itemPaste = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/PasteHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","PasteHS.png")))
        #endif
        MenuItem(Header="_Paste",Icon=img) |> addItems itemEdit
        
    let itemDelete = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/DeleteHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","DeleteHS.png")))
        #endif
        MenuItem(Header="_Delete",Icon=img) |> addItems itemEdit

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

    itemCut.Click.Add <| fun args ->
        copyOnClick args
        deleteOnClick args

    itemCopy.Click.Add copyOnClick
    itemDelete.Click.Add deleteOnClick
        
    itemPaste.Click.Add <| fun _ ->
        if Clipboard.ContainsText() then
            text.Text <- Clipboard.GetText()

    win.Show()
    Application().Run(win) |> ignore
with e -> MessageBox.Show(e.Message,"Exception Error") |> ignore
