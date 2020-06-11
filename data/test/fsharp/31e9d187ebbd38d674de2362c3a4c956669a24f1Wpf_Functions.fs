[<AutoOpen>]
module Nagato.Wpf_Functions

open System
open System.Diagnostics
open System.Reflection      
open System.Windows
open System.Windows.Controls
open System.Windows.Media


module Process =
  let run exeFileName args =
    let processStartInfo = 
     ProcessStartInfo(
      FileName = exeFileName,
      Arguments = args)

    Process.Start(processStartInfo)

  let runConsole exeFileName args =
    let processStartInfo = 
     ProcessStartInfo(
      FileName = exeFileName,
      Arguments = args,
      CreateNoWindow = true,
      UseShellExecute = false,
      RedirectStandardInput  = true,
      RedirectStandardOutput = true)

    Process.Start(processStartInfo)

[<AutoOpen>]
module WpfF =                                                                  
  let msg (text:'a) = 
    MessageBox.Show(sprintA text,"WpfF.msg") |> ignore
  let msg2 (text:'a) (title:'b) = 
    MessageBox.Show(sprintA text,sprintA title) |> ignore
    
  let inline w w control = 
    (^T:(member set_Width : float->unit)(control,float w))

  let inline h h control =
    (^T:(member set_Height: float->unit)(control,float h))

  let inline sz w h control = 
    (^T:(member set_Width : float->unit)(control,float w))
    (^T:(member set_Height: float->unit)(control,float h))

  let inline szt (w,h) control = 
    (^T:(member set_Width : float->unit)(control,float w))
    (^T:(member set_Height: float->unit)(control,float h))

  let inline szp (p:Point) control =
    (^T:(member set_Width : float->unit)(control, p.X))
    (^T:(member set_Height: float->unit)(control, p.Y))
                                     
  let inline bgco color control = 
    (^T:(member set_Background : Brush -> unit)(control,SolidColorBrush color))

  let inline fgco color control = 
    (^T:(member set_Background : Brush -> unit)(control,SolidColorBrush color))

  let mgn length (control:#FrameworkElement) =
    control.Margin <- Thickness(float length)

  let mgn4 (l,t,r,b) (control:#FrameworkElement) =
    control.Margin <- Thickness(float l,float t,float r,float b)

  let pdng  length (control:#Control) = 
    control.Padding <- Thickness(float length)
  let pdng4 (l,t,r,b) (control:#Control) =
    control.Padding <- Thickness(float l, float t, float r, float b)

  let tight_control (control:#Control) =
    control |>! mgn 0 |> pdng 0

  //
  // color
  //
  let color_to_brush color = SolidColorBrush(color)

  let all_default_colors =
    let flags  = BindingFlags.Public ||| BindingFlags.Static
    let colors = typeof<Colors>.GetProperties flags
    [ for pi in colors -> pi.GetValue(null,null) :?> Color]

  //
  // geometry
  //
  let po x y = Point(float x , float y)