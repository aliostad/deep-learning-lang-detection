namespace CryptoCurrencyFun
open System
open System.Diagnostics
open System.Collections.Generic
open NLog
open CryptoCurrencyFun.Messages

type ErrorHandler =
    | Propagate
    | Ignore
    | Custom of (Exception -> array<byte> -> unit)

exception BlockParserException of (array<byte> * Exception)

type internal MessageResult =
    | Message of Block
    | Error of Exception

type BlockParserStream private (magicNumber, byteStream: seq<byte>, initOffSet) =
    let logger = LogManager.GetLogger("BlockParser")

    let blockParsedEvent = new Event<Block>()
    let streamEventEvent = new Event<Unit>()
    let mutable errorHandler = Propagate

    let getErrorHandler() =
        match errorHandler with
        | Propagate -> fun exc message -> raise(BlockParserException(message, exc))
        | Ignore -> fun _ _ -> ()
        | Custom func -> func


    let readMessageHeader (e: IEnumerator<byte>) =
        let numberBytes = Enumerator.take 4 e
        if numberBytes.Length = 0 then -1
        else
            let number, _ = Conversion.bytesToUInt32 0 numberBytes
            let gotMagicNumber = magicNumber = number
            if not gotMagicNumber then failwith "Error expected magicNumber, but it wasn't there"
            let bytesInBlock, _ = Enumerator.take 4 e |> Conversion.bytesToInt32 0
            bytesInBlock

    let readMessageHandleError initOffSet messageBuffer =
        try
            let message, _ = Block.Parse initOffSet 0 messageBuffer
            Message message
        with exc ->
            Error exc

    let readMessages initOffSet firstMessageIndex lastMessageIndex messageErrorHandler (byteStream: seq<byte>) =
        seq { use e = EnumeratorObserver.Create(byteStream.GetEnumerator()) 
              let messagesProcessed = ref 0
              let offSet = ref initOffSet
              while e.MoreAvailable && !messagesProcessed < lastMessageIndex do
                  let bytesToProcess = readMessageHeader e
                  offSet := !offSet + 8L
                  if bytesToProcess > 0 then
                      if firstMessageIndex <= !messagesProcessed then
                          let messageBuffer = Enumerator.take bytesToProcess e
                          match readMessageHandleError !offSet messageBuffer with
                          | Message message -> yield message
                          | Error exc -> messageErrorHandler exc messageBuffer  
                      else
                          Enumerator.skip bytesToProcess e
                      offSet := !offSet + int64 bytesToProcess + 8L
                      incr messagesProcessed }
        
    let readAllMessages initOffSet messageErrorHandler (byteStream: seq<byte>) =
        seq { use e = EnumeratorObserver.Create(byteStream.GetEnumerator()) 
              let offSet = ref initOffSet
              while e.MoreAvailable do
                  let bytesToProcess = readMessageHeader e
                  if bytesToProcess > 0 then
                      let messageBuffer = Enumerator.take bytesToProcess e
                      match readMessageHandleError !offSet messageBuffer with
                      | Message message -> yield message
                      | Error exc -> messageErrorHandler exc messageBuffer 
                  offSet := !offSet + int64 bytesToProcess + 8L }
        
    member __.NewBlock = blockParsedEvent.Publish
    member __.StreamEnded = streamEventEvent.Publish
    member __.ErrorHandler
        with get() = errorHandler
        and  set x = errorHandler <- x
    member __.StartPush() = 
        let blocks = readAllMessages initOffSet (getErrorHandler()) byteStream
        for block in blocks do 
            blockParsedEvent.Trigger block
        streamEventEvent.Trigger()
    member __.StartPushBetween startIndex endIndex = 
        let blocks = readMessages initOffSet startIndex endIndex (getErrorHandler()) byteStream
        for block in blocks do 
            blockParsedEvent.Trigger block
        streamEventEvent.Trigger()
    member __.Pull() = 
        readAllMessages initOffSet (getErrorHandler()) byteStream
    member __.PullBetween startIndex endIndex = 
        readMessages initOffSet startIndex endIndex (getErrorHandler()) byteStream

    static member FromFile (magicNumber, file: string, ?initOffSet) =
        let initOffSet = defaultArg initOffSet 0L
        let stream = File.getByteStream file
        new BlockParserStream(magicNumber, stream, initOffSet)
    static member FromDirectory (magicNumber, dir: string, fileSpec: string, ?initOffSet) =
        let initOffSet = defaultArg initOffSet 0L
        // TODO file spec is ignored
        let stream = BitcoinDataDir.streamFromOffSet dir initOffSet 
        new BlockParserStream(magicNumber, stream, initOffSet)

