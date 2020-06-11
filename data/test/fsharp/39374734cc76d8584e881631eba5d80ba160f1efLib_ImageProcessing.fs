[<AutoOpen>]
module Nagato.Lib_ImageProcessing

open Nagato
open System
open System.Windows
open System.Windows.Media
open System.Windows.Media.Imaging



type WriteableBitmap with
  member bitmap.W    = bitmap.PixelWidth
  member bitmap.H    = bitmap.PixelHeight
  member bitmap.Size = (bitmap.PixelWidth , bitmap.PixelHeight)

  //
  // bitmap operations
  //
  member bitmap.CopyPixel (p:point) =
    let apixel = [|0|]
    bitmap.CopyPixels((make_rect p.X.i p.Y.i 1 1), apixel, bitmap.W * 4, 0)
    apixel.[0]

  member bitmap.CopyHorizontalLine (p:point) len =
    let apixel = Array.zeroCreate<int> len
    bitmap.CopyPixels((make_rect p.X.i p.Y.i len 1), apixel, bitmap.W * 4, 0)
    apixel
  
  member bitmap.WriteRect x y w (apixel:int []) =
    let h = apixel.Length / w
    bitmap.WritePixels(make_rect x y w h, apixel, w*4,0) 

  member bitmap.WritePixel (p:point) (color:Color) =
    bitmap.WriteRect p.X.i p.Y.i 1 [|color.toInt|]

  member bitmap.WriteHorizontalLine x y (apixel:int []) =
    bitmap.WriteRect x y apixel.Length apixel

