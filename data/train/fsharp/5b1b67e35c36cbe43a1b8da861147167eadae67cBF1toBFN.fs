module BF1toBFN

open System

let converter (code : string) n =
    
    if n <= 1 then failwith "Size must be greater than 1."

    let repeat s n   = String.replicate n s
    let left         = repeat "<"
    let right        = repeat ">"
    
    let shiftResL n  = sprintf "[-%s+%s]" (left n) (right n)
    let shiftResR n  = sprintf "[-%s+%s]" (right n) (left n)

    let copy         = "[-<+<+>>]<<[->>+<<]>>"
    let isZero       = "<+>[<->[-]]"
    let is255        = "<+>+[<->[-]]"
    
    let iterIncr     = sprintf ">>+%s<%s<%s" copy isZero (shiftResL 3)
    let iterDecr     = sprintf ">>-%s<%s<%s" copy is255  (shiftResL 3)
    let iterBracket  = sprintf ">>%s<%s<%s"  copy isZero (shiftResL 3)

    let partIncr     = sprintf "<<<[-%s]" iterIncr
    let partDecr     = sprintf "<<<[-%s]" iterDecr
    let partBracket  = sprintf "<<<[-%s]" iterBracket

    let length       = 3*n-3

    let incr         = sprintf "%s%s<<<[->>+<<]%s" iterIncr (repeat partIncr <| n-2) (right length)
    let decr         = sprintf "%s%s<<<[->>-<<]%s" iterDecr (repeat partDecr <| n-2) (right length)
    
    let openBracket  = sprintf "%s%s<<<[->>%s<%s<%s]%s-[+"  iterBracket (repeat partBracket <| n-2) 
                                                            copy isZero (shiftResR length) (right length)
    let closeBracket = sprintf "%s%s<<<[->>%s<%s<%s]%s-]"   iterBracket (repeat partBracket <| n-2) 
                                                            copy isZero (shiftResR length) (right length)

    let read         = sprintf "%s%s,<<" (left <| 3*n-5) (repeat ",>>>" <| n-1)
    let write        = sprintf "%s%s.<<" (left <| 3*n-5) (repeat ".>>>" <| n-1)

    let left         = left  <| 3*n
    let right        = right <| 3*n

    let convertChar c = match c with
                        | ','  -> read
                        | '.'  -> write
                        | '+'  -> incr
                        | '-'  -> decr
                        | '<'  -> left
                        | '>'  -> right
                        | '['  -> openBracket
                        | ']'  -> closeBracket
                        | ' '  -> ""
                        | '\n' -> ""
                        | '\t' -> ""
                        | _    -> failwithf "Incorrect char %c." c

    let rec optimization (s : string) =
        let newS = s.Replace("><","").Replace("<>","")
        if newS.Length = s.Length then s else optimization newS
                        
    code.ToCharArray()
    |> Array.map convertChar
    |> String.Concat
    |> optimization
    
[<EntryPoint>]
let main _ =
    printfn "Input code:"
    let code = Console.ReadLine()
    printfn "Input size:"
    let size = int <| Console.ReadLine()
    printfn "%s" <| converter code size
    0