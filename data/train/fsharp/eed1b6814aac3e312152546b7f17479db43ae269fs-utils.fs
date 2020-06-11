namespace Utils

[<AutoOpen>]
[<RequireQualifiedAccess>]


module Process =
  open System
  open System.Diagnostics 
  let execProcess (infoAction : ProcessStartInfo -> unit) : int = 
    use p = new Process() 
    infoAction p.StartInfo 
    p.Start() |> ignore 
    p.WaitForExit() 
    p.ExitCode

module Tasks =
  open System
  open System.Diagnostics 
  let code02 =  
    Process.execProcess (fun info ->   
      info.FileName <- "net.exe"   
      info.Arguments <- "use z: \\\\192.168.1.9\\Volume_1"
    ) 
    //|> printfn "Code02 return: %i"  
  let code03 =  
    //System.IO.Directory.GetFiles("z:\\", "*.*") |> Array.map System.IO.Path.GetFileName |> Array.iter (printfn "%s")
    Process.execProcess (fun info ->   
      info.FileName <- "cmd"   
      info.Arguments <- "/c dir z: >log.log"
    ) 
    // |> printfn "Code03 return: %i"  
  let code04 =                                                                                          
    Process.execProcess (fun info ->   
      info.FileName <- "ping.exe"   
      info.Arguments <- "192.168.1.9 -n 1"
    )
  let code01 =  
    Process.execProcess (fun info ->   
      info.FileName <- "net.exe"   
      info.Arguments <- "use z: /delete"
    ) 

//now for tests
module Files =
  open System
  open System.Diagnostics 
  let x = 1
  let y = 2

module BinParserModule =
  open System.IO
    type ParseResult<'a> =
        | Success of 'a * BinaryReader
        | Failure of int64 * string
    type BinParser<'a> =
        | BinParser of (BinaryReader -> ParseResult<'a>)   
    with
        member this.Function = 
            match this with
                 BinParser pFunc -> pFunc                 
    end

    type BinParserBuilder() =
        member this.Bind(p:BinParser<'a>,rest:'a -> BinParser<'b>) : BinParser<'b> = 
            BinParser(fun i -> match p.Function(i) with
                                                        | Success(r:'a,i2) -> ((rest r).Function i2) 
                                                        | Failure(offset,description) -> Failure(offset,description))
        member this.Return(x) = BinParser(fun i -> Success(x,i))


    let IOExceptionHandlingWrapper(f:BinaryReader -> ParseResult<'a>) =
        fun i -> 
        try f(i) with
                     (e & :? IOException ) -> Failure(i.BaseStream.Position,e.Message)

    let RByte = 
        BinParser(IOExceptionHandlingWrapper( fun (i:BinaryReader) -> Success(i.ReadByte(),i)))
                   
    let RShort =
        BinParser(IOExceptionHandlingWrapper( fun (i:BinaryReader) -> Success(i.ReadInt16(),i))) 

    let RInt =
        BinParser(IOExceptionHandlingWrapper( fun (i:BinaryReader) -> Success(i.ReadInt32(),i)))

    let AByte(b:byte) =
        BinParser(IOExceptionHandlingWrapper( fun (i:BinaryReader) -> 
            let rB = i.ReadByte() in
                if (rB = b) then
                    Success(byte(rB),i)
                else
                    Failure(i.BaseStream.Position, System.String.Format("Expecting {0},got {1}",b,rB))))

    let ParsingStep (func:'a -> BinParser<'b>) (accumulatedResult:ParseResult<'b list>) currentSeqItem =
        match accumulatedResult with
            | Success(result,inp) ->
                match ((func currentSeqItem).Function inp) with
                    | Success(result2,inp2) -> Success(result2::result,inp2)
                    | Failure(offset,description) -> Failure(offset,description)
            | Failure(offset,description) -> Failure(offset,description) 

    let FixedSequence (s:seq<'b>,parser:BinParser<'a>) =   
        BinParser(fun i ->
            match  (Seq.fold (ParsingStep (fun _ -> parser)) (Success([],i)) s) with
                | Success(result,input) -> Success(List.rev(result),input)
                | Failure(offset,description) -> Failure(offset,description))
