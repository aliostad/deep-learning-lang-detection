namespace FsCudafy1

open System
open Cudafy
open Cudafy.Host
open Cudafy.Translator

[<Measure>] type bytes
[<Measure>] type MB

type CopyTimedGPU() =
    let bytesPerMB: float<bytes/MB> = 1024.0 * 1024.0<bytes/MB>
    let size = 64 * 1024 * 1024
    let _gpu = CudafyHost.GetDevice(CudafyModes.Target, CudafyModes.DeviceId)

    member this.CudaMallocTest(size: int, up:bool) =
        let a: int array = Array.zeroCreate size
        let dev_a = _gpu.Allocate<int>(size)
        
        _gpu.StartTimer()
        for i in 0 .. 99 do
            if up then
                _gpu.CopyToDevice(a, dev_a)
            else
                _gpu.CopyFromDevice(dev_a, a)
        let elapsedTime = _gpu.StopTimer()

        _gpu.FreeAll()
        GC.Collect()

        elapsedTime

    member this.CudaHostAllocTest(size: int, up:bool) =
        let ap = _gpu.HostAllocate<int>(size) // Pinned memory allocation.
        let dev_a = _gpu.Allocate<int>(size)

        _gpu.StartTimer()
        for i in 0 .. 99 do
            if up then
                _gpu.CopyToDevice(ap, 0, dev_a, 0, size)
            else
                _gpu.CopyFromDevice(dev_a, 0, ap, 0, size)
        let elapsedTime = _gpu.StopTimer()

        _gpu.FreeAll()
        _gpu.HostFree(ap)
        GC.Collect()
        elapsedTime

    member this.CudaHostAllocCopyTest(size: int, up:bool) =
        let ap = _gpu.HostAllocate<int>(size)
        let bp = _gpu.HostAllocate<int>(size)
        let dev_a = _gpu.Allocate<int>(size)
        let host_a:int array = Array.zeroCreate(size)

        _gpu.StartTimer()
        for i in 0 .. 49 do // Using stream id 1, Using default stream id 0 will cause GPU to crash.
            if up then
                ap.Write(host_a)
                _gpu.CopyToDeviceAsync(ap, 0, dev_a, 0, size, 1)
                bp.Write(host_a)
                _gpu.CopyToDeviceAsync(bp, 0, dev_a, 0, size, 1)
            else
                _gpu.CopyFromDeviceAsync(dev_a, 0, ap, 0, size, 1)
                bp.Read(host_a)
                _gpu.CopyFromDeviceAsync(dev_a, 0, bp, 0, size, 1)
                bp.Read(host_a)
        _gpu.SynchronizeStream(1)
        let elapsedTime = _gpu.StopTimer()

        _gpu.FreeAll()
        _gpu.HostFree(ap)
        _gpu.HostFree(bp)
        GC.Collect()
        elapsedTime

    member this.Execute() =
        let size_in_MB = 100.0 * float (size * sizeof<int>) * 1.0<bytes> / bytesPerMB
        
        let props = _gpu.GetDeviceProperties()
        
        Console.WriteLine props.Name
        printfn "Using %soptimized driver." (if props.HighPerformanceDriver then "" else "non-")

        let elapsedTime = this.CudaMallocTest(size, true)
        printfn "Time using cudaMalloc: %f ms" elapsedTime
        printfn "\tMB/s during copy up: %f" (float32 size_in_MB / (elapsedTime / 1000.0f))

        let elapsedTime = this.CudaMallocTest(size, false)
        printfn "Time using cudaMalloc: %f ms" elapsedTime
        printfn "\tMB/s during copy down: %f" (float32 size_in_MB / (elapsedTime / 1000.0f))


        let elapsedTime = this.CudaHostAllocTest(size, true)
        printfn "Time using cudaHostAlloc %f ms" elapsedTime
        printfn "\tMB/s during copy up: %f" (float32 size_in_MB / (elapsedTime / 1000.0f))

        let elapsedTime = this.CudaHostAllocTest(size, false)
        printfn "Time using cudaHostAlloc %f ms" elapsedTime
        printfn "\tMB/s during copy down: %f" (float32 size_in_MB / (elapsedTime / 1000.0f))

        //#region  Does not work if stream id 0 was chosen. -> Not working with stream id 1.
        (**
        let elapsedTime = this.CudaHostAllocCopyTest(size, true)
        printfn "Time using cudaHostAlloc + async copy %f ms" elapsedTime
        printfn "\tMB/s during copy up: %f" (float32 size_in_MB / (elapsedTime / 1000.0f))

        let elapsedTime = this.CudaHostAllocCopyTest(size, false)
        printfn "Time using cudaHostAlloc + async copy %f ms" elapsedTime
        printfn "\tMB/s during copy down: %f" (float32 size_in_MB / (elapsedTime / 1000.0f))
        **)
        //#endregion