#I "packages/GtkSharp/lib/net45"
#r "atk-sharp.dll"
#r "gio-sharp.dll"
#r "glib-sharp.dll"
#r "gtk-sharp.dll"

open System
open Gtk

let mutable click_count = 0

let OnClick (btn : Button) =
  click_count <- click_count + 1
  // Console.WriteLine("Button Click {0}", click_count)
  btn.Label <- String.Format("Button Click {0}", click_count)

let OnDelete (sender:obj) (args:DeleteEventArgs) =
  Application.Quit()
  args.RetVal <- true

// Create the window
Application.Init();
let wnd = new Window("F# Main Window")

let box = new Gtk.VBox()
let ok_btn = new Button("Ok")

//ok_btn.Clicked += new EventHandler(OnButtonClick)
ok_btn.Clicked.AddHandler (fun s a -> OnClick ok_btn)

box.PackStart(ok_btn, false, false, (uint32 0))
wnd.Add(box)

// Set up the window delete event and display it
wnd.DeleteEvent.AddHandler (fun s a -> OnDelete s a) // fun still needed
wnd.ShowAll()

// And we're off!...
Application.Run()
