namespace FsCudafy1

open System
open Cudafy
open Cudafy.Host
open Cudafy.Translator
open MathNet.Numerics.Random
open System.Threading.Tasks

type BasicStreamGPU() =
    [<Literal>] 
    static let N = 1048576 // 1024 * 1024
    static let full_data_size = N * 20
    static let rng = MersenneTwister()

    [<Cudafy>]
    static member ExampleKernel(thread: GThread, a: int array, b: int array, c: int array) =
        let idx = thread.threadIdx.x * thread.blockIdx.x * thread.blockDim.x
        if idx < N then
            let idx1 = (idx + 1) % 256
            let idx2 = (idx + 2) % 256
            let aS = float32 (a.[idx] + a.[idx1] + a.[idx2]) / 3.0f
            let bS = float32 (b.[idx] + b.[idx1] + b.[idx2]) / 3.0f
            c.[idx] <- int (aS + bS) / 2
        ()

    static member HostKernel(chunkId: int, idx: int, a: int array, b: int array) =
        let idx0 = chunkId * N + idx
        let idx1 = chunkId * N + (idx + 1) % 256
        let idx2 = chunkId * N + (idx + 2) % 256
        let aS = float32 (a.[idx0] + a.[idx1] + a.[idx2]) / 3.0f
        let bS = float32 (b.[idx0] + b.[idx1] + b.[idx2]) / 3.0f
        int (aS + bS) / 2

    static member Execute() =
        let km = CudafyTranslator.Cudafy()
        let gpu = CudafyHost.GetDevice(CudafyModes.Target, CudafyModes.DeviceId)
        gpu.LoadModule km

        let dev_a0 = gpu.Allocate<int>(N)
        let dev_b0 = gpu.Allocate<int>(N)
        let dev_c0 = gpu.Allocate<int>(N)
        let dev_a1 = gpu.Allocate<int>(N)
        let dev_b1 = gpu.Allocate<int>(N)
        let dev_c1 = gpu.Allocate<int>(N)

        let host_ap = gpu.HostAllocate<int>(full_data_size)
        let host_bp = gpu.HostAllocate<int>(full_data_size)
        let host_cp = gpu.HostAllocate<int>(full_data_size)

        for i in 0 .. full_data_size-1 do
            host_ap.Set(i, rng.Next(1024 * 1024))
            host_bp.Set(i, rng.Next(1024 * 1024))

        gpu.StartTimer()
        for i in 0 .. N * 2 .. full_data_size-1 do
            gpu.CopyToDeviceAsync(host_ap, i, dev_a0, 0, N, 1)
            gpu.CopyToDeviceAsync(host_ap, i+N, dev_a1, 0, N, 2)
            gpu.CopyToDeviceAsync(host_bp, i, dev_b0, 0, N, 1)
            gpu.CopyToDeviceAsync(host_bp, i+N, dev_b1, 0, N, 2)
            gpu.LaunchAsync(dim3 (N/256), dim3 256, 1, "ExampleKernel", dev_a0, dev_b0, dev_c0)
            gpu.LaunchAsync(dim3 (N/256), dim3 256, 2, "ExampleKernel", dev_a1, dev_b1, dev_c1)
            gpu.CopyFromDeviceAsync(dev_c0, 0, host_cp, i, N, 1)
            gpu.CopyFromDeviceAsync(dev_c1, 0, host_cp, i+N, N, 2)
        gpu.SynchronizeStream(1)
        gpu.SynchronizeStream(2)
        let elapsedTime = gpu.StopTimer()
        printfn "2 streams in parallel: %f ms" elapsedTime

        printfn "Now verifying the code..."
        let host_a = Array.zeroCreate(full_data_size)
        let host_b = Array.zeroCreate(full_data_size)
        let host_c = Array.zeroCreate(full_data_size)

        GPGPU.CopyOnHost(host_ap, 0, host_a, 0, full_data_size)
        GPGPU.CopyOnHost(host_bp, 0, host_b, 0, full_data_size)
        GPGPU.CopyOnHost(host_cp, 0, host_c, 0, full_data_size)

        let errors = Array.zeroCreate 20
        Parallel.For(0, 20,
            (fun ci ->
                for j in 0 .. N-1 do
                    let dij = BasicStreamGPU.HostKernel(ci, j, host_a, host_b)
                    let diff = dij - host_c.[ci * N + j]
                    if diff > 1 && diff < -1   then errors.[ci] <- errors.[ci] + 1
                )) |> ignore
        let total_errors = errors |> Array.sum
        printfn "Mismatches larger than 1 : %i" total_errors

        gpu.FreeAll()
        gpu.HostFree(host_ap)
        gpu.HostFree(host_bp)
        gpu.HostFree(host_cp)
        gpu.DestroyStream(1)
        gpu.DestroyStream(2)
        ()