open System.IO.Compression
open System.IO
open System
open System.Text

let str = "美元，美元，美元，美元，美元，美元，美元，美元，美元，美元，美元，美元，美元，"

let data = Encoding.UTF8.GetBytes(str)

printfn "%d" data.Length


let compress (input: byte[]) =
    use ms = new MemoryStream(input)
    use ms2 = new MemoryStream()
    use gzs = new GZipStream(ms2,CompressionMode.Compress) 
    ms.CopyTo(gzs)
    gzs.Flush()
    ms2.Position 0
    ms2.ToArray()


let data2 =compress data

printfn "%d" data2.Length
