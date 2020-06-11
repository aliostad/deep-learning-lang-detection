module RZ.Net

open System
open System.Net
open System.IO

type NetIO<'a> = NetIO of (('a -> unit) -> unit)

module NetIO =
    let map (f: 'a -> 'b) (NetIO m) = NetIO <| fun f' -> m (f >> f')
    let fork (handler: 'a -> unit) (NetIO m) = m handler
    let execute (f: 'a -> 'b) (NetIO m) =
        let mutable result = Unchecked.defaultof<'b>
        let resultGetter = fun x -> result <- f x
        m resultGetter
        result


let private openHttpTextStream(uri: Uri) =
    NetIO <|
    fun handler ->
        use response = WebRequest.CreateHttp(uri).GetResponse()
        use stream = new StreamReader(response.GetResponseStream())
        handler(stream)

let openHttp :Uri -> string[] = fun uri ->
    let streamToArray (stream: StreamReader) =
        seq {
          while not stream.EndOfStream do
            yield stream.ReadLine()
        } |> Seq.toArray

    uri |> openHttpTextStream
        |> NetIO.execute streamToArray

let readHttpText: Uri -> string = openHttpTextStream >> NetIO.execute (fun s -> s.ReadToEnd())

[<Literal>]
let private BufferSize = 64_000

let saveHttpTo (target: string, source: Uri) =
    use response = WebRequest.CreateHttp(source).GetResponse()
    use ss = response.GetResponseStream()
    use ts = File.Create(target, BufferSize)

    let buffer = Array.CreateInstance( typeof<byte>, BufferSize ) :?> byte[]

    let mutable n = ss.Read(buffer, 0, BufferSize)
    while n > 0 do
      ts.Write(buffer, 0, n)
      n <- ss.Read(buffer, 0, BufferSize)
