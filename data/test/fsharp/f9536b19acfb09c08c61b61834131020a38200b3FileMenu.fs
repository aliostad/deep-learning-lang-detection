namespace au.id.cxd.MathOSXUI


open System
open System.Drawing
open MonoMac.Foundation
open MonoMac.AppKit
open au.id.cxd.MathOSXUI.UIState
open au.id.cxd.MathOSXUI.OSXUIBuilder

module FileMenu =

    [<Export("openAction:")>]
    let openAction(sender:NSObject) =
        Console.WriteLine("Open Action")
        ()
    
    /// <summary>
    /// Build the file menu
    /// </summary>
    let fileMenu (app:ApplicationState) =
        clearMenu "File"
        
        let fileMenuItem = new NSMenuItem("File")
        let menu = new NSMenu()
        menu.Title <- "File"
        let addTo = addMenu menu
        
        let fileopen =
            childmenu (new NSMenuItem("Open"))
                      (fun parent (child:NSMenuItem) ->
                           child
                             .Activated
                             .AddHandler(
                                fun sender evt ->
                                Console.WriteLine("test activated"))
                
                           parent)

        let filesave =
            childmenu (new NSMenuItem("Save"))
                      (fun parent (child:NSMenuItem) ->
                       child
                         .Activated
                         .AddHandler(
                          fun sender evt ->

                          Console.WriteLine("Test Save"))

                       parent)
                      
        let filesaveAs =
            childmenu (new NSMenuItem("Save As"))
                      (fun parent (child:NSMenuItem) ->
                       child
                         .Activated
                         .AddHandler(
                          fun sender evt ->

                          Console.WriteLine("Test Save As"))
                       parent)

        let fileclose =
            childmenu (new NSMenuItem("Close"))
                      (fun parent (child:NSMenuItem) ->
                       child
                         .Activated
                         .AddHandler(
                          fun sender evt ->

                          Console.WriteLine("test Close"))
                       parent)

        let fileprint =
            childmenu (new NSMenuItem("Print"))
                      (fun parent (child:NSMenuItem) ->

                       child
                         .Activated
                         .AddHandler(
                          fun sender evt ->

                          Console.WriteLine("Test Print"))
                       parent)

        let filereload =
            childmenu (new NSMenuItem("Reload"))
                      (fun parent (child:NSMenuItem) ->
                       child
                         .Activated
                         .AddHandler(
                          fun sender evt ->

                          Console.WriteLine("Test Reload"))
                       parent)

        
        (fileopen addTo) |>
        (appendUI
         >> filesave
         >> appendUI
         >> filesaveAs
         >> appendUI
         >> fileclose
         >> appendUI
         >> fileprint
         >> appendUI
         >> filereload
         >> appendUI)
        |> ignore

        fileMenuItem.Submenu <- menu
        fileMenuItem
