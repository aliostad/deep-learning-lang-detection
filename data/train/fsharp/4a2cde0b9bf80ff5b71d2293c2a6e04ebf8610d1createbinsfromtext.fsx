open System
open System.Linq
open System.IO
open System.Collections.Generic

#load @"utils.fsx"
open Utils

let files = Directory.GetFiles(@"c:\kaggle\malware\bytes\test", "*.bytes")
let outPath = @"c:\kaggle\malware\test"

createOutputDir outPath

for f in files do
    let bytes = 
        File.ReadLines(f)
            .SelectMany(
                fun l -> 
                    l.Split([|' '|], 2)
                        .Last()
                        .Split(' ')
                        .Where(fun s -> System.Char.IsLetterOrDigit(s.[0]) && System.Char.IsLetterOrDigit(s.[1]))
                        .Select(fun s -> Convert.ToByte(s, 16)))
            .ToArray()
    
    let outF = Path.ChangeExtension(Path.Combine(outPath, Path.GetFileName(f)), ".bin")
    File.WriteAllBytes(outF, bytes)


///Figure out what's missing in the destination and copy from source
let copyMissing sourcePath destPath =
    let filesOut = Directory.GetFiles(destPath).Select(fun f -> Path.GetFileNameWithoutExtension(f))
    let sources = Directory.GetFiles(sourcePath).Select(fun f-> Path.GetFileNameWithoutExtension(f))
    let missing = sources.Except(filesOut).Select(fun f -> Path.Combine(destPath, f + ".bytes")).ToList()
    let sourceMissing = sources.Except(filesOut).Select(fun f-> Path.Combine(sourcePath, f + ".bytes")).ToList()

    for f in missing.Zip(sourceMissing, (fun f s -> f, s)) do
        File.Copy(snd f, fst f)