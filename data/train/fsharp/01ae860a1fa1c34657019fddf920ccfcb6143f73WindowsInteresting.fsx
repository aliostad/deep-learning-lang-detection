open System
open System.IO

let source = 
    Environment.UserName
    |> sprintf """C:\Users\%s\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets""" 
    |> DirectoryInfo

type FileSystemInfo with
    static member getFullName (info:FileSystemInfo) = info.FullName

// из-за проблем с dispose решил все-таки слить все вместе, безопаснее
let checkDimension file = 
    try 
        use image = file |> Drawing.Image.FromFile
        (image.Width, image.Height)
        |> function 1920, 1080 | 1080, 1920 -> true | _ -> false
        |> Some
    with 
        _ -> None

let sourceFiles = 
    source
    |> FileSystemInfo.getFullName
    |> Directory.GetFiles
    |> Seq.filter (checkDimension >> (=) (Some true))
    |> Seq.map FileInfo
    |> List.ofSeq

let destination = """C:\WindowsInteresting""" |> DirectoryInfo

let changeDirectory newDirectory path = 
    path
    |> Path.GetFileName
    |> fun p -> Path.Combine (newDirectory, p)

let changeExtension extension path = Path.ChangeExtension (path, extension)

let copyFiles () =
    let copyImage file = File.Copy (file |> FileSystemInfo.getFullName, file.FullName |> changeDirectory destination.FullName |> changeExtension ".jpg", true) 
    if Directory.Exists destination.FullName |> not 
        then Directory.CreateDirectory destination.FullName |> ignore; destination.Refresh()
    sourceFiles |> List.iter copyImage

//copyFiles ()

let oldDestination = """C:\Assets""" |> DirectoryInfo

let removeNotImages () = 
    oldDestination
    |> string
    |> Directory.GetFiles
    |> Seq.filter (checkDimension >> (=) None)
    |> Seq.iter File.Delete

let removeBadImages () = 
    oldDestination
    |> string
    |> Directory.GetFiles
    |> Seq.filter (checkDimension >> (=) (Some false))
    |> Seq.iter File.Delete

let changeExtensionToJpg () =
    oldDestination
    |> string
    |> Directory.GetFiles
    |> Seq.map FileInfo
    |> Seq.iter (fun p -> File.Move(p.FullName, p.FullName |> changeExtension ".jpg"))

//removeNotImages()
//removeBadImages()
//changeExtensionToJpg()