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
    let win = Window(Title = "Command The Menu", Content = dock)

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
        MenuItem(Header="Cu_t",Icon=img,Command=ApplicationCommands.Cut) |> addItems itemEdit

    let itemCopy = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/CopyHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","Images""CopyHS.png")))
        #endif
        MenuItem(Header="_Copy",Icon=img,Command=ApplicationCommands.Copy) |> addItems itemEdit
        
    let itemPaste = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/PasteHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","Images""PasteHS.png")))
        #endif
        MenuItem(Header="_Paste",Icon=img,Command=ApplicationCommands.Paste) |> addItems itemEdit
        
    let itemDelete = 
        #if COMPILED
        let img = Image(Source=BitmapImage(Uri "pack://application:,,/Images/DeleteHS.png"))
        #else
        let img = Image(Source=BitmapImage(Uri <| Path.Combine(__SOURCE_DIRECTORY__,"Images","Images""DeleteHS.png")))
        #endif
        MenuItem(Header="_Delete",Icon=img,Command=ApplicationCommands.Delete) |> addItems itemEdit

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

    let canExecuteDeleteCopyCut (args: CanExecuteRoutedEventArgs) =
         args.CanExecute <- text.Text <> null && text.Text.Length > 0

    // The custom command part
    let gestColl = InputGestureCollection([|KeyGesture(Key.R,ModifierKeys.Control)|])
    let commRestore = RoutedUICommand("_Restore","Restore",win.GetType(),gestColl)
    let itemRestore = MenuItem(Header="_Restore",Command=commRestore) |> addItems itemEdit

    [|
    ApplicationCommands.Cut, 
    (fun _ _ -> Clipboard.SetText text.Text; text.Text <- null), 
    (fun _ -> canExecuteDeleteCopyCut)

    ApplicationCommands.Copy, 
    (fun _ _ -> Clipboard.SetText text.Text), 
    (fun _ -> canExecuteDeleteCopyCut)

    ApplicationCommands.Delete, 
    (fun _ _ -> text.Text <- null), 
    (fun _ -> canExecuteDeleteCopyCut)

    ApplicationCommands.Paste, 
    (fun _ _ -> text.Text <- Clipboard.GetText()), 
    (fun _ (args :CanExecuteRoutedEventArgs) -> args.CanExecute <- Clipboard.ContainsText())

    commRestore,
    (fun _ _ -> text.Text <- "Sample clipboard text"),
    (fun _ (args: CanExecuteRoutedEventArgs) -> args.CanExecute <- true)
    |] |> Array.iter (ignore << win.CommandBindings.Add << CommandBinding)

    win.Show()
    //Application().Run(win) |> ignore
with e -> MessageBox.Show(e.Message,"Exception Error") |> ignore
