module MainApp

open System
open System.Windows
open System.Windows.Controls
open System.Reflection
open System.Runtime.InteropServices

open FSharpx


open System.IO.Ports

open Gui
open RSCOM


type MainWindow = XAML<"MainWindow.xaml">
  

/// connect with default settings
// TODO: should be a model?!
let rscom = new RSCOM("COM5", 4800, Parity.None, 8, StopBits.One )
rscom.Connect()
rscom.Open()
// TODO: cleanup properly instead of relying on the garbage collector

let loadWindow() =
   let window = MainWindow()
   // Your awesome code code here and you have strongly typed access to the XAML via "window"
   
   /// initialize RTS/DTX/TXD indicators
   fillRectWith (window.RtsSignal) LIGHT_GREY
   fillRectWith (window.DtrSignal) LIGHT_GREY
   fillRectWith (window.TxdSignal) LIGHT_GREY

   /// RTS on
   (fun sender e -> if (rscom.RTS true) then fillRectWith (window.RtsSignal) LIME
                                        else fillRectWith (window.RtsSignal) LIGHT_GREY) 
   |> addButtonHandler (window.RtsAn) 
   
   /// RTS off
   (fun sender e -> if (rscom.RTS false) then fillRectWith (window.RtsSignal) RED
                                         else fillRectWith (window.RtsSignal) LIGHT_GREY) 
   |> addButtonHandler (window.RtsAus)
   
   /// DTR on
   (fun sender e -> if (rscom.DTR true) then fillRectWith (window.DtrSignal) LIME 
                                        else fillRectWith (window.DtrSignal) LIGHT_GREY) 
   |> addButtonHandler (window.DtrAn)
   
   /// DTR off
   (fun sender e -> if (rscom.DTR false) then fillRectWith (window.DtrSignal) RED
                                         else fillRectWith (window.DtrSignal) LIGHT_GREY)
   |> addButtonHandler (window.DtrAus)
   
   /// TXD on
   (fun sender e -> if (rscom.TXD true) then fillRectWith (window.TxdSignal) LIME
                                        else fillRectWith (window.TxdSignal) LIGHT_GREY) 
   |> addButtonHandler (window.TxdAn)
   
   /// TXD off
   (fun sender e -> if (rscom.TXD false) then fillRectWith (window.TxdSignal) RED
                                         else fillRectWith (window.TxdSignal) LIGHT_GREY)
   |> addButtonHandler (window.TxdAus)

   /// schaffold main window
   window.MainWindow


[<STAThread>]
    (new Application()).Run(loadWindow()) |> ignore