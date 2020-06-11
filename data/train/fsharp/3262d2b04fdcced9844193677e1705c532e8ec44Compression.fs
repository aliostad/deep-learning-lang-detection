module FotM.Hephaestus.Compression

open System
open System.IO
open System.IO.Compression
open System.Text

let zip (str: string) =
    let bytes = Encoding.UTF8.GetBytes(str)
    use msi = new MemoryStream(bytes)
    use mso = new MemoryStream()
    (
        use gs = new GZipStream(mso, CompressionMode.Compress)
        msi.CopyTo(gs)
    )
    mso.ToArray()

let unzip (bytes: byte array) = 
    use msi = new MemoryStream(bytes)
    use mso = new MemoryStream()
    (
        use gs = new GZipStream(msi, CompressionMode.Decompress)
        gs.CopyTo(mso)
    )
    Encoding.UTF8.GetString(mso.ToArray())

let zipToBase64(str: string) =
    let zipped = zip str
    Convert.ToBase64String zipped

let unzipFromBase64(base64zip: string) =
    let zipped = Convert.FromBase64String base64zip
    unzip zipped