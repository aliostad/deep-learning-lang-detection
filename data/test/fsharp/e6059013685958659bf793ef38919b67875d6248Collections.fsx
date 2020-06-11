#load "Testing.fsx"
#load "../src/FSock/Collections.fs"

open System
module T = Testing

[<Sealed>]
type RingBuffer0<'T>(cap: int) =
    let data = ResizeArray<'T>()

    let free () = cap - data.Count

    member rb.Add(d: 'T[], o: int, c: int) =
        let tr = min (free ()) c
        data.AddRange(ArraySegment(d, o, tr))
        tr

    member rb.Take(d: 'T[], o: int, c: int) =
        let tr = min data.Count c
        data.CopyTo(0, d, o, tr)
        data.RemoveRange(0, tr)
        tr

let testRingBuffer () =
    let b1 = FSock.RingBuffer<byte>(16)
    let b2 = RingBuffer0<byte>(16)
    for (b, o, c) in T.byteRangeDomain do
        if T.randBool () then
            let r1 = b1.Add(b, o, c)
            let r2 = b2.Add(b, o, c)
            T.testEqual "RingBuffer" r1 r2
        else
            let bc = Array.copy b
            let r1 = b1.Take(b, o, c)
            let r2 = b2.Take(bc, o, c)
            T.testEqual "RingBuffer" r1 r2
            T.testEqual "RingBuffer" b bc
    printfn "RingBuffer: OK"

let all () =
    testRingBuffer ()
