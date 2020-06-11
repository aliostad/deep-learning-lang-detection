module NativeImageHandler

open System
open System.Drawing
open System.Drawing.Imaging 

open System.Runtime.InteropServices // for Marshal.Copy

// Bitmap.SetPixel is not thread safe and also slow on larger bmps. We use a raw array to build bitmaps between frames

let createBitmapArray w h =
    Array.zeroCreate (w * h * 4)

let setBitmapArrayArgb (byteArray: byte[]) w (x,y) (A:byte) (R:byte) (G:byte) (B:byte) =
    let i = (y * w + x) * 4
    byteArray.[i + 0] <- B
    byteArray.[i + 1] <- G
    byteArray.[i + 2] <- R
    byteArray.[i + 3] <- A

let setBitmapArrayColorVal (byteArray: byte[]) w (x,y) (c: Color) =
    setBitmapArrayArgb byteArray w (x,y) c.A c.R c.G c.B
    
let arrayToBitmap (byteArray: byte[]) (image: Bitmap) =    
    let bitmapData = image.LockBits(Rectangle(0, 0, image.Width, image.Height), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb)
    let numBytes = image.Width * image.Height * 4
    Marshal.Copy(byteArray, 0, bitmapData.Scan0, numBytes)
    image.UnlockBits(bitmapData)
    image

