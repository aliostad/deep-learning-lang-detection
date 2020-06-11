namespace potato
    module Main =
        
        open System
        open Gtk
        open Glade

        type Handler()=class
            [<Widget>]
            [<DefaultValue(true)>]
            val mutable window1 : Window
        end

        let OnDelete (args:DeleteEventArgs) =
            Application.Quit()
            args.RetVal <- true 
    
        [<EntryPoint>]
        let Main(args) = 
            Application.Init()

            let gxml =  new Glade.XML(null, "GUI.glade", "window1", null)
            let handler = new Handler()
            gxml.Autoconnect(handler)

            handler.window1.DeleteEvent
            |> Event.add OnDelete

            handler.window1.ShowAll()
            Application.Run()
            0
