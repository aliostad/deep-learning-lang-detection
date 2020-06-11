module FsCudafy1.AddLoopBlocksGPU

open System
open Cudafy
open Cudafy.Host
open Cudafy.Translator

let N = 10

[<Cudafy>]
let addTh(thread: GThread, a: int array, b: int array, c: int array, n: int)=
    let tid = thread.threadIdx.x
    if tid < n then //You can not refer to variables such as 'N' from Cudafyed code!
         c.[tid] <- a.[tid] + b.[tid]
    ()

let execute() =
    let km = CudafyTranslator.Cudafy()
    let gpu = CudafyHost.GetDevice(Cudafy.CudafyModes.Target, Cudafy.CudafyModes.DeviceId)
    gpu.LoadModule(km)

    let a = [| for i in 0 .. N-1 -> -i |]
    let b = [| for i in 0 .. N-1 ->  i * i |]
    let c: int array = Array.zeroCreate N

    let dev_a = gpu.Allocate<int>(a)
    let dev_b = gpu.Allocate<int>(b)
    let dev_c = gpu.Allocate<int>(c)

    gpu.CopyToDevice(a, dev_a)
    gpu.CopyToDevice(b, dev_b)
    gpu.Launch(Cudafy.dim3  1, Cudafy.dim3 N, "addTh", dev_a, dev_b, dev_c, N)
    gpu.CopyFromDevice(dev_c, c)
    
    (a, b, c) |||> Seq.zip3 |> Seq.iter (fun (x, y, z) -> printfn "%i + %i = %i" x y z)

    gpu.Free(dev_a)
    gpu.Free(dev_b)
    gpu.Free(dev_c)
    ()