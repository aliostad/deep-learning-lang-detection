module utils

open measures

let IMAGE_SIZE = 28, 28
let PIXEL_DEPTH = 255

let IMAGE_LENGTH =  fst(IMAGE_SIZE) * snd(IMAGE_SIZE) * 1<imagePixel>

let showImages setPar showImage (images: single[][])  = 
    let n = images.Length    
    let n = if n <= 2 then 2 else System.Convert.ToInt32(System.Math.Round(System.Math.Sqrt((float)n))) + 1;
    printf "par %i" n
    setPar [|n; n|]
    images |> Array.iter (fun f -> f |> showImage IMAGE_SIZE)
    //Without it swallow last image
    showImage IMAGE_SIZE (Array.create 0 (single 0))
    

//http://stackoverflow.com/questions/687261/converting-rgb-to-grayscale-intensity
let inline getGrayScale ((R: _), (G: _), (B: _)) = 
    (single) (0.2126 * (float)R + 0.7152 * (float)G + 0.0722 * (float)B)

let inline RGB2GrayScale (arr : _ array) = getGrayScale (arr.[0], arr.[1], arr.[2])

let fileJustName (fileInfo: System.IO.FileInfo) = fileInfo.Name.Replace(fileInfo.Extension, "")

let getRGBfrom12bytes bytes =
    match bytes with
        | [ r1; r2; r3; r4; g1; g2; g3; g4; b1; b2; b3; b4 ] -> 
            let R : single array = [|(single)0.|]
            let G : single array = [|(single)0.|]
            let B : single array = [|(single)0.|]
            System.Buffer.BlockCopy([|r1; r2; r3; r4|], 0, R, 0, 4)
            System.Buffer.BlockCopy([|g1; g2; g3; g4|], 0, G, 0, 4)
            System.Buffer.BlockCopy([|b1; b2; b3; b4|], 0, B, 0, 4)
            R.[0], G.[0], B.[0]
        | _ ->  failwith "Array has wrong size"           

let getPixelfrom12bytes bytes =
    bytes |> getRGBfrom12bytes |> getGrayScale


///
/// Bytes R-4 bytes, G-4 bytes, B-4 bytes -> float, float, float (normalized by 255)
let getPixels bytes = 
    bytes 
    |> Seq.chunkBySize 12
    |> Seq.map(fun m -> m |> Array.toList |> getPixelfrom12bytes )
