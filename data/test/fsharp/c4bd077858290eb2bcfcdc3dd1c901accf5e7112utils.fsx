open System
open System.Linq
open System.IO
open System.Collections.Generic

let createOutputDir outPath =
    if Directory.Exists outPath
    then 
        Directory.Delete(outPath, true)
    Directory.CreateDirectory outPath

let getFileList inpPath filter = 
    Directory.GetFiles(inpPath, filter)

let parseLabels labels =
    let filesClasses = 
        File.ReadLines(labels)
            .Skip(1)
            .Select(
                fun l -> 
                    let s = l.Split(',')
                    (s.[0].Substring(1, s.[0].Length - 2), Int32.Parse(s.[1])))
    filesClasses.ToDictionary((fun (a, b) -> a), (fun (a, b) -> b))

let defile file =
    Path.GetFileNameWithoutExtension file

let copyOrMove outPath (fileList : List<string>) isMove =
    for i in fileList do
        if not isMove then
            File.Copy(i, Path.Combine(outPath, Path.GetFileName(i)))
        else
            File.Move(i, Path.Combine(outPath, Path.GetFileName(i)))

let copyFile outPath file ext =
    let fileName = if ext <> String.Empty then Path.ChangeExtension(file, ext) else file
    File.Copy(file, Path.Combine(outPath, Path.GetFileName(fileName)))

let saveFile (data : byte []) outPath file ext = 
    let fileName = if ext <> String.Empty then Path.ChangeExtension(file, ext) else file
    File.WriteAllBytes(Path.Combine(outPath, Path.GetFileName(fileName)), data)

let saveCsv (data : string []) outPath file ext =
    let fileName = if ext <> String.Empty then Path.ChangeExtension(file, ext) else file
    File.WriteAllLines(Path.Combine(outPath, Path.GetFileName(fileName)), data)

let toInList (data : byte []) =
    let conv = 
        seq{
            for i = 0 to data.Length / 4 - 1 do
                yield BitConverter.ToInt32(data, i * 4)
        }

    conv.ToList()
