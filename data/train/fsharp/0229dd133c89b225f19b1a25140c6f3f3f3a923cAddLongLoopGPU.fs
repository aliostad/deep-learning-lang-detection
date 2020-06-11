﻿namespace FsCudafy1

open System
open Cudafy
open Cudafy.Host
open Cudafy.Translator
open System.Diagnostics

type AddLongLoopGPU() =
    static let N = 32 * 1024

    [<Cudafy>]
    static member add(thread: GThread, a: int array, b: int array, c: int array, n: int) =
        let mutable tid = thread.blockIdx.x
        while tid < n do
            c.[tid] <- a.[tid] + b.[tid]
            tid <- tid + thread.gridDim.x
        ()

    static member execute() =
        let km: CudafyModule = CudafyTranslator.Cudafy(typeof<AddLongLoopGPU>)
        let gpu = CudafyHost.GetDevice(CudafyModes.Target, CudafyModes.DeviceId)
        gpu.LoadModule(km)

        let a = [| for i in 0 .. N-1 -> i|]
        let b = [| for i in 0 .. N-1 -> 2 * i|]
        let c: int array = Array.zeroCreate N

        let dev_a = gpu.Allocate<int>(a)
        let dev_b = gpu.Allocate<int>(b)
        let dev_c = gpu.Allocate<int>(c)

        let stopWatch = new Stopwatch()
        stopWatch.Start()
        gpu.CopyToDevice(a, dev_a)
        gpu.CopyToDevice(b, dev_b)
        gpu.Launch(dim3  128, dim3 1, "add", dev_a, dev_b, dev_c, N)
        gpu.CopyFromDevice(dev_c, c)
        stopWatch.Stop()
        let timeSpan = stopWatch.Elapsed
        printfn "Add long loop on GPU: %f (ms)" timeSpan.TotalMilliseconds

        let exceptions = 
            [| 0 .. N-1|]
            |> Array.Parallel.choose(fun i ->
                                         match a.[i] + b.[i] with
                                         | x when x = c.[i] -> None
                                         | _ -> Some(i))
        printfn "Add long loop on GPU: %i exceptions." exceptions.Length

        gpu.Free(dev_a)
        gpu.Free(dev_b)
        gpu.Free(dev_c)
        ()