namespace Nomad.Files

open Nomad
open Nomad.Errors
open System.IO

type FilePart =
    |Complete
    |Part of int64 * int64

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module FilePart =
    let getLengthOrDefault defaultLength filePart =
        match filePart with
        |Complete -> defaultLength
        |Part (_, end') -> min defaultLength end'

    let getStartOrDefault maxStart filePart =
        match filePart with
        |Complete -> 0L
        |Part (start', _) -> min maxStart start'

module HttpHandler =
    [<Literal>]
    let DEFAULT_BUFFER_SIZE = 262144L

    let private writePartialFile filePart file = 
        handler {
            use fs = new System.IO.FileStream (file, System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read)
            let end' = FilePart.getLengthOrDefault fs.Length filePart
            let rec writeFileRec pos = handler {
                let dataLength = int <| min DEFAULT_BUFFER_SIZE (end'-pos)
                match dataLength with
                |x when x <= 0 -> return ()
                |_ ->
                    let! data  = HttpHandler.liftAsync (fs.AsyncRead dataLength)
                    do! HttpHandler.writeBytes data
                    return! writeFileRec (pos + DEFAULT_BUFFER_SIZE)
                }
            return! writeFileRec (FilePart.getStartOrDefault fs.Length filePart)
        }

    let writeFile file = writePartialFile Complete file

    let writeFileRange start' end' file = writePartialFile (Part (start', end')) file

    let writeFileRespectingRangeHeaders file = 
        HttpHandler.getReqHeaders
        >>= (fun x -> 
            match HttpHeaders.tryParseRangeHeader x with
            |Ok range -> 
                match range with
                |StartOnlyRange ("bytes", start) -> writeFileRange start (start + DEFAULT_BUFFER_SIZE) file
                |StartEndRanges ("bytes", startEnds) -> 
                    startEnds
                    |> List.map (fun (s, e) -> writeFileRange s e file)
                    |> HttpHandler.sequenceIgnore
                |_ -> HttpHandler.rangeNotSatisfiable
            |Error err -> writeFile file)

module Supplemental =
    let withByteRangeHeader defaultSize noRangeHandler rangeQualifiedHandler =
        HttpHandler.getReqHeaders
        >>= (fun x -> 
            match HttpHeaders.tryParseRangeHeader x with
            |Ok range -> 
                match range with
                |StartOnlyRange ("bytes", start) -> rangeQualifiedHandler start (start + defaultSize)
                |StartEndRanges ("bytes", startEnds) -> 
                    startEnds
                    |> List.map (fun (s, e) -> rangeQualifiedHandler s e)
                    |> HttpHandler.sequenceIgnore
                |_ -> HttpHandler.rangeNotSatisfiable
            |Error err -> noRangeHandler)