open System;;
open System.Text.RegularExpressions;;

exception Ex of string;;

type ReadingCompressedState = { str : string; numLeft : int; times : int };;

type State =
    | ReadingUncompressed
    | InMarker of string
    | ReadingCompressed of ReadingCompressedState
;;

type InChar =
    | EOF
    | DontCare of int
    | Char of string
;;

let rexmatch pat str =
    let m = Regex.Match(str, pat) in
    if m.Groups.Count = 0 then
        []
    else
        List.tail [ for g in m.Groups -> g.Value ]
;;

let readNextChar () =
    let ch = Console.Read() in
    match ch with
    | 13 -> DontCare(ch)
    | 10 -> DontCare(ch)
    | -1 -> EOF
    | c -> Char(Convert.ToString(Convert.ToChar(c)))
;;

let rec processAllChars output state =
    match readNextChar () with
    | DontCare(dcChar) ->
        printfn "warning: invalid char! %d" dcChar;
        processAllChars output state
    | EOF -> output
    | Char(c) ->
        match state with
        | ReadingUncompressed ->
            match c with
            | "(" -> processAllChars output (InMarker "")
            | _ -> processAllChars (output + c) ReadingUncompressed
        | InMarker(markerSoFar) ->
            if c = ")" then
                match rexmatch @"^(\d+)x(\d+)$" markerSoFar with
                | [length; times] -> processAllChars output (ReadingCompressed { str = ""; numLeft = Convert.ToInt32(length); times = Convert.ToInt32(times) })
                | _ -> raise (Ex (sprintf "invalid marker! %s" markerSoFar))
            else
                processAllChars output (InMarker (markerSoFar + c))
        | ReadingCompressed(compressedState) ->
            assert (compressedState.numLeft > 0);
            assert (compressedState.times > 0);
            if compressedState.numLeft > 1 then
                processAllChars output (ReadingCompressed { str = compressedState.str + c; numLeft = compressedState.numLeft - 1; times = compressedState.times })
            else
                assert (compressedState.numLeft = 1);
                processAllChars (output + (String.replicate compressedState.times (compressedState.str + c))) ReadingUncompressed
;;

let output = processAllChars "" ReadingUncompressed in
printfn "output: %s" output;
printfn "length: %d" (String.length output);
;;
