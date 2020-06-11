namespace Tests

open System
open System.IO
open ManagedCuda
open ManagedCuda.BasicTypes
open ManagedCuda.NVRTC
open ManagedCuda.VectorTypes

type Tests() = 
    static member doAtomicPointPoolTest() = 
        let ctx = new CudaContext()
        let source = File.ReadAllText(@"C:\Users\Keldor\Source\Repos\Flam35\Flam35\Tests\AtomicPointPoolTest.cu")
        let ptx =
            use rtc = new NVRTC.CudaRuntimeCompiler(source,"program")
            try
                rtc.Compile([||])
            with
            | e ->
                Console.WriteLine(rtc.GetLogAsString())
                raise e
            rtc.GetPTX()
        let atomicPointPoolTestKernel = ctx.LoadKernelPTX(ptx, "AtomicPointPoolTest")
        let rand = new Random()
        let gridSize = 1024
        let blockSize = 32
        let randSeeds =
            [| for n in 0..(blockSize*gridSize*4)-1 do yield rand.Next() |> uint32 |]
        let pointPool =
            [|for n in 0..255 do 
                let n = float32 n
                let mutable f4 = new float4()
                f4.x<-n*4.f
                f4.y<-n*4.f+1.f
                f4.z<-n*4.f+2.f
                f4.w<-n*4.f+3.f
                yield f4|]
        let dRandSeeds = new CudaDeviceVariable<uint32>(SizeT(blockSize*gridSize*4))
        dRandSeeds.CopyToDevice(randSeeds)
        let dPointPool = new CudaDeviceVariable<float4>(SizeT(256))
        dPointPool.CopyToDevice(pointPool)
        atomicPointPoolTestKernel.BlockDimensions <- new dim3(blockSize)
        atomicPointPoolTestKernel.GridDimensions  <- new dim3(gridSize)
        atomicPointPoolTestKernel.Run(dPointPool.DevicePointer,dRandSeeds.DevicePointer) |> ignore
        dPointPool.CopyToHost(pointPool)
        pointPool
        |> Array.fold (fun condition point ->
            if (point.y = point.x + 1.f) && (point.z = point.y + 1.f) && (point.w = point.z + 1.f) then
                condition
            else
                false
        ) true
