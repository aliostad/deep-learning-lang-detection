module PEFS.Problem_0010

// problem 以下の素数の和を返す
open PEFS.Library
let solve (problem : int) =
    let cp = System.Diagnostics.Process.GetCurrentProcess()
    primes problem
//    |> Seq.fold(fun (s:int)(n:int) ->
//        let m = cp.VirtualMemorySize64
//        if s % 1024 = 0 then printfn "%d" m else ()
//        s + 1) 0
    |> Seq.fold(fun (s:decimal)(n:int) -> s + (decimal(n))) 0M
//    |> Seq.map(fun n -> n |> decimal)
//    |> Seq.sum

let run () =
//    solve (200*10000)
    solve (2000*10000)
