namespace CopyStacker
namespace CopyStacker

open System.Drawing
open System.Windows.Forms

type TrayIcon() = 
    let notifyIcon = new NotifyIcon()
    do notifyIcon.Icon <- new Icon("icon.ico")
    do notifyIcon.Text <- "Copy Historian"
    do notifyIcon.Visible <- true
    do notifyIcon.ContextMenu <- new ContextMenu()
    do ("E&xit", new System.EventHandler(fun sender args -> Application.Exit())) |> notifyIcon.ContextMenu.MenuItems.Add |> ignore

    interface System.IDisposable with
        member disposable.Dispose() =
            notifyIcon.Dispose()