module public Lightswitch.Commands

open Q42.HueApi
open Q42.HueApi.ColorConverters.Original

let id() = LightCommand()

type c = LightCommand

let off (command: c) = command.TurnOff()

let on (command: c) = command.TurnOn()

let colour (r:int) (g:int) (b:int) (command: c) = command.SetColor(new Q42.HueApi.ColorConverters.RGBColor(r, g, b))

let brightness b (command: c) = 
    let clamp i = match i with 
        | _ when i > 255 -> 255
        | _ when i < 0 -> 0
        | _ -> i

    command.Brightness <- System.Nullable<byte>(b |> byte)
    command

let effect e (command: c) =
    command.Effect <- e
    command