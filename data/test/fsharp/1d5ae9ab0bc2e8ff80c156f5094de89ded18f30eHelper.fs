namespace Helper 

open System.Drawing
open System.Web
open FSharp.Data
open System.Xml
open System.Xml.Linq
open System.Windows.Forms
open System.IO
open System
open UsefulTools

type Video = {url:string; start:int; stop:int}

type Link = 
    {original:string; embeded:Video; images:Bitmap array option}

type Helper() =

    static let extractNameAndTime (uri : string) =
        let slash = '/'
        let times = [|"?t=";"?start="|]
        uri.Split([|slash|])
        |> Array.last
        |> (fun x -> x.Split(times, System.StringSplitOptions.None))
        |> (fun x -> (x.[0], x |> Array.last |> int))
        |> (fun (u, s) -> {url = u; start = s; stop = s+10})

    static let random = Random(0)

    static let randomSubsetBySize n (a : 'a array) = 
        match a.Length with
        | count when count <= n -> a
        | count ->  
            let randoms = 
                Seq.initInfinite (fun _ -> random.Next(count))
                |> Seq.distinct
                |> Seq.take n
                |> Seq.toArray
            randoms 
            |> Array.map (fun i -> a.[i]) 

    static let transformToImage (video : Video) =
 
        let vlc = @"C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
        let tempDir = 
            (Path.GetTempPath(), Guid.NewGuid().ToString())
            |> Path.Combine
            |> Path.GetFullPath
        let settings start stop path = @" --video-filter=scene --vout=dummy --no-audio --start-time=" + (start |> string) + @" --stop-time=" + (stop |> string) + @" --scene-format=png --scene-path=" + path
        let quit = " vlc://quit"
        let fullUrl url = "https://youtu.be/" + url

        Directory.CreateDirectory(tempDir) |> ignore
        use myProcess = new System.Diagnostics.Process()
        myProcess.StartInfo.UseShellExecute <- false
        myProcess.StartInfo.FileName <- vlc
        myProcess.StartInfo.Arguments <- (fullUrl video.url) + (settings video.start video.stop tempDir) + quit
        myProcess.StartInfo.CreateNoWindow <- true        
        let started = 
            try
                myProcess.Start()
            with | ex ->
                printfn "Problem with url %s" video.url
                false

        if not started then 
            Option.None
        else
            printfn "Started %s with pid %i" myProcess.ProcessName myProcess.Id
            myProcess.WaitForExit()

            let randFiles = 
                tempDir 
                |> Directory.GetFiles
                |> randomSubsetBySize 5
            //|> Array.map (fun x->printfn "%A" x; x)
            randFiles
            |> Array.map (fun x -> new Bitmap(x)) 
            |> Some
     
    static let emptyVideo = {url=String.Empty; start=0; stop=0}
        
    static member BuildLink uri = 
        {original=uri; embeded=emptyVideo; images=None}

    static member BuildEmbedLink (link : Link) = 
        {link with embeded = extractNameAndTime link.original}

    static member BuildImage (link : Link) =
        {link with images = transformToImage link.embeded}

    static member SaveImage saveDir (link : Link) =
        if saveDir |> Directory.Exists |> not then saveDir |> Directory.CreateDirectory |> ignore
        let fullUrl = link.embeded.url + (link.embeded.start |> string) + "_"
        match link.images with
        | Some(i) -> i |> Array.mapi (fun j x -> x.Save(Path.Combine(saveDir, fullUrl + (j |> string) + ".png")))
        | _ -> [|()|] //failwith "Problem with some or all images"