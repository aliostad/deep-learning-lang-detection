namespace au.id.cxd.MathOSXUI


open System
open System.Drawing
open MonoMac.Foundation
open MonoMac.AppKit
open au.id.cxd.MathOSXUI.UIState
open au.id.cxd.MathOSXUI.OSXUIBuilder
open au.id.cxd.MathOSXUI.FileMenu

module EditMenu =

    let editMenu (app:ApplicationState) =
        clearMenu "Edit"
        let editMenuItem = new NSMenuItem("Edit")
        let editMenu = new NSMenu()
        editMenu.Title <- "Edit"
        let addTo = addMenu editMenu
        let copy =
            childmenu (new NSMenuItem("Copy"))
                      (fun parent (child:NSMenuItem) ->
                       parent)

        let cut =
            childmenu (new NSMenuItem("Cut"))
                      (fun parent (child:NSMenuItem) ->
                       parent)

        let paste =
            childmenu (new NSMenuItem("Paste"))
                      (fun parent (child:NSMenuItem) ->
                       parent)

        (copy addTo) |>
        (appendUI
         >> cut
         >> appendUI
         >> paste
         >> appendUI) |> ignore
        editMenuItem.Submenu <- editMenu
        editMenuItem
        
