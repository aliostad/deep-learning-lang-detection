module Util

type System.String with
    member s.WordsArray =
        s.Split([|','; ';'; '\t'|])
    member s.WordsArrayTrim =
        s.WordsArray |> Array.map (fun s -> s.Trim())
    member s.WordsList =
        s.WordsArray |> List.ofArray
    member s.WordsListTrim =
        s.WordsArrayTrim |> List.ofArray

let copyToFolder fromFolder toFolder (_files: string) =
    let files = _files.WordsListTrim
    if not (System.IO.Directory.Exists toFolder) then 
        System.IO.Directory.CreateDirectory toFolder |> ignore
    List.iter (fun s -> System.IO.File.Copy(fromFolder + "\\" + s, toFolder + "\\" + s)) files

let backUpToFolder toPath =
    let projectPath = 
        @"G:\NetWorkDrive\Dropbox\dev\F#\openTk\Tutorial\fsOpenTkTurorial\fsOpenTkTurorial"
    let shaderPath =
        projectPath + @"\Components\Shaders"
    let backupPath = projectPath + @"\Backup\" + toPath
    "MainWindow.fs, Program.fs" |> copyToFolder projectPath backupPath
    "fragmentShader.vert, vertexShader.vert" |> copyToFolder shaderPath backupPath
//Test
//copyToFolder @"i:\tmp\a" @"i:\tmp\b" "a.txt, b.txt"
