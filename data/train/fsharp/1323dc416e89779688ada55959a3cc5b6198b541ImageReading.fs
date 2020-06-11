module ImageReading

open System.Drawing
open System.Drawing.Imaging

let pixels (image:Bitmap) =
    
    let data = image.LockBits(new Rectangle(0,0,image.Width,image.Height), Imaging.ImageLockMode.ReadOnly, image.PixelFormat)

    let ptr = data.Scan0
    let stride = abs(data.Stride)
    let size = abs(data.Stride) * data.Height
    let values : byte[] = Array.zeroCreate size
    

    System.Runtime.InteropServices.Marshal.Copy(ptr, values, 0, size)

    for r=0 to data.Height - 1 do
      for c=0 to image.Width - 1 do
        let idx = (r*stride) + (c*3)
        let gray = byte(0.2989 * float(values.[idx])) + byte(0.5870 * float(values.[idx+1])) + byte(0.1140 * float(values.[idx+2]))
        values.[idx] <-  gray //R
        values.[idx+1] <-  gray //G
        values.[idx+2] <-  gray //B
          
    System.Runtime.InteropServices.Marshal.Copy(values, 0, ptr, size)

    image.UnlockBits(data)

    image
    
    