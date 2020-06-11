//
// Basic performance test comparing use of System.Array.Copy vs loop-and-copy
//   for copying from one array to another, when types match
// On my machine, overall message is: "The more data is being copied, the better Array.Copy performs (relatively)".
//
//  Make sure to compile and run with optimizations.
//

open System.Diagnostics

let timeit f x = Stopwatch.StartNew() |> (fun sw -> (f x, sw.Elapsed))

type BigVal =
    struct
        val A: float
        val B: float
        val C: float
        val D: float
        val E: float
        val F: float
        val G: float
        val H: float
        val I: float
        val J: float
        val K: float
        val L: float
        val M: float
        val N: float
        val O: float
        val P: float
        val Q: float
        val R: float
        val S: float
        val T: float
    end

let test<'t> label generator arraySize loopMax = 
    let sourceArray : 't array = Array.init arraySize generator

    let copy () =
        let mutable result = Unchecked.defaultof<'t>
        for i in 0 .. loopMax do
            let destArray : 't array = Array.zeroCreate arraySize
            System.Array.Copy(sourceArray, 0, destArray, 0, arraySize)
            result <- destArray.[arraySize - 1]
        result

    let loop () =
        let mutable result = Unchecked.defaultof<'t>
        for i in 0 .. loopMax do
            let destArray : 't array = Array.zeroCreate arraySize
            let max = arraySize - 1
            for j = 0 to max do
                destArray.[j] <- sourceArray.[j]
            result <- destArray.[arraySize - 1]
        result

    printfn "Array size %d, %s" arraySize label
    let (_, time) = timeit copy ()
    printfn "  Array.Copy: %O sec" time.TotalSeconds

    let (_, time1) = timeit loop ()
    printfn "  Loop copy: %O sec" time1.TotalSeconds


let testSmallValTys () =
    let label = "small value type"
    test<int> label (id) 1000 5000000
    test<int> label (id) 10 100000000
    test<int> label (id) 35 100000000

let testLargeValTys () =
    let label = "large value type"
    let bigId _ = BigVal()
    test<BigVal> label bigId 1000 50000
    test<BigVal> label bigId 10 10000000
    test<BigVal> label bigId 35 3000000


testSmallValTys ()
testLargeValTys ()    