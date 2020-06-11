module FFileProcessor
open System.IO
open System
open FMath

let readLines (filePath:string) = seq {
    use sr = new StreamReader (filePath, Text.Encoding.ASCII)
    while not sr.EndOfStream do
        yield sr.ReadLine ()
}

let processPair (a : uint64, b : uint64, sw : StreamWriter) = 
    sw.WriteLine(Gcd(a, b))
    b

let processFile fName =
    use sw = new StreamWriter (fName + ".resultf", false, Text.Encoding.ASCII)
    let nums = readLines (fName) |> Seq.map(fun s -> uint64(s)) 
    let s = Seq.reduce (fun a b -> processPair(a, b, sw)) nums
    0