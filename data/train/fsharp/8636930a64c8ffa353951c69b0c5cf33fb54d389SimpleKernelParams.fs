module FsCudafy1.SimpleKernelParams

open System
open Cudafy.Host
open Cudafy.Translator

[<Cudafy.Cudafy>]
let add a b (c: int array) =
    c.[0] <- a + b
    ()

[<Cudafy.Cudafy>]
let sub a b (c: int array) =
    c.[0] <- a - b
    ()

let execute() =
    let km = CudafyTranslator.Cudafy()
    let gpu = CudafyHost.GetDevice(Cudafy.CudafyModes.Target, Cudafy.CudafyModes.DeviceId)
    gpu.LoadModule(km)

    let dev_c = gpu.Allocate<int>()
    gpu.Launch(Cudafy.dim3  1, Cudafy.dim3 1, "add", 2, 7, dev_c)
    let c1 = gpu.CopyFromDevice(dev_c) 
    printfn " 2 + 7 = %i" c1

    gpu.Launch(Cudafy.dim3  1, Cudafy.dim3 1, "sub", 2, 7, dev_c)
    let c2 = gpu.CopyFromDevice(dev_c)
    printfn " 2 - 7 = %i" c2
    gpu.Free(dev_c)
    ()