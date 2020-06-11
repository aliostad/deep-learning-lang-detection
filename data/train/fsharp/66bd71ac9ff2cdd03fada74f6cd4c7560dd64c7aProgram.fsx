// Expert F# 2.0
// Chapter 13 Example 05

open System.IO
let numImages = 200
let size = 512
let numPixels = size * size

// Synchronous Image processor

let makeImageFiles () =
    printfn "making %d %dx%d images... " numImages size size
    let pixels = Array.init numPixels (fun i -> byte i)
    for i = 1 to numImages  do
        System.IO.File.WriteAllBytes(sprintf "Image%d.tmp" i, pixels)
    printfn "done."

let processImageRepeats = 20

let transformImage (pixels, imageNum) =
    printfn "transformImage %d" imageNum;
    // Perform a CPU-intensive operation on the image.
    for i in 1 .. processImageRepeats do 
        pixels |> Array.map (fun b -> b + 1uy) |> ignore
    pixels |> Array.map (fun b -> b + 1uy)

let processImageSync i =
    use inStream =  File.OpenRead(sprintf "Image%d.tmp" i)
    let pixels = Array.zeroCreate numPixels
    let nPixels = inStream.Read(pixels,0,numPixels);
    let pixels' = transformImage(pixels,i)
    use outStream =  File.OpenWrite(sprintf "Image%d.done" i)
    outStream.Write(pixels',0,numPixels)

let processImagesSync () =
    printfn "processImagesSync...";
    for i in 1 .. numImages do
        processImageSync(i)

System.Environment.CurrentDirectory <- __SOURCE_DIRECTORY__
makeImageFiles()

// Asynchronous Image Processor

let processImageAsync i =
    async { use inStream = File.OpenRead(sprintf "Image%d.tmp" i)
            let! pixels = inStream.AsyncRead(numPixels)
            let  pixels' = transformImage(pixels,i)
            use outStream = File.OpenWrite(sprintf "Image%d.done" i)
            do! outStream.AsyncWrite(pixels')  }

let processImagesAsync() =
    printfn "processImagesAsync...";
    let tasks = [ for i in 1 .. numImages -> processImageAsync(i) ]
    Async.RunSynchronously (Async.Parallel tasks)  |> ignore
    printfn "processImagesAsync finished!";

