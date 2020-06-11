open System
open System.Diagnostics

/////////////////////////////////////////////
let FPS = 60.0
let DUR = 60.0
/////////////////////////////////////////////

let frameCount = 
   int (FPS * DUR + 0.5)
let clerp a b f =
   a + (b - a) * 0.5 * (1.0 - cos (f * Math.PI))

let genArgs a n =
   sprintf "-f \"cos(t)-cos(%f*t)^3|sin(%f*t)-sin(t)^3\" -b \"atan((pi-t))*atan(t)\" -o \"anim\\%04d.png\" -s 1920x1080 -r 800x800 -n 100000 -x [-2,2] -y [-2,1] -t [0,3.14159] -p -d 0.001" a a (n+1)

[0..frameCount-1]
|> List.map (fun f -> f, genArgs (clerp 0.0 7.0 ((float f) / (float frameCount))) f)
|> List.map (fun (f, a) -> 
               let p = new Process();
               p.StartInfo <- new ProcessStartInfo("TangentDrawer.exe", a)
               p.StartInfo.UseShellExecute <- false
               Console.ForegroundColor <- ConsoleColor.Red
               Console.Clear()
               printfn "[ANIMATION SCRIPT, FRAME %d/%d]" (f + 1) frameCount
               Console.ForegroundColor <- ConsoleColor.White
               p.Start() |> ignore
               p.WaitForExit()
            )
Process.Start("ffmpeg.exe", sprintf "-framerate %d -i \"anim\\%%04d.png\" \"anim\\_output.mp4\"" (int FPS))