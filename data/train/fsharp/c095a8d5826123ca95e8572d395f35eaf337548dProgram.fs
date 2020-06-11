// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.

// TemperatureCelsius = (Sensorvalue x 0.2222) - 61.111
// If you want maximum accuracy, you can use the RawSensorValue property from the PhidgetInterfaceKit. To adjust a formula, substitute (SensorValue) with (RawSensorValue / 4.095) 
// from here: http://www.phidgets.com/docs/1124_User_Guide

open System
open PhidgetApiAdapter

let AttachEventHandler (evArgs : AttachEventArgs) =
    printf "Phidget Interface Kit %i attached.\n" evArgs.Device.SerialNumber

let DetachEventHandler (evArgs : DetachEventArgs) =
    printf "Phidget Interface Kit %i detached.\n" evArgs.Device.SerialNumber

let SensorChangeEventHandler (evArgs : SensorChangeEventArgs) =
    match evArgs.Index with
    | 0 -> printf "temp"
    | _ -> printf "I don't know how to do nothing"

[<EntryPoint>]
let main argv = 

    use ifKit = PhidgetContext.GetInterfaceKit
    ifKit.Attach.Add(AttachEventHandler) 
    ifKit.Detach.Add(DetachEventHandler)
    ifKit.SensorChange.Add(SensorChangeEventHandler)
    
    printf "Press ENTER to exit ...\n" 
    let s = Console.ReadLine()
    0 // return an integer exit code
