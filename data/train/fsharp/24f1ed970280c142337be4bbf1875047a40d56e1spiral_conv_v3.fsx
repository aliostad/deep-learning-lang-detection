// Basic reverse mode AD on the GPU. This v2 of Spiral is focused on convolutional operations. Uses the cuDNN v5 RC.

module SpiralV2

#if INTERACTIVE
#r @"C:\Users\Marko\Documents\Visual Studio 2015\Projects\managedCuda\CudaDNNv5\bin\Release\CudaDNNv5.dll"
#r @"C:\Users\Marko\Documents\Visual Studio 2015\Projects\managedCuda\CudaBlas\bin\x64\Release\CudaBlas.dll"
#r @"C:\Users\Marko\Documents\Visual Studio 2015\Projects\managedCuda\NVRTC\bin\x64\Release\NVRTC.dll"
#r @"C:\Users\Marko\Documents\Visual Studio 2015\Projects\managedCuda\CudaRand\bin\x64\Release\CudaRand.dll"
#r @"C:\Users\Marko\Documents\Visual Studio 2015\Projects\managedCuda\NPP\bin\x64\Release\NPP.dll"
#r @"C:\Users\Marko\Documents\Visual Studio 2015\Projects\managedCuda\ManagedCUDA\bin\Release\ManagedCuda.dll"
#endif

// Open up the namespaces.
open ManagedCuda
open ManagedCuda.BasicTypes
open ManagedCuda.VectorTypes
open ManagedCuda.CudaBlas
open ManagedCuda.CudaRand
open ManagedCuda.NVRTC
open ManagedCuda.CudaDNNv5

open System
open System.Collections.Generic

// Initialize the context. Analogous to a CPU process. Cuda tries to offload as much as possible during context creation so there aren't
// any unexpected delays later.
let ctx = new CudaContext()
let numSm = ctx.GetDeviceInfo().MultiProcessorCount // The number of streaming multiprocessors on the device.

// Make a stream class.
// TODO: The backwards pass and some forward functions could benefit greatly from using multiple streams.
// Especially the backwards pass. It would be something worth doing for V3. I'll leave the library as is for now.
let str = new CudaStream()
// Set the Cuda libraries handles to the above stream.
let cublas = CudaBlas(str.Stream,PointerMode.Host,AtomicsMode.Allowed) // Better performance for some solver functions with atomics allowed. The Spiral library does not use them though.
let cudnn = new CudaDNNContext()
cudnn.SetStream(str)
let cudaRandom = new CudaRand.CudaRandDevice(GeneratorType.PseudoDefault)
cudaRandom.SetStream(str.Stream)

// I'll skip aliasing float32 to floatType for this iteration of the library. There is not point to it as Cuda native functions cannot be overloaded this way.

// Helper functions
/// Copies a host array to device.
let inline to_dev (host_ar: 't []) =
    let d_a = new CudaDeviceVariable<'t>(SizeT host_ar.Length)    
    d_a.CopyToDevice(host_ar)
    d_a

/// Copies a device array to host.
let inline to_host (dev_ar: CudaDeviceVariable<'t>) =
    let h_a = Array.zeroCreate<'t> (int dev_ar.Size)
    dev_ar.CopyToHost(h_a)
    h_a

/// Copies the device array to host. Extends the CudaDeviceVariable class.
type CudaDeviceVariable<'t when 't: struct and 't: (new: unit -> 't) and 't:> System.ValueType> with
    member inline this.Gather() =
        to_host this

/// Allocates a new device array without initializing it.
let inline new_dev<'t when 't: struct and 't: (new: unit -> 't) and 't:> System.ValueType> (n: int) =
    new CudaDeviceVariable<'t>(SizeT n)

/// The float scalar type
type Df = 
    {
    P : float32 ref // primal
    A : float32 ref // adjoint
    }

    static member inline create P =
        {P=P;A=ref 0.0f}

/// The main matrix type.
type d4M =
    {
    mutable num_images:int
    mutable num_channels:int
    mutable num_rows:int
    mutable num_cols:int
    mutable P: CudaDeviceVariable<float32> // primal
    mutable A: CudaDeviceVariable<float32> option // adjoint
    }  

    /// Throws an exception if it tries to allocate an array of size 0.
    static member create(num_images: int, num_channels:int, num_rows: int, num_cols: int) =
        let size = num_images*num_channels*num_rows*num_cols
        let p = new_dev size
        let a = new_dev size |> Some
        {num_images=num_images; num_channels=num_channels; num_rows=num_rows; num_cols=num_cols; P=p; A=a}

    /// Copies a host to a device array.
    /// Throws an exception if it tries to allocate an array of size 0.
    static member create(num_images: int, num_channels:int, num_rows: int, num_cols: int, dArray: float32[]) =
        let size = num_images*num_channels*num_rows*num_cols
        if dArray.Length <> size then failwith "Invalid size in dMatrix construction."
        let p = to_dev dArray
        let a = new_dev size |> Some
        {num_images=num_images; num_channels=num_channels; num_rows=num_rows; num_cols=num_cols; P=p; A=a}

    /// Throws an exception if it tries to allocate an array of size 0.
    /// Does not allocate the adjoint array.
    static member inline createConstant(num_images: int, num_channels:int, num_rows: int, num_cols: int) =
        let size = num_images*num_channels*num_rows*num_cols
        let p = new_dev size
        let a = None
        {num_images=num_images; num_channels=num_channels; num_rows=num_rows; num_cols=num_cols; P=p; A=a}

    /// Copies a host to a device array.
    /// Throws an exception if it tries to allocate an array of size 0.
    /// Does not allocate the adjoint array.
    static member createConstant(num_images: int, num_channels:int, num_rows: int, num_cols: int, dArray: float32[]) =
        let size = num_images*num_channels*num_rows*num_cols
        if dArray.Length <> size then failwithf "Invalid size in dMatrix construction. dArray.Length=%i size=%i" dArray.Length size
        let p = to_dev dArray
        let a = None
        {num_images=num_images; num_channels=num_channels; num_rows=num_rows; num_cols=num_cols; P=p; A=a}

    /// Returns a new instance of an empty dMatrix.
    /// Unlike the let statements, the member statements are always reevaluated.
    static member createEmpty = {num_images=0; num_channels=0; num_rows=0; num_cols=0;P=CudaDeviceVariable.Null; A=Some CudaDeviceVariable.Null}

    /// Returns a new instance of an empty dMatrix without the adjoint allocated.
    /// Unlike the let statements, the member statements are always reevaluated.
    static member createEmptyConstant = {num_images=0; num_channels=0; num_rows=0; num_cols=0;P=CudaDeviceVariable.Null; A=None}

    /// Returns nhwc as a tuple
    member inline t.nchw = t.num_images, t.num_channels, t.num_rows, t.num_cols
    /// Returns the n*h*w*c
    member inline t.size = t.num_images * t.num_channels * t.num_rows * t.num_cols

    /// Returns the nchw, primal tuple.
    member inline t.P' = t.nchw, t.P
    /// Returns the nchw, adjoint tuple. Throws an exception if the adjoint is None.
    member inline t.A' = t.nchw, t.A.Value

    /// Sets the primal to zero.
    member inline t.setZeroPrimal() = t.P.MemsetAsync(0u,str.Stream)
    /// Sets the adjoint to zero.
    member inline t.setZeroAdjoint() = 
        match t.A with
        | Some A -> A.MemsetAsync(0u,str.Stream)
        | None -> ()

    /// Set the matrix to a value.
    member inline t.setPrimal (x: float32) = 
        let v = BitConverter.ToUInt32(BitConverter.GetBytes(x),0)
        t.P.MemsetAsync(v,str.Stream)

    /// Creates a copy of this matrix with all the values set to zero.
    member inline t.zeroLike() =
        match t.A with
        | Some A -> 
            d4M.create(t.num_images,t.num_rows,t.num_cols, t.num_channels)
            |> fun x ->
                x.setZeroPrimal()
                x.setZeroAdjoint()
                x
        | None -> 
            d4M.createConstant(t.num_images,t.num_rows,t.num_cols, t.num_channels)
            |> fun x ->
                x.setZeroPrimal()
                x
    /// Copies a matrix.
    member inline t.copy() =
        match t.A with
        | Some A -> 
            t.nchw 
            |> d4M.create 
            |> fun c ->
                c.P.AsyncCopyToDevice(t.P,str)
                A.AsyncCopyToDevice(A,str)
                c
        | None -> 
            t.nchw 
            |> d4M.createConstant
            |> fun c ->
                c.P.AsyncCopyToDevice(t.P,str)
                c

    /// Resized the dArray if the current one is less than nn*nh*nw*nc. Otherwise it only adjusts num_images, num_rows, num_cols, num_channels.
    member inline t.ReplaceIf (nn, nc, nh, nw) is_constant =
        let new_size = nn*nh*nw*nc
        if int t.P.Size < new_size
        then
            (t :> IDisposable).Dispose()
            t.num_images <- nn
            t.num_channels <- nc
            t.num_rows <- nh
            t.num_cols <- nw
            t.P <- new_dev new_size
            t.A <- 
                match t.A with
                | Some A -> new_dev new_size |> Some
                | None -> 
                    match is_constant with
                    | true -> t.A
                    | false -> new_dev new_size |> Some
        else
            t.num_images <- nn
            t.num_channels <- nc
            t.num_rows <- nh
            t.num_cols <- nw
            t.A <-
                match t.A with
                | Some A -> t.A
                | None -> 
                    match is_constant with
                    | true -> t.A
                    | false -> new_dev new_size |> Some

    /// Copies the primal matrix to a host array.
    /// Blocks the host.
    member inline t.GatherPrimal() =
        let h_a = Array.zeroCreate<float32> t.size
        t.P.CopyToHost(h_a,SizeT 0, SizeT 0, SizeT t.size * t.P.TypeSize)
        ctx.Synchronize()
        h_a

    /// Copies the adjoint matrix to a host array.
    /// Blocks the host.
    member inline t.GatherAdjoint() =
        let h_a = Array.zeroCreate<float32> t.size
        t.A.Value.CopyToHost(h_a,SizeT 0, SizeT 0, SizeT t.size * t.P.TypeSize)
        ctx.Synchronize()
        h_a

    /// The unmanaged Cuda memory has to be freed explicitly or by letting go of the context by resetting  the F# Interactive.
    /// Finalizers work really poorly and can lead to unpredictable bugs when used to manage Cuda memory.
    /// Also do not bother to check whether an array is Null using Equals or =. Just hit Dispose().
    interface IDisposable with
        member t.Dispose() = 
                t.P.Dispose()
                match t.A with
                | Some A -> A.Dispose()
                | None -> ()

let T = Operation.Transpose
let nT = Operation.NonTranspose

let defaultLayout = cudnnTensorFormat.NCHW
let defaultType = cudnnDataType.Float
let defaultMaxPoolingNanOption = cudnnNanPropagation.PropagateNan
let defaultReluNanOption = cudnnNanPropagation.PropagateNan

type TensorDescriptor with
    /// Extended method that works according to the bound defaultLayout and defaultType variables.
    member inline t.SetTensor4dDescriptor(n,c,h,w) = t.SetTensor4dDescriptor(defaultLayout,defaultType,n,c,h,w)

type FilterDescriptor with
    /// Extended method that works according to the bound defaultType variable.
    member inline t.SetFilter4dDescriptor(n,c,h,w) = t.SetFilter4dDescriptor(defaultType,defaultLayout,n,c,h,w)

type ConvolutionParameters = {
    pad_h : int
    pad_w : int
    stride_h : int
    stride_w : int
    upscale_h : int
    upscale_w : int
    mode : cudnnConvolutionMode
    }

type PoolingParameters =
    {
    mode : cudnnPoolingMode
    windowHeight : int
    windowWidth : int
    verticalPadding : int
    horizontalPadding : int
    verticalStride : int
    horizontalStride : int
    }

type PoolingDescriptor with
    member inline t.SetPooling2dDescriptor (p : PoolingParameters) =
        t.SetPooling2dDescriptor(p.mode,defaultMaxPoolingNanOption,p.windowHeight,p.windowWidth,p.verticalPadding,p.horizontalPadding,p.verticalStride,p.horizontalStride)

    member inline t.GetPooling2dForwardOutputDim s =
        let mutable n,c,h,w = 0,0,0,0
        t.GetPooling2dForwardOutputDim(s,&n,&c,&h,&w)
        n,c,h,w

let defaultConvPar = 
    {
    pad_h = 0
    pad_w = 0
    stride_h = 1
    stride_w = 1
    upscale_h = 1
    upscale_w = 1
    mode = cudnnConvolutionMode.Convolution
    }

type ConvolutionDescriptor with
    member inline t.SetConvolution2dDescriptor (p : ConvolutionParameters) =
        t.SetConvolution2dDescriptor(p.pad_h,p.pad_w,p.stride_h,p.stride_w,p.upscale_h,p.upscale_w,p.mode, defaultType)
    member inline t.GetConvolution2dForwardOutputDim (s,f) =
        let mutable n,c,h,w = 0,0,0,0
        t.GetConvolution2dForwardOutputDim(s,f,&n,&c,&h,&w)
        n,c,h,w

type ObjectPool() =
    let d4MPool = ResizeArray()
    let d4Mp = ref 0
    let workspacePool = ResizeArray()
    let wp = ref 0
    let mutable big_worspace = CudaDeviceVariable.Null

    let tensorDescriptorPool = Dictionary(HashIdentity.Structural)
    let filterDescriptorPool = Dictionary(HashIdentity.Structural)
    let convolutionDescriptorPool = Dictionary(HashIdentity.Structural)
    let poolingDescriptorPool = Dictionary(HashIdentity.Structural)
    let activationDescriptorPool = Dictionary(HashIdentity.Structural)
    let BNDescriptorPool = Dictionary(HashIdentity.Structural)

    static member inline private getFromPool (pool : ResizeArray<_>) (pointer_to_pool : int ref) (creation_function) =
        if pool.Count > !pointer_to_pool then
            let t = pool.[!pointer_to_pool]
            pointer_to_pool := !pointer_to_pool+1
            t
        else
            let t = creation_function()
            pool.Add(t)
            pointer_to_pool := !pointer_to_pool+1
            t

    static member inline private getFromDict (pool : Dictionary<_,_>) k creation_function set_function =
        match pool.TryGetValue k with
        | true, v -> v
        | false, _ ->
            let t = creation_function()
            set_function t k
            pool.Add(k, t)
            t

    member t.getWorkspace n = 
        let BIG_WORKSPACE_LIMIT = 100000

        if n > 0 && n <= BIG_WORKSPACE_LIMIT then
            let t' = 
                ObjectPool.getFromPool workspacePool wp 
                <| (fun _ -> 
                    new_dev<byte> n)
            if int t'.Size < n then // Resize the object if less than n
                t'.Dispose()
                let t'' = new_dev<byte> n
                workspacePool.[!wp-1] <- t''
                t''
            else t'
        elif n > BIG_WORKSPACE_LIMIT then 
        // For convolutional nets, the workspaces can get ridiculous, so I need to reuse them. 
        // Having them in the object pool crashed my PC several times already.
            if int big_worspace.Size < n then // Resize the object if less than n
                big_worspace.Dispose()
                big_worspace <- new_dev<byte> n
                big_worspace
            else big_worspace
        else CudaDeviceVariable.Null
    member t.getd4M is_constant (n:int,c:int,h:int,w:int as p) =
        let t' = 
            match is_constant with
            | false -> ObjectPool.getFromPool d4MPool d4Mp (fun _ -> d4M.createEmpty)
            | true -> ObjectPool.getFromPool d4MPool d4Mp (fun _ -> d4M.createEmptyConstant)

        t'.ReplaceIf p is_constant
        t'

    member t.getTensorDescriptor (nchw : int*int*int*int) = 
        ObjectPool.getFromDict tensorDescriptorPool nchw (fun _ -> new TensorDescriptor()) (fun (t: TensorDescriptor) x -> x |> t.SetTensor4dDescriptor)
    member t.getFilterDescriptor (nchw : int*int*int*int) = 
        ObjectPool.getFromDict filterDescriptorPool nchw (fun _ -> new FilterDescriptor()) (fun (t: FilterDescriptor) x -> x |> t.SetFilter4dDescriptor)
    member t.getConvolutionDescriptor (convPars : ConvolutionParameters) = 
        ObjectPool.getFromDict convolutionDescriptorPool convPars (fun _ -> new ConvolutionDescriptor()) (fun (t: ConvolutionDescriptor) x -> x |> t.SetConvolution2dDescriptor)
    member t.getPoolingDescriptor (p : PoolingParameters) = 
        ObjectPool.getFromDict poolingDescriptorPool p (fun _ -> new PoolingDescriptor()) (fun (t: PoolingDescriptor) x -> x |> t.SetPooling2dDescriptor)
    member t.getActivationDescriptor (mode : cudnnActivationMode, nanopt : cudnnNanPropagation, reluCeiling as p) = 
        ObjectPool.getFromDict activationDescriptorPool p (fun _ -> new ActivationDescriptor()) (fun (t: ActivationDescriptor) x -> x |> t.SetActivationDescriptor)
    member t.getBNDescriptor (((nchw : int*int*int*int), (mode : cudnnBatchNormMode), srcDesc : TensorDescriptor) as p) = 
        ObjectPool.getFromDict BNDescriptorPool p 
            (fun _ -> new TensorDescriptor()) 
            (fun (t: TensorDescriptor) (nchw, mode, srcDesc) -> cudnn.DeriveBNTensorDescriptor(t,srcDesc,mode))

    /// Sets only the object pool pointers to zero.
    member inline t.ResetPointers() =
        d4Mp := 0
        wp := 0

    /// Zeroes out the adjoints in preparation for the backprop step and sets all the object pool pointers to zero.
    member t.Reset () =
        for i= !d4Mp-1 downto 0 do
            let x : d4M = d4MPool.[i]
            x.setZeroAdjoint()
        t.ResetPointers()


let ObjectPool = new ObjectPool() // In the past iteration of the library, the object pool's role was taken by the tape. Not anymore.

type d4M with
    /// Copies a matrix.
    /// Uses the object pool.
    member inline t.copy'() =
        match t.A with
        | Some A -> 
            t.nchw 
            |> ObjectPool.getd4M false
            |> fun c ->
                c.P.AsyncCopyToDevice(t.P,str)
                A.AsyncCopyToDevice(A,str)
                c

        | None -> 
            t.nchw 
            |> ObjectPool.getd4M true
            |> fun c ->
                c.P.AsyncCopyToDevice(t.P,str)
                c

let tape = new Stack<(unit -> unit)>(1000) // Nice and simple way of passing in the closures for the backprop step.

let inline divup a b = (a-1)/b+1 // Integer division with rounding up. (a+b-1)/b is another variant on this.

let kernels_dir = IO.Path.Combine(__SOURCE_DIRECTORY__,"Cuda Kernels")
IO.Directory.CreateDirectory(kernels_dir) // Creates the Cuda Kernels directory if it does not exist. WriteAllBytes would otherwise throw an exception.

let inline size_nchw (n:int,c,h,w) = n*c*h*w
let inline add_nchw (n:int,c,h,w) = n+c+h+w

let load_kernel kernel_code kernel_name = 
    let kernel_path = IO.Path.Combine(kernels_dir,kernel_name)
        
    if IO.File.Exists(kernel_path) 
    then
        ctx.LoadKernelPTX(kernel_path,kernel_name) // For all the modules, it takes roughly 0.35s to compile them. Loading them from drive takes less than a millisecond.
    else
        let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,kernel_name)
        try k.Compile([|"-arch=compute_30"|])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()
        let ptx = k.GetPTX()
        IO.File.WriteAllBytes(kernel_path,ptx)
        ctx.LoadKernelPTX(ptx,kernel_name)

// DeviceTransformModules could be all potentially made generic, but I do not want to take the risk without the type system helping me.
// I would need something like a type provider for Alea modules. I am curious as to how v3 of Alea will turn out.

/// o <- f(x)
type DeviceUnaryTransformModule(op: string, unique_name : string) = 
    let block_size = 256

    let kernel_name = "Map1Kernel"+unique_name
    let kernel_code = 
        [|"
        //Kernel code:
        extern \"C\" {
            typedef float floatType;
            __device__ inline floatType op(floatType x)
            {
                return ";op;"
            }
        
            // Device code
            __global__ void ";kernel_name;"(const floatType* A, floatType* O, const int N)
            {
                int i = blockDim.x * blockIdx.x + threadIdx.x;
                const int stride = blockDim.x * gridDim.x;
                while (i < N)
                {
                    O[i] = op(A[i]);
                    i += stride;
                }
            }
        }

        " |] |> String.concat ""

    let kernel = load_kernel kernel_code kernel_name

    member inline t.A((x_nchw, x: CudaDeviceVariable<float32>), (o_nchw, o: CudaDeviceVariable<float32>)) =
        if x_nchw <> o_nchw then failwith "x_nchw <> o_nchw in DeviceUnaryTransformModule"
        let n = size_nchw x_nchw

        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,o.DevicePointer,n) |> ignore

/// o <- f(x,y)
type DeviceBinaryTransformModule(op: string, unique_name) = 
    let block_size = 256

    let kernel_name = "Map2Kernel" + unique_name
    let kernel_code = 
        [|"
        //Kernel code:
        extern \"C\" {
            typedef float floatType;
            __device__ inline floatType op(floatType x, floatType y)
            {
                return ";op;"
            }
        
            // Device code
            __global__ void ";kernel_name;"(const floatType* A, const floatType* B, floatType* O, const int N)
            {
                int i = blockDim.x * blockIdx.x + threadIdx.x;
                const int stride = blockDim.x * gridDim.x;
                while (i < N)
                {
                    O[i] = op(A[i],B[i]);
                    i += stride;
                }
            }
        }

        " |] |> String.concat ""
    
    let kernel = load_kernel kernel_code kernel_name

    member inline t.A((x_nchw, x: CudaDeviceVariable<float32>),(y_nchw, y: CudaDeviceVariable<float32>), (o_nchw, o: CudaDeviceVariable<float32>)) =
        if x_nchw <> y_nchw then failwith "x_nchw <> y_nchw in DeviceBinaryTransformModule"
        if y_nchw <> o_nchw then failwith "y_nchw <> o_nchw in DeviceBinaryTransformModule"
        let n = size_nchw x_nchw

        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,o.DevicePointer,n) |> ignore

/// o <- f(x,y,z)
type DeviceTrinaryTransformModule(op: string, unique_name) = 
    let block_size = 256

    let kernel_name = "Map3Kernel" + unique_name
    let kernel_code = 
        [|"
        //Kernel code:
        extern \"C\" {
            typedef float floatType;
            __device__ inline floatType op(floatType x, floatType y, floatType z)
            {
                return ";op;"
            }
        
            // Device code
            __global__ void ";kernel_name;"(const floatType* A, const floatType* B, const floatType* C, floatType* O, const int N)
            {
                int i = blockDim.x * blockIdx.x + threadIdx.x;
                const int stride = blockDim.x * gridDim.x;
                while (i < N)
                {
                    O[i] = op(A[i],B[i],C[i]);
                    i += stride;
                }
            }
        }

        " |] |> String.concat ""

    let kernel = load_kernel kernel_code kernel_name

    member t.A((x_nchw, x: CudaDeviceVariable<float32>), (y_nchw, y: CudaDeviceVariable<float32>), (z_nchw, z: CudaDeviceVariable<float32>), (o_nchw, o: CudaDeviceVariable<float32>)) =
        if x_nchw <> y_nchw then failwith "x_nchw <> y_nchw in DeviceTrinaryTransformModule"
        if y_nchw <> z_nchw then failwith "y_nchw <> z_nchw in DeviceTrinaryTransformModule"
        if z_nchw <> o_nchw then failwith "z_nchw <> o_nchw in DeviceTrinaryTransformModule"
        let n = size_nchw x_nchw

        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,z.DevicePointer,o.DevicePointer,n) |> ignore


/// o <- sum(f(x))
type DeviceUnaryMapSumModule(op: string, unique_name) = 
    let block_size = 256

    let kernel_name = "Map1SumKernel" + unique_name
    let kernel_code = 
        [|"
        //Kernel code:
        extern \"C\" {
            typedef float floatType;
            __device__ inline floatType op(floatType x)
            {
                return ";op;"
            }
        
            __device__ inline floatType warpDownReduce(floatType value){
                #pragma unroll
	            for (int i = 16; i>0; i = i / 2) value += __shfl_down(value, i);
	            return value;
            }

            // Device code
            __global__ void ";kernel_name;"(const floatType* A, floatType* O, const int N)
            {
	            int i = blockDim.x * blockIdx.x + threadIdx.x;
	            const int stride = blockDim.x * gridDim.x;
	            __shared__ floatType temp[32];
                if (threadIdx.x < 32) {
                    temp[threadIdx.x] = 0.0f; 
                    if (blockIdx.x == 0) O[0] = 0.0f;
                    }
                
                floatType acc = 0.0f;
	            while (i < N)
	            {
		            acc += op(A[i]);
		            i += stride;
	            }
	            __syncthreads(); 
                floatType out_partial = warpDownReduce(acc);
	            if (threadIdx.x % 32 == 0) temp[threadIdx.x / 32] = out_partial;
	            __syncthreads();
	            if (threadIdx.x < 32) out_partial = warpDownReduce(temp[threadIdx.x]);
	            if (threadIdx.x == 0) atomicAdd(O, out_partial);
            }
        }

        " |] |> String.concat ""

    let kernel = load_kernel kernel_code kernel_name

    let o = new_dev<float32> 1

    member inline t.A((x_nchw, x: CudaDeviceVariable<float32>)) =
        let n = size_nchw x_nchw
        
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)

        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,o.DevicePointer,n) |> ignore
        o.[SizeT 0]

/// o <- sum(f(x,y))
type DeviceBinaryMapSumModule(op: string, unique_name) = 
    let block_size = 256

    let kernel_name = "Map2SumKernel" + unique_name
    let kernel_code = 
        [|"
        //Kernel code:
        extern \"C\" {
            typedef float floatType;
            __device__ inline floatType op(floatType x, floatType y)
            {
                return ";op;"
            }
        
            __device__ inline floatType warpDownReduce(floatType value){
                #pragma unroll
	            for (int i = 16; i>0; i = i / 2) value += __shfl_down(value, i);
	            return value;
            }

            // Device code
            __global__ void ";kernel_name;"(const floatType* A, const floatType* B, floatType* O, const int N)
            {
	            int i = blockDim.x * blockIdx.x + threadIdx.x;
	            const int stride = blockDim.x * gridDim.x;
	            __shared__ floatType temp[32]; 
                if (threadIdx.x < 32) {
                    temp[threadIdx.x] = 0.0f; 
                    if (blockIdx.x == 0) O[0] = 0.0f;
                    }    
                floatType acc = 0.0f;
	            while (i < N)
	            {
		            acc += op(A[i],B[i]);
		            i += stride;
	            }
	            __syncthreads(); 
                floatType out_partial = warpDownReduce(acc);
	            if (threadIdx.x % 32 == 0) temp[threadIdx.x / 32] = out_partial;
	            __syncthreads();
	            if (threadIdx.x < 32) out_partial = warpDownReduce(temp[threadIdx.x]);
	            if (threadIdx.x == 0) atomicAdd(O, out_partial);
            }
        }

        " |] |> String.concat ""

    let kernel = load_kernel kernel_code kernel_name

    let o = new_dev<float32> 1

    member inline t.A((x_nchw, x: CudaDeviceVariable<float32>),(y_nchw, y: CudaDeviceVariable<float32>)) =
        if x_nchw <> y_nchw then failwith "x_nchw <> y_nchw in DeviceBinaryMapSumModule"
        let n = size_nchw x_nchw
        
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,o.DevicePointer,n) |> ignore
        o.[SizeT 0]

/// o <- f(coef_x,x)
type DeviceUnaryCoefTransformModule(op: string, unique_name) = 
    let block_size = 256

    let kernel_name = "Map1CoefKernel" + unique_name
    let kernel_code = 
        [|"
        //Kernel code:
        extern \"C\" {
            typedef float floatType;
            __device__ inline floatType op(floatType coef_x, floatType x)
            {
                return ";op;"
            }
        
            // Device code
            __global__ void ";kernel_name;"(const floatType coef_A, const floatType* A, floatType* O, const int N)
            {
                int i = blockDim.x * blockIdx.x + threadIdx.x;
                const int stride = blockDim.x * gridDim.x;
                while (i < N)
                {
                    O[i] = op(coef_A,A[i]);
                    i += stride;
                }
            }
        }

        " |] |> String.concat ""

    let kernel = 
        let kernel_path = IO.Path.Combine(kernels_dir,kernel_name)
        
        if IO.File.Exists(kernel_path) 
        then
            ctx.LoadKernelPTX(kernel_path,kernel_name) // For all the modules, it takes roughly 0.35s to compile them. Loading them from drive takes less than a millisecond.
        else
            let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,kernel_name)
            try k.Compile([||])
            with 
            | :? NVRTCException as x -> 
                printfn "%s" (k.GetLogAsString())
                reraise()
            let ptx = k.GetPTX()
            IO.File.WriteAllBytes(kernel_path,ptx)
            ctx.LoadKernelPTX(ptx,kernel_name)

    member inline t.A(coef_x: float32, (x_nchw, x: CudaDeviceVariable<float32>), (o_nchw, o: CudaDeviceVariable<float32>)) =
        if x_nchw <> o_nchw then failwith "x.nchw <> o.nchw in DeviceUnaryCoefTransformModule"
        let n = size_nchw x_nchw

        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,o.DevicePointer,n) |> ignore

/// o <- f(coef_x,x,coef_y,y)
type DeviceBinaryCoefTransformModule(op: string, unique_name) = 
    let block_size = 256

    let kernel_name = "Map2CoefKernel" + unique_name
    let kernel_code = 
        [|"
        //Kernel code:
        extern \"C\" {
            typedef float floatType;

            __device__ inline floatType op(floatType coef_x, floatType x, floatType coef_y, floatType y)
            {
                return ";op;"
            }
        
            // Device code
            __global__ void ";kernel_name;"(const floatType coef_A, const floatType* A, const floatType coef_B, const floatType* B, floatType* O, const int N)
            {
                int i = blockDim.x * blockIdx.x + threadIdx.x;
                const int stride = blockDim.x * gridDim.x;
                while (i < N)
                {
                    O[i] = op(coef_A,A[i],coef_B,B[i]);
                    i += stride;
                }
            }
        }

        " |] |> String.concat ""

    let kernel = 
        let kernel_path = IO.Path.Combine(kernels_dir,kernel_name)
        
        if IO.File.Exists(kernel_path) 
        then
            ctx.LoadKernelPTX(kernel_path,kernel_name) // For all the modules, it takes roughly 0.35s to compile them. Loading them from drive takes less than a millisecond.
        else
            let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,kernel_name)
            try k.Compile([||])
            with 
            | :? NVRTCException as x -> 
                printfn "%s" (k.GetLogAsString())
                reraise()
            let ptx = k.GetPTX()
            IO.File.WriteAllBytes(kernel_path,ptx)
            ctx.LoadKernelPTX(ptx,kernel_name)

    member inline t.A(coef_x: float32, (x_nchw, x: CudaDeviceVariable<float32>), coef_y: float32, (y_nchw, y: CudaDeviceVariable<float32>), (o_nchw, o: CudaDeviceVariable<float32>)) =
        if x_nchw <> y_nchw then failwith "x_nchw <> y_nchw in DeviceBinaryCoefTransformModule"
        if y_nchw <> o_nchw then failwith "y_nchw <> o_nchw in DeviceBinaryCoefTransformModule"
        let n = size_nchw x_nchw

        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,coef_y,y.DevicePointer,o.DevicePointer,n) |> ignore

/// o <- f(coef_x,x,coef_y,y,coef_z,z)
type DeviceTrinaryCoefTransformModule(op: string, unique_name) = 
    let block_size = 256

    let kernel_name = "Map3CoefKernel" + unique_name
    let kernel_code = 
        [|"
        //Kernel code:
        extern \"C\" {
            typedef float floatType;
            __device__ inline floatType op(floatType coef_x, floatType x, floatType coef_y, floatType y, floatType coef_z, floatType z)
            {
                return ";op;"
            }
        
            // Device code
            __global__ void ";kernel_name;"(const floatType coef_A, const floatType* A, const floatType coef_B, const floatType* B, const floatType coef_C, const floatType* C, floatType* O, const int N)
            {
                int i = blockDim.x * blockIdx.x + threadIdx.x;
                const int stride = blockDim.x * gridDim.x;
                while (i < N)
                {
                    O[i] = op(coef_A,A[i],coef_B,B[i],coef_C,C[i]);
                    i += stride;
                }
            }
        }

        " |] |> String.concat ""

    let kernel = 
        let kernel_path = IO.Path.Combine(kernels_dir,kernel_name)
        
        if IO.File.Exists(kernel_path) 
        then
            ctx.LoadKernelPTX(kernel_path,kernel_name) // For all the modules, it takes roughly 0.35s to compile them. Loading them from drive takes less than a millisecond.
        else
            let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,kernel_name)
            try k.Compile([||])
            with 
            | :? NVRTCException as x -> 
                printfn "%s" (k.GetLogAsString())
                reraise()
            let ptx = k.GetPTX()
            IO.File.WriteAllBytes(kernel_path,ptx)
            ctx.LoadKernelPTX(ptx,kernel_name)

    member inline t.A(coef_x: float32, (x_nchw, x: CudaDeviceVariable<float32>), coef_y: float32, (y_nchw, y: CudaDeviceVariable<float32>), coef_z: float32, (z_nchw, z: CudaDeviceVariable<float32>), (o_nchw, o: CudaDeviceVariable<float32>)) =
        if x_nchw <> y_nchw then failwith "x_nchw <> y_nchw in DeviceTrinaryCoefTransformModule"
        if y_nchw <> z_nchw then failwith "y_nchw <> z_nchw in DeviceTrinaryCoefTransformModule"
        if z_nchw <> o_nchw then failwith "z_nchw <> o_nchw in DeviceTrinaryCoefTransformModule"
        let n = size_nchw x_nchw

        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,coef_y,y.DevicePointer,coef_z,z.DevicePointer,o.DevicePointer,n) |> ignore

/// o <- max_col(x)
/// Sets all except one of the max of a column to zero.
type DeviceMaxColumnActivationModule() = 
    let block_size = 128

    let kernel_name = "MaxColumnActivationKernel"
    let kernel_code = 
        [|"
        //Kernel code:
        extern \"C\" {
            typedef float floatType;
            #define INIT __int_as_float(0xff800000) // The constant init for the reduce operations. This is float negative infinity.
            // The max reduce version.
            __device__ inline floatType warpReduce(floatType value){
                #pragma unroll
	            for (int i=1; i<32; i*=2) {
                    floatType tmp = __shfl_xor(value, i);
                    value = (tmp > value) ? tmp : value;
                    }
	            return value;
            }
              
            __device__ inline floatType blockReduce(floatType value){
	            __shared__ floatType temp[32];
                if (threadIdx.x < 32) temp[threadIdx.x] = INIT; 
                floatType out_partial = warpReduce(value);
                __syncthreads();
	            if (threadIdx.x % 32 == 0) temp[threadIdx.x / 32] = out_partial;
                __syncthreads();
	            if (threadIdx.x < 32) out_partial = warpReduce(temp[threadIdx.x]);
                return out_partial;
            }

            // Device code
            __global__ void ";kernel_name;"(const floatType* A, floatType* O, const int num_rows, const int num_cols)
            {
                int row = threadIdx.x;
                //const int col = blockIdx.x;
                int col_idx = blockIdx.x*num_rows; 
                floatType max = INIT; // This is the negative infinity for floats.
                int index = -1;
                while (row < num_rows)
                {
                   if (A[row+col_idx] > max) {
                        max = A[row+col_idx];
                        index = row;
                        }
                    row += blockDim.x;
                }
                
                __shared__ floatType max_index;
                if (max == blockReduce(max)) max_index = index;
                __syncthreads();
                index = max_index; // These last four lines are to make absolutely sure that only one max is selected in case there is more than one.
                row = threadIdx.x;
                while (row < num_rows)
                {
                    O[row+col_idx] = (row == index) ? max : 0.0f;
                    row += blockDim.x;
                }
            }
        }

        "|] |> String.concat ""

    let kernel = load_kernel kernel_code kernel_name

    member t.A(((n : int,c : int,h,w as x_nchw), x: CudaDeviceVariable<float32>), (o_nchw, o: CudaDeviceVariable<float32>)) =
        if x_nchw <> o_nchw then failwith "x_nchw <> o_nchw"
        let m = c*h*w
        kernel.GridDimensions <- dim3(n)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream,x.DevicePointer,o.DevicePointer,m,n) |> ignore
      
// The gradient clipping module.
let gradclipModule = lazy DeviceUnaryCoefTransformModule("(x < -coef_x) ? -coef_x : (x > coef_x ? coef_x : x);", "GradClip") // Unique names like GradClip are necessary for load and saving to drive. Be very careful of collisions.

// coef_x = scale
// coef_y = location
// y does not get used.
let randMapModule = lazy DeviceBinaryCoefTransformModule("coef_x*(x-0.5f)+coef_y;","RandMapper")

/// Fills matrix by sampling from a random uniform distribution in <-1.0f,1.0f]
let fillRandomUniformMatrix (x_nchw, x : CudaDeviceVariable<float32> as x') (scaling_factor : float32) location =
        cudaRandom.GenerateUniform(x)
        // 2.0f*scaling_factor ensures that it is rescaled around zero if the scaling_factor is 1.0f.
        randMapModule.Value.A(2.0f*scaling_factor,x',location,x',x')

// y <- alpha * x + y
let saxpy (alpha:float32) (x_nchw, x:CudaDeviceVariable<float32>) (y_nchw, y:CudaDeviceVariable<float32>) =
    if x_nchw <> y_nchw then failwith "x_nchw <> y_nchw in saxpy"
    cublas.Axpy(alpha,x,1,y,1)

/// General matrix-matrix addition. Inplace version.
/// The function is not indented for transposes due to dimensional confusion.
#nowarn "49"
let geam transa transb (alpha: float32) ((A_num_images, A_num_channels, A_num_rows, A_num_cols as A_nchw), A:CudaDeviceVariable<float32>) beta ((B_num_images, B_num_channels, B_num_rows, B_num_cols as B_nchw), B:CudaDeviceVariable<float32>) ((C_num_images, C_num_channels, C_num_rows, C_num_cols as C_nchw), C:CudaDeviceVariable<float32>) =
    let inline geam (A_num_rows, A_num_cols) (B_num_rows, B_num_cols) (C_num_rows, C_num_cols) =
        let a_row = if transa = nT then A_num_rows else A_num_cols
        let a_col = if transa = nT then A_num_cols else A_num_rows
        let b_row = if transb = nT then B_num_rows else B_num_cols
        let b_col = if transb = nT then B_num_cols else B_num_rows
        
        if a_row <> b_row then failwith (sprintf "a_row <> b_row in geam! %i <> %i" a_row b_row)
        if a_col <> b_col then failwith (sprintf "a_col <> b_col in geam! %i <> %i" a_col b_col)

        if a_row <> C_num_rows then failwith (sprintf "a_row <> C_num_rows in geam! %i <> %i" a_col C_num_rows)
        if a_col <> C_num_cols then failwith (sprintf "a_col <> C_num_cols in geam! %i <> %i" a_col C_num_cols)

        let lda = if transa = nT then a_row else a_col
        let ldb = if transa = nT then b_row else b_col
        let ldc = a_row

        cublas.Geam(transa, transb, a_row, a_col, alpha, A, lda, B, ldb, beta, C, ldc)

    geam (A_num_channels*A_num_cols*A_num_rows,A_num_images) (B_num_channels*B_num_cols*B_num_rows,B_num_images) (C_num_channels*C_num_cols*C_num_rows,C_num_images)

/// General matrix-matrix multiply from cuBLAS. Inplace version
/// c,h,w get multiplied together to form the first dimension. n is the second dimension.
let gemm transa transb (alpha: float32) ((A_num_images, A_num_channels, A_num_rows, A_num_cols), A:CudaDeviceVariable<float32>) ((B_num_images, B_num_channels, B_num_rows, B_num_cols), B:CudaDeviceVariable<float32>) beta ((C_num_images, C_num_channels, C_num_rows, C_num_cols), C:CudaDeviceVariable<float32>) =
    let inline gemm (A_num_rows, A_num_cols) (B_num_rows, B_num_cols) (C_num_rows, C_num_cols) =
        let a_col = if transa = nT then A_num_cols else A_num_rows
        let b_row = if transb = nT then B_num_rows else B_num_cols
        if a_col <> b_row then failwithf "a_col <> b_row in gemm! %i <> %i" a_col b_row
        let m = if transa = nT then A_num_rows else A_num_cols
        let n = if transb = nT then B_num_cols else B_num_rows
        let k = a_col
        let lda = if transa = nT then m else k
        let ldb = if transb = nT then k else n
        let ldc = m

        if m <> C_num_rows || n <> C_num_cols then failwith "m <> C_num_rows || n <> C_num_cols"

        cublas.Gemm(transa, transb, m, n, k, alpha, A, lda, B, ldb, beta, C, ldc)

    gemm (A_num_channels*A_num_cols*A_num_rows,A_num_images) (B_num_channels*B_num_cols*B_num_rows,B_num_images) (C_num_channels*C_num_cols*C_num_rows,C_num_images)

/// Matrix-matrix multiply.
let inline private matmult' (prev_output : d4M option) ((a,b): d4M*d4M) =
    let c = 
        match prev_output with
        | None ->
            let num_rows = a.num_channels*a.num_cols*a.num_rows
            let num_cols = b.num_images
            ObjectPool.getd4M false (num_cols,num_rows,1,1)
            |> fun c ->
                gemm nT nT 1.0f a.P' b.P' 0.0f c.P'
                c
        | Some c ->
            gemm nT nT 1.0f a.P' b.P' 1.0f c.P'
            c

    if a.A.IsSome then 
        let matmult_backward_left () = gemm nT T 1.0f c.A' b.P' 1.0f a.A'
        tape.Push(matmult_backward_left)
    if b.A.IsSome then 
        let matmult_backward_right () = gemm T nT 1.0f a.P' c.A' 1.0f b.A'
        tape.Push(matmult_backward_right)
    Some c

let matmult (a: d4M) (b:d4M) = matmult' None (a, b) |> fun x -> x.Value

/// Can be used to add matrices or for (4D)matrix-vector broadcast addition.
/// The output dimensions are based on the left argument.
/// Those dimenions the size of 1 of the right argument are broadcasted.
let inline private tensor_add' add_to_left alpha (left : d4M) beta (right : d4M) =
    let leftDesc = ObjectPool.getTensorDescriptor left.nchw
    let rightDesc = ObjectPool.getTensorDescriptor right.nchw

    let output = 
        if add_to_left = false 
        then 
            left.nchw |> ObjectPool.getd4M false 
            |> fun output -> cudnn.AddTensor(alpha,leftDesc,left.P,0.0f,leftDesc,output.P); output // Copy the left to output
        else 
            left

    cudnn.AddTensor(beta,rightDesc,right.P,1.0f,leftDesc,output.P) // Add right to output.

    if right.A.IsSome then 
        let tensor_add_right_backwards () = 
            if left.nchw = right.nchw then
                saxpy beta output.A' right.A'
            else
                cudnn.ConvolutionBackwardBias(beta,leftDesc,output.A.Value,1.0f,rightDesc,right.A.Value)
        tape.Push(tensor_add_right_backwards)

    if add_to_left = false && left.A.IsSome then 
        let tensor_add_left_backwards () = saxpy alpha output.A' left.A'
        tape.Push(tensor_add_left_backwards)
    output

let tensor_add = tensor_add' false

let linear_layer_matmult (mm: (d4M*d4M) []) (bias: d4M option) =
    mm
    |> Array.fold matmult' None
    |> fun (output) ->
        let left = output.Value
        match bias with
        | None -> left
        | Some right -> tensor_add' true 1.0f left 1.0f right

/// The activation function. Zeroes out the target primal during the call.
let activation_forward mode (input : d4M)  =
    let input_sizes = input.nchw
    let srcTensorDesc = ObjectPool.getTensorDescriptor input_sizes

    let alpha = 1.0f
    let beta = 1.0f

    let output = ObjectPool.getd4M false input_sizes

    cudnn.ActivationForward(mode,alpha,srcTensorDesc,input.P,0.0f,srcTensorDesc,output.P)

    if input.A.IsSome then 
        let activation_backward () =
            cudnn.ActivationBackward(mode,alpha,srcTensorDesc,output.P,srcTensorDesc,output.A.Value,srcTensorDesc,input.P,beta,srcTensorDesc,input.A.Value)
        tape.Push(activation_backward)
    output

/// The pooling function. Zeroes out the target primal during the call.
let pooling_forward p (input : d4M) =
    let poolingDescriptor = ObjectPool.getPoolingDescriptor p
    let input_sizes = input.nchw
    let srcTensorDesc = ObjectPool.getTensorDescriptor input_sizes
    let dest_sizes = poolingDescriptor.GetPooling2dForwardOutputDim srcTensorDesc

    let output = ObjectPool.getd4M false dest_sizes

    let dstTensorDesc = ObjectPool.getTensorDescriptor dest_sizes

    let alpha, beta = 1.0f, 1.0f

    cudnn.PoolingForward(poolingDescriptor,alpha,srcTensorDesc,input.P,0.0f,dstTensorDesc,output.P)

    if input.A.IsSome then 
        let pooling_backward () =
            cudnn.PoolingBackward(poolingDescriptor,alpha,srcTensorDesc,output.P,srcTensorDesc,
                                  output.A.Value,dstTensorDesc,input.P,beta,dstTensorDesc,input.A.Value)
        tape.Push(pooling_backward)
    output

let inline private convolutional_forward' (prev_output: ((int*int*int*int)*d4M) option) (convPar, data : d4M, filter : d4M) =
    let data_sizes = data.nchw
    let filter_sizes = filter.nchw

    let srcTensorDesc = ObjectPool.getTensorDescriptor data_sizes
    
    let filterDesc = ObjectPool.getFilterDescriptor filter_sizes
    let convDesc = ObjectPool.getConvolutionDescriptor convPar

    let dims, output = 
        let dims = convDesc.GetConvolution2dForwardOutputDim(srcTensorDesc,filterDesc)
        match prev_output with
        | Some (prev_dims, prev_output) ->
            if dims <> prev_dims then failwith "dims <> prev_dims in linear_layer_conv"
            prev_dims, prev_output
        | None ->
            dims, dims |> ObjectPool.getd4M false

    let dstTensorDesc = ObjectPool.getTensorDescriptor dims

    let algo = cudnn.GetConvolutionForwardAlgorithm(srcTensorDesc,filterDesc,convDesc,dstTensorDesc,cudnnConvolutionFwdPreference.PreferFastest,SizeT 0)
    let workspace = 
        cudnn.GetConvolutionForwardWorkspaceSize(srcTensorDesc, filterDesc, convDesc, dstTensorDesc, algo) |> int
        |> ObjectPool.getWorkspace

    let alpha = 1.0f
    let beta = 1.0f // This thing could be dangerous.

    match prev_output with
    | None -> cudnn.ConvolutionForward(alpha,srcTensorDesc,data.P,filterDesc,filter.P,convDesc,algo,workspace,0.0f,dstTensorDesc,output.P)
    | Some _ -> cudnn.ConvolutionForward(alpha,srcTensorDesc,data.P,filterDesc,filter.P,convDesc,algo,workspace,1.0f,dstTensorDesc,output.P) // Don't zero out the previous output.

    if filter.A.IsSome then 
        let convolution_backwards_filter () =
            let algo = cudnn.GetConvolutionBackwardFilterAlgorithm(srcTensorDesc,dstTensorDesc,convDesc,filterDesc,cudnnConvolutionBwdFilterPreference.PreferFastest,SizeT 0)
            let workspace =
                cudnn.GetConvolutionBackwardFilterWorkspaceSize(srcTensorDesc,dstTensorDesc,convDesc,filterDesc,algo) |> int
                |> ObjectPool.getWorkspace
            cudnn.ConvolutionBackwardFilter(alpha,srcTensorDesc,data.P,dstTensorDesc,output.A.Value,convDesc,algo,workspace,beta,filterDesc,filter.A.Value)
        tape.Push(convolution_backwards_filter)

    if data.A.IsSome then 
        let convolution_backwards_data () =
            let algo = cudnn.GetConvolutionBackwardDataAlgorithm(filterDesc,dstTensorDesc,convDesc,srcTensorDesc,cudnnConvolutionBwdDataPreference.PreferFastest,SizeT 0)
            let workspace =
                cudnn.GetConvolutionBackwardDataWorkspaceSize(filterDesc,dstTensorDesc,convDesc,srcTensorDesc,algo) |> int
                |> ObjectPool.getWorkspace
            cudnn.ConvolutionBackwardData(alpha,filterDesc,filter.P,dstTensorDesc,output.A.Value,convDesc,beta,algo,workspace,srcTensorDesc,data.A.Value)
        tape.Push(convolution_backwards_data)

    (dims,output) |> Some

/// The convolutional function. Zeroes out the target primal during the call.
let convolution_forward convPar (data : d4M) (filter : d4M) = 
    convolutional_forward' None (convPar,data,filter)
    |> fun x -> x.Value |> snd

let batch_normalization_forward bnMode (bnScale : d4M) (bnBias : d4M) (bnRunningMean : d4M) (bnRunningVariance : d4M) exponentialAverageFactor do_inference (input : d4M) =
    let input_sizes = input.nchw
    let bias_sizes = bnBias.nchw
    let srcTensorDesc = ObjectPool.getTensorDescriptor input_sizes

    let bnDesc = 
        //bnBias.nchw |> ObjectPool.getTensorDescriptor
        ObjectPool.getBNDescriptor (input_sizes, bnMode, srcTensorDesc)

    let _ =
        let mutable d,n,c,h,w,sn,sc,sh,sw = cudnnDataType.Double,0,0,0,0,0,0,0,0
        bnDesc.GetTensor4dDescriptor(&d,&n,&c,&h,&w,&sn,&sc,&sh,&sw)
        let bn_nchw = n,c,h,w
        if bn_nchw <> bnScale.nchw then failwith "Tensor dimensions for bnScale are incorrect."
        if bn_nchw <> bnBias.nchw then failwith "Tensor dimensions for bnBias are incorrect."
        if bn_nchw <> bnRunningMean.nchw then failwith "Tensor dimensions for bnRunningMean are incorrect."
        if bn_nchw <> bnRunningVariance.nchw then failwith "Tensor dimensions for bnRunningVariance are incorrect."

    let alpha, beta = 1.0f, 0.0f
    let epsilon = 1e-5
    let bnSavedMean = bias_sizes |> ObjectPool.getd4M true
    let bnSavedVariance = bias_sizes |> ObjectPool.getd4M true
    let output = input_sizes |> ObjectPool.getd4M false

    if do_inference = false then
        cudnn.BatchNormalizationForwardTraining(bnMode,alpha,beta,srcTensorDesc,input.P,srcTensorDesc,output.P,bnDesc,bnScale.P,bnBias.P,exponentialAverageFactor,bnRunningMean.P,bnRunningVariance.P,epsilon,bnSavedMean.P,bnSavedVariance.P)
        if input.A.IsSome then 
            let batch_normalization_backward () =
                let dx_alpha, dx_beta = 1.0f, 1.0f
                let param_alpha, param_beta = 1.0f, 1.0f

                cudnn.BatchNormalizationBackward(bnMode,dx_alpha,dx_beta,param_alpha,param_beta,srcTensorDesc,input.P,srcTensorDesc,output.A.Value,srcTensorDesc,input.A.Value,bnDesc,bnScale.P,bnScale.A.Value,bnBias.A.Value,epsilon,bnSavedMean.P,bnSavedVariance.P)
                
            tape.Push batch_normalization_backward
    else
        cudnn.BatchNormalizationForwardInference(bnMode,alpha,beta,srcTensorDesc,input.P,srcTensorDesc,output.P,bnDesc,bnScale.P,bnBias.P,bnRunningMean.P,bnRunningVariance.P, epsilon)
        
    output
    
let linear_layer_conv (convs: (ConvolutionParameters*d4M*d4M) []) (bias: d4M option) =
    convs
    |> Array.fold convolutional_forward' None
    |> fun (output) ->
        let _, left = output.Value
        match bias with
        | None -> left
        | Some right -> tensor_add' true 1.0f left 1.0f right

let hadamaradMultiplicationModule = lazy new DeviceBinaryTransformModule("x*y;", "HadMult")
let hadamaradMultiplicationErrorModule = lazy new DeviceTrinaryTransformModule("x*y+z;", "HadMultError")
/// Hadamarad (elementwise) multiplication function.
let inline private hadmult' (prev_output : d4M option) ((a,b): d4M*d4M) =
    let c = 
        match prev_output with
        | Some c -> 
            hadamaradMultiplicationErrorModule.Value.A(a.P', b.P', c.P', c.P'); c
        | None -> 
            ObjectPool.getd4M false a.nchw
            |> fun c -> hadamaradMultiplicationModule.Value.A(a.P', b.P', c.P'); c

    if a.A.IsSome then 
        let hadmult_backward_left () = hadamaradMultiplicationErrorModule.Value.A(b.P',c.A',a.A',a.A')
        tape.Push hadmult_backward_left
    if b.A.IsSome then 
        let hadmult_backward_right () = hadamaradMultiplicationErrorModule.Value.A(a.P',c.A',b.A',b.A')
        tape.Push hadmult_backward_right
    Some c

let hadmult (a: d4M) (b: d4M) = hadmult' None (a, b) |> fun x -> x.Value
let linear_layer_hadmult (hads: (d4M*d4M)[]) = hads |> Array.fold hadmult' None |> fun x -> x.Value

let squareModule = lazy new DeviceUnaryTransformModule("x*x;","Square")
//y = error
//z = previous adjoint value
let squareErrorModule = lazy new DeviceTrinaryTransformModule("2.0f*x*y + z;","SquareError")
let square (a:d4M) =
    let c = a.nchw |> ObjectPool.getd4M false
    squareModule.Value.A(a.P',c.P')

    if a.A.IsSome then 
        let square_backward () = squareErrorModule.Value.A(a.P',c.A',a.A',a.A')
        tape.Push square_backward
    c

/// This one is for debugging currently
let squareSumModule = lazy new DeviceUnaryMapSumModule("x*x;", "SquareSum")

let sumModule = lazy new DeviceUnaryMapSumModule("x;", "Sum")
let sumErrorModule = lazy new DeviceUnaryCoefTransformModule("coef_x + x;", "SumError")
let sum (a:d4M) =
    let c = Df.create (ref 0.0f)
    c.P := sumModule.Value.A(a.P')

    if a.A.IsSome then 
        let sum_backward () = sumErrorModule.Value.A(!c.A,a.A',a.A')
        tape.Push sum_backward
    c

let scale (alpha: float32) (a:Df) =
    let c = Df.create (ref 0.0f)
    c.P := alpha * !a.P

    let scale_backward () = a.A := alpha * !c.A + !a.A
    tape.Push scale_backward
    c

let sum_scalars (a:Df[]) =
    let c = Df.create (ref 0.0f)

    for l in a do c.P := !c.P + !l.P
    
    let sum_scalars_backwards () = for l in a do l.A := !c.A + !l.A
    tape.Push sum_scalars_backwards
    c

let logModule = lazy new DeviceUnaryTransformModule("logf(x);","Log")
//y=error
//z=previous adjoint
let logErrorModule = lazy new DeviceTrinaryTransformModule("y / x + z;","LogError")
let log_ (a:d4M) =
    let c = ObjectPool.getd4M false a.nchw

    logModule.Value.A(a.P',c.P')

    if a.A.IsSome then
        let log_backward () = logErrorModule.Value.A(a.P',c.A', a.A', a.A')
        tape.Push log_backward
    c

//coef_x = scalar
//coef_y = coef
let scalarMatrixAddModule = lazy new DeviceBinaryCoefTransformModule("coef_x + coef_y*x;","ScalarMatrixAdd")
/// o <- scalar + coef*a
let scalar_matrix_add scalar coef (a:d4M) =
    let c = ObjectPool.getd4M false a.nchw

    scalarMatrixAddModule.Value.A(scalar,a.P',coef,a.P',c.P')

    if a.A.IsSome then
        let scalar_matrix_add_backward () = saxpy coef c.A' a.A'
        tape.Push scalar_matrix_add_backward
    c


let add alpha (a: d4M) beta (b: d4M) =
    let c = ObjectPool.getd4M false a.nchw

    geam nT nT alpha a.P' beta b.P' c.P'

    if a.A.IsSome then
        let add_backward_left () = saxpy alpha c.A' a.A'
        tape.Push add_backward_left
    if b.A.IsSome then
        let add_backward_right () =  saxpy beta c.A' b.A'
        tape.Push add_backward_right
    c

let softmax_instance_forward (data : d4M) =
    let data_sizes = data.nchw

    let srcTensorDesc = ObjectPool.getTensorDescriptor data_sizes
    let output = data_sizes |> ObjectPool.getd4M false 

    let algo = cudnnSoftmaxAlgorithm.Accurate // Log mode forgets to re-exponentiate at the end.
    let mode = cudnnSoftmaxMode.Instance

    cudnn.SoftmaxForward(algo,mode,1.0f,srcTensorDesc,data.P,0.0f,srcTensorDesc,output.P)

    if data.A.IsSome then
        let softmax_channel_backward () =
            cudnn.SoftmaxBackward(algo,mode,1.0f,srcTensorDesc,output.P,srcTensorDesc,output.A.Value,1.0f,srcTensorDesc,data.A.Value)
        tape.Push softmax_channel_backward
    output

let inline softmax x = softmax_instance_forward x

let clipModule = lazy new DeviceTrinaryCoefTransformModule("((x < coef_x) ? coef_x : (x > coef_y ? coef_y : x))+coef_z;","Clip")
let clipErrorModule = lazy new DeviceTrinaryCoefTransformModule("y*((x < coef_x) ? 0.0f : (x > coef_y ? 0.0f : 1.0f))+z;","ClipError")
/// o <- clip(min,max,a)+scalar
/// The clip function. Can be used as Relu by setting max to positive infinity. 
/// Can be used to make linear clipped sigmoid by setting min,max,scalar to -0.5f,0.5f,0.5f.
let clip min max (a : d4M) scalar =
    let c = ObjectPool.getd4M false a.nchw

    clipModule.Value.A(min,a.P',max,a.P',scalar,a.P',c.P')

    if a.A.IsSome then
        let clip_backward () = 
            clipErrorModule.Value.A(min,a.P',max,c.A',max,a.A',a.A')
        tape.Push clip_backward
    c

let inline relu x = 
    let t = ObjectPool.getActivationDescriptor (cudnnActivationMode.Relu, defaultReluNanOption, 0.0)
    activation_forward t x
let inline sigmoid x = 
    let t = ObjectPool.getActivationDescriptor (cudnnActivationMode.Sigmoid, defaultReluNanOption, 0.0)
    activation_forward t x
let inline tanh_ x = 
    let t = ObjectPool.getActivationDescriptor (cudnnActivationMode.Tanh, defaultReluNanOption, 0.0)
    activation_forward t x
let inline clipped_sigmoid x = clip 0.0001f 0.9999f (sigmoid x) 0.0f
let inline clipped_softmax x = clip 0.0001f 0.9999f (softmax x) 0.0f

let squared_error_cost target activations =
    add 1.0f target -1.0f activations // TODO: tensor_add is ungodly slow in v3. Make v4 wrapper.
    |> square
    |> sum
    |> scale (0.5f/ float32 target.num_images)

let cross_entropy_cost target activations =
    linear_layer_hadmult [|target,log_ activations;scalar_matrix_add 1.0f -1.0f target, log_ (scalar_matrix_add 1.0f -1.0f activations)|]
    |> sum
    |> scale (-1.0f/float32 target.num_images)


let maxColumnActivationModule = lazy new DeviceMaxColumnActivationModule()
let accuracyModule = lazy new DeviceBinaryMapSumModule("(x*y == 0.0f) ? 0.0f : 1.0f;","Accuracy")
let get_accuracy (targets : d4M) (activations : d4M) =
    let o = ObjectPool.getd4M true targets.nchw
    maxColumnActivationModule.Value.A(activations.P',o.P')
    accuracyModule.Value.A(targets.P',o.P')

let find_max_index (action_values : float32[]) =
    let mutable max = Single.NegativeInfinity
    let mutable index = -1
    for i=0 to action_values.Length-1 do
        let x = action_values.[i]
        if max < x then max <- x; index <- i
    index

type d4M with
    static member makeUniformRandomNode (n,c,h,w as nchw) =
        let scale = (1.0f / sqrt(add_nchw nchw |> float32))
        let p = d4M.create(n,c,h,w)
        fillRandomUniformMatrix p.P' scale 0.0f
        p

// A convolutional feedforward layer of neurons
type ConvolutionalFeedforwardLayer =
    {
    W : d4M  // Input weight matrix
    b : d4M  // Bias vector
    a : d4M -> d4M // Activation function
    }      
     
    static member fromArray (a : d4M[]) act =
        {
         W = a.[0]
         b = a.[1]
         a = act
        }

    static member createRandomLayer (n,c,h,w as nchw) act =
        {
         W = d4M.makeUniformRandomNode nchw
         b = d4M.makeUniformRandomNode (1,n,1,1)
         a = act
        } 

    member l.runLayer (convPars,x:d4M) =
        linear_layer_conv [|convPars,x,l.W|] (Some l.b)
        |> l.a

    member l.ToArray = [|l.W;l.b|]
    member t.ResetAdjoints () = t.W.setZeroAdjoint(); t.b.setZeroAdjoint()
    member t.SGD learning_rate = saxpy -learning_rate t.W.A' t.W.P'; saxpy -learning_rate t.b.A' t.b.P'


type INNet =
      abstract member ResetAdjoints : unit -> unit
      abstract member SGD : learning_rate:float32 -> unit
      abstract member ToArray : d4M []
      abstract member inference : x:d4M -> d4M
      abstract member runLayer : x:d4M -> d4M
      abstract member train : x:d4M -> (unit -> float) -> d4M

// A fully connected feedforward layer of neurons
//type FullyConnectedLayer = FeedforwardLayer
type FeedforwardLayer =
    {
    W : d4M  // Input weight matrix
    b : d4M  // Bias vector
    a : d4M -> d4M
    } with     // Activation function

    static member fromArray (a : d4M[]) act =
        {
         W = a.[0]
         b = a.[1]
         a = act
        }

    static member createRandomLayer (n,c,h,w as nchw) act =
        {
         W = d4M.makeUniformRandomNode nchw
         b = d4M.makeUniformRandomNode (1,c,1,1)
         a = act
        } 

    static member inline create = FeedforwardLayer.createRandomLayer

    interface INNet with
        member l.runLayer (x:d4M) =
            linear_layer_matmult [|l.W,x|] (Some l.b) |> l.a

        /// This second attribute is supposed to be the exponential factor from the BN layer, but it is not used here.
        member l.train (x: d4M) _ = (l :> INNet).runLayer x

        member l.inference (x: d4M) = (l :> INNet).runLayer x

        member l.ToArray = [|l.W;l.b|]
        member t.ResetAdjoints () = t.W.setZeroAdjoint(); t.b.setZeroAdjoint()
        member t.SGD learning_rate = saxpy -learning_rate t.W.A' t.W.P'; saxpy -learning_rate t.b.A' t.b.P'

type ResidualFeedforwardLayer =
    {
    W1 : d4M  // Input weight matrix
    b1 : d4M  // Bias vector
    a1 : d4M -> d4M
    W2 : d4M  // Input weight matrix
    b2 : d4M  // Bias vector
    a2 : d4M -> d4M
    } with     // Activation function
     
    static member fromArray (a : d4M[]) act1 act2 =
        {
         W1 = a.[0]
         b1 = a.[1]
         a1 = act1
         W2 = a.[2]
         b2 = a.[3]
         a2 = act2
        }

    static member createRandomLayer (n,c,h,w as nchw) act1 act2 =
        {
         W1 = d4M.makeUniformRandomNode nchw
         b1 = d4M.makeUniformRandomNode (1,c,1,1)
         a1 = act1
         W2 = d4M.makeUniformRandomNode nchw
         b2 = d4M.makeUniformRandomNode (1,c,1,1)
         a2 = act2
        } 

    static member inline create = ResidualFeedforwardLayer.createRandomLayer

    interface INNet with
        member l.runLayer (x:d4M) =
            linear_layer_matmult [|l.W1,x|] (Some l.b1) |> l.a1
            |> fun p -> linear_layer_matmult [|l.W2,p|] (Some l.b2)
            |> fun p -> add 1.0f p 1.0f x |> l.a2
        
        /// This second attribute is supposed to be the exponential factor from the BN layer, but it is not used here.
        member l.train (x: d4M) _ = (l :> INNet).runLayer x

        member l.inference (x: d4M) = (l :> INNet).runLayer x

        member l.ToArray = [|l.W1;l.b1;l.W2;l.b2|]
        member t.ResetAdjoints () = t.W1.setZeroAdjoint(); t.b1.setZeroAdjoint(); t.W2.setZeroAdjoint(); t.b2.setZeroAdjoint()
        member t.SGD learning_rate = 
            saxpy -learning_rate t.W1.A' t.W1.P'; saxpy -learning_rate t.b1.A' t.b1.P'
            saxpy -learning_rate t.W2.A' t.W2.P'; saxpy -learning_rate t.b2.A' t.b2.P'


/// The initialization parameter for this is based off the weights and not the constructor.
/// Can be used for feedforward nets assuming the last two dimensions are 1. Uses the spatial normalization mode.
type BNConvolutionalLayer =
    {
    W : d4M  // Input weight tensor
    bnScale : d4M  // Scale tensor
    bnBias : d4M  // Bias tensor
    bnRunningMean : d4M  // Mean tensor
    bnRunningVariance : d4M  // Variance tensor
    a : d4M -> d4M // Activation function
    }      

    static member create weight_nchw a =
        let W = d4M.makeUniformRandomNode weight_nchw
        let bias_sizes = weight_nchw |> fun (n,c,h,w) -> (1,n,1,1)

        let bnScale = bias_sizes |> d4M.create 
        bnScale.setPrimal 0.1f // Initial scale value based on the Recurrent Batch Normalization paper by Cooijmans et al.
        bnScale.setZeroAdjoint()
        let bnBias = bias_sizes |> d4M.create
        bnBias.setZeroPrimal()
        bnBias.setZeroAdjoint()
        let bnRunningMean = bias_sizes |> d4M.createConstant
        let bnRunningVariance = bias_sizes |> d4M.createConstant

        { W = W; bnScale = bnScale; bnBias = bnBias; bnRunningMean = bnRunningMean; bnRunningVariance = bnRunningVariance; a=a  }

    member t.train (convPars,input:d4M) exponentialAverageFactor = 
        let bnMode = cudnnBatchNormMode.BatchNormSpatial
        convolution_forward convPars input t.W
        |> batch_normalization_forward bnMode t.bnScale t.bnBias t.bnRunningMean t.bnRunningVariance exponentialAverageFactor false
        |> t.a
    member t.inference (convPars,input:d4M) = 
        let bnMode = cudnnBatchNormMode.BatchNormSpatial
        convolution_forward convPars input t.W
        |> batch_normalization_forward bnMode t.bnScale t.bnBias t.bnRunningMean t.bnRunningVariance 1.0 true
        |> t.a

    member l.ToArray = [|l.W;l.bnScale;l.bnBias;l.bnRunningMean;l.bnRunningVariance|]
    member l.ResetAdjoints () = 
        l.W.setZeroAdjoint();l.bnScale.setZeroAdjoint();
        l.bnBias.setZeroAdjoint()
    member t.SGD learning_rate = 
        saxpy -learning_rate t.W.A' t.W.P'
        saxpy -learning_rate t.bnScale.A' t.bnScale.P'
        saxpy -learning_rate t.bnBias.A' t.bnBias.P'

type BNFullyConnectedLayer =
    {
    W : d4M  // Input weight tensor
    bnScale : d4M  // Scale tensor
    bnBias : d4M  // Bias tensor
    bnRunningMean : d4M  // Mean tensor
    bnRunningVariance : d4M  // Variance tensor
    a : d4M -> d4M // Activation function
    }      

    /// Creates a layer with random weights.
    static member create weight_nchw a =
        let W = d4M.makeUniformRandomNode weight_nchw
        let bias_sizes = weight_nchw |> fun (n,c,h,w) -> (1,c,1,1)

        let bnScale = bias_sizes |> d4M.create 
        bnScale.setPrimal 0.1f // Initial scale value based on the Recurrent Batch Normalization paper by Cooijmans et al.
        bnScale.setZeroAdjoint()
        let bnBias = bias_sizes |> d4M.create
        bnBias.setZeroPrimal()
        bnBias.setZeroAdjoint()
        let bnRunningMean = bias_sizes |> d4M.createConstant
        let bnRunningVariance = bias_sizes |> d4M.createConstant

        { W = W; bnScale = bnScale; bnBias = bnBias; bnRunningMean = bnRunningMean; bnRunningVariance = bnRunningVariance; a=a  }

    interface INNet with
        member t.train input exponentialAverageFactor = 
            let bnMode = cudnnBatchNormMode.BatchNormSpatial
            matmult t.W input
            |> batch_normalization_forward bnMode t.bnScale t.bnBias t.bnRunningMean t.bnRunningVariance (exponentialAverageFactor()) false
            |> t.a
        member t.inference input = 
            let bnMode = cudnnBatchNormMode.BatchNormSpatial
            matmult t.W input
            |> batch_normalization_forward bnMode t.bnScale t.bnBias t.bnRunningMean t.bnRunningVariance 1.0 true
            |> t.a

        member t.runLayer x = (t :> INNet).inference x

        member l.ToArray = [|l.W;l.bnScale;l.bnBias;l.bnRunningMean;l.bnRunningVariance|]
        member l.ResetAdjoints () = 
            l.W.setZeroAdjoint();l.bnScale.setZeroAdjoint();
            l.bnBias.setZeroAdjoint()
        member t.SGD learning_rate = 
            saxpy -learning_rate t.W.A' t.W.P'
            saxpy -learning_rate t.bnScale.A' t.bnScale.P'
            saxpy -learning_rate t.bnBias.A' t.bnBias.P'

type BNResidualFullyConnectedLayer =
    {
    W1 : d4M  // Input weight tensor
    bnScale1 : d4M  // Scale tensor
    bnBias1 : d4M  // Bias tensor
    bnRunningMean1 : d4M  // Mean tensor
    bnRunningVariance1 : d4M  // Variance tensor
    a1 : d4M -> d4M // Activation function

    W2 : d4M  // Input weight tensor
    bnScale2 : d4M  // Scale tensor
    bnBias2 : d4M  // Bias tensor
    bnRunningMean2 : d4M  // Mean tensor
    bnRunningVariance2 : d4M  // Variance tensor
    a2 : d4M -> d4M // Activation function
    }      

    /// Creates a layer with random weights.
    static member create weight_nchw a1 a2 =
        let bias_sizes = weight_nchw |> fun (n,c,h,w) -> (1,c,1,1)
        
        let W1 = d4M.makeUniformRandomNode weight_nchw
        let bnScale1 = bias_sizes |> d4M.create 
        bnScale1.setPrimal 0.1f // Initial scale value based on the Recurrent Batch Normalization paper by Cooijmans et al.
        bnScale1.setZeroAdjoint()
        let bnBias1 = bias_sizes |> d4M.create
        bnBias1.setZeroPrimal()
        bnBias1.setZeroAdjoint()
        let bnRunningMean1 = bias_sizes |> d4M.createConstant
        let bnRunningVariance1 = bias_sizes |> d4M.createConstant

        let W2 = d4M.makeUniformRandomNode weight_nchw
        let bnScale2 = bias_sizes |> d4M.create 
        bnScale2.setPrimal 0.1f // Initial scale value based on the Recurrent Batch Normalization paper by Cooijmans et al.
        bnScale2.setZeroAdjoint()
        let bnBias2 = bias_sizes |> d4M.create
        bnBias2.setZeroPrimal()
        bnBias2.setZeroAdjoint()
        let bnRunningMean2 = bias_sizes |> d4M.createConstant
        let bnRunningVariance2 = bias_sizes |> d4M.createConstant

        { W1 = W1; bnScale1 = bnScale1; bnBias1 = bnBias1; bnRunningMean1 = bnRunningMean1; bnRunningVariance1 = bnRunningVariance1; a1=a1;
          W2 = W2; bnScale2 = bnScale2; bnBias2 = bnBias2; bnRunningMean2 = bnRunningMean2; bnRunningVariance2 = bnRunningVariance2; a2=a2  }


    interface INNet with
        member t.train input exponentialAverageFactor = 
            let bnMode = cudnnBatchNormMode.BatchNormPerActivation
            matmult t.W1 input
            |> batch_normalization_forward bnMode t.bnScale1 t.bnBias1 t.bnRunningMean1 t.bnRunningVariance1 (exponentialAverageFactor()) false
            |> t.a1
            |> matmult t.W2
            |> batch_normalization_forward bnMode t.bnScale2 t.bnBias2 t.bnRunningMean2 t.bnRunningVariance2 (exponentialAverageFactor()) false
            |> fun p -> add 1.0f p 1.0f input
            |> t.a2

        member t.inference input = 
            let bnMode = cudnnBatchNormMode.BatchNormPerActivation
            matmult t.W1 input
            |> batch_normalization_forward bnMode t.bnScale1 t.bnBias1 t.bnRunningMean1 t.bnRunningVariance1 1.0 true
            |> t.a1
            |> matmult t.W2
            |> batch_normalization_forward bnMode t.bnScale2 t.bnBias2 t.bnRunningMean2 t.bnRunningVariance2 1.0 true
            |> fun p -> add 1.0f p 1.0f input
            |> t.a2

        member t.runLayer x = (t :> INNet).inference x

        member l.ToArray = [|l.W1;l.bnScale1;l.bnBias1;l.bnRunningMean1;l.bnRunningVariance1;l.W2;l.bnScale2;l.bnBias2;l.bnRunningMean2;l.bnRunningVariance2|]
        member l.ResetAdjoints () = 
            l.W1.setZeroAdjoint();l.bnScale1.setZeroAdjoint();l.bnBias1.setZeroAdjoint()
            l.W2.setZeroAdjoint();l.bnScale2.setZeroAdjoint();l.bnBias2.setZeroAdjoint()
        member t.SGD learning_rate = 
            saxpy -learning_rate t.W1.A' t.W1.P'
            saxpy -learning_rate t.bnScale1.A' t.bnScale1.P'
            saxpy -learning_rate t.bnBias1.A' t.bnBias1.P'

            saxpy -learning_rate t.W2.A' t.W2.P'
            saxpy -learning_rate t.bnScale2.A' t.bnScale2.P'
            saxpy -learning_rate t.bnBias2.A' t.bnBias2.P'

/// Adapted from the previous version of the library.
/// An optimized implementation will be done in the future along with union types and streams.
type LSTMLayer =
    {W_z:d4M  // Input weight matrix for the block input
     U_z:d4M  // Recurrent weight matrix for the block input
     b_z:d4M  // Bias vector for the block input

     W_i:d4M  // Input weight matrix for the input gate
     U_i:d4M  // Recurrent weight matrix for the input gate
     b_i:d4M  // Bias vector for the input gate
     P_i:d4M  // Peephole weight matrix for the input gate

     W_f:d4M  // Input weight matrix for the forget gate
     U_f:d4M  // Recurrent weight matrix for the forget gate
     b_f:d4M  // Bias vector for the forget gate
     P_f:d4M  // Peephole weight matrix for the forget gate

     W_o:d4M  // Input weight matrix for the output gate
     U_o:d4M  // Recurrent weight matrix for the output gate
     b_o:d4M  // Bias vector for the output gate
     P_o:d4M  // Peephole weight matrix for the output gate

     block_input_a : d4M -> d4M
     block_output_a : d4M -> d4M
     } 
    
    /// Returns all the weights in an array.
    member l.ToArray = [|l.W_z;l.U_z;l.b_z;l.W_i;l.U_i;l.b_i;l.P_i;l.W_f;l.U_f;l.b_f;l.P_f;l.W_o;l.U_o;l.b_o;l.P_o|]
    static member fromArray (a: d4M[]) block_input_a block_output_a =
        {
         W_z = a.[0]
         U_z = a.[1]
         b_z = a.[2]

         W_i = a.[3]
         U_i = a.[4]
         b_i = a.[5]
         P_i = a.[6]

         W_f = a.[7]
         U_f = a.[8]
         b_f = a.[9]
         P_f = a.[10]

         W_o = a.[11]
         U_o = a.[12]
         b_o = a.[13]
         P_o = a.[14]

         block_input_a = block_input_a
         block_output_a = block_output_a
        }

    static member createRandomLSTMLayer input_size hidden_size block_input_a block_output_a =
        {
        W_z = d4M.makeUniformRandomNode (input_size, hidden_size, 1, 1)
        U_z = d4M.makeUniformRandomNode (hidden_size, hidden_size, 1, 1)
        b_z = d4M.makeUniformRandomNode (1, hidden_size, 1, 1)
        W_i = d4M.makeUniformRandomNode (input_size, hidden_size, 1, 1)
        U_i = d4M.makeUniformRandomNode (hidden_size, hidden_size, 1, 1)
        b_i = d4M.makeUniformRandomNode (1, hidden_size, 1, 1)
        P_i = d4M.makeUniformRandomNode (hidden_size, hidden_size, 1, 1)
        W_f = d4M.makeUniformRandomNode (input_size, hidden_size, 1, 1)
        U_f = d4M.makeUniformRandomNode (hidden_size, hidden_size, 1, 1)
        b_f = d4M.makeUniformRandomNode (1, hidden_size, 1, 1)
        P_f = d4M.makeUniformRandomNode (hidden_size, hidden_size, 1, 1)
        W_o = d4M.makeUniformRandomNode (input_size, hidden_size, 1, 1)
        U_o = d4M.makeUniformRandomNode (hidden_size, hidden_size, 1, 1)
        b_o = d4M.makeUniformRandomNode (1, hidden_size, 1, 1)
        P_o = d4M.makeUniformRandomNode (hidden_size, hidden_size, 1, 1)

        block_input_a = block_input_a
        block_output_a = block_output_a
        }

    member l.runLayer (x:d4M) (y:d4M) (c:d4M) =
        let block_input = linear_layer_matmult [|l.W_z,x;l.U_z,y|] (Some l.b_z) |> l.block_input_a
        let input_gate = linear_layer_matmult [|l.W_i,x;l.U_i,y;l.P_i,c|] (Some l.b_i) |> sigmoid
        let forget_gate = linear_layer_matmult [|l.W_f,x;l.U_f,y;l.P_f,c|] (Some l.b_f) |> sigmoid
        let c' = linear_layer_hadmult [|block_input,input_gate;c,forget_gate|]
        let output_gate = linear_layer_matmult [|l.W_o,x;l.U_o,y;l.P_o,c'|] (Some l.b_o) |> sigmoid
        hadmult (l.block_output_a c') output_gate, c'

    member l.runLayerNoH (x:d4M) =
        let block_input = linear_layer_matmult [|l.W_z,x|] (Some l.b_z) |> l.block_input_a
        let input_gate = linear_layer_matmult [|l.W_i,x|] (Some l.b_i) |> sigmoid
        let forget_gate = linear_layer_matmult [|l.W_f,x|] (Some l.b_f) |> sigmoid
        let c' = hadmult block_input input_gate
        let output_gate = linear_layer_matmult [|l.W_o,x;l.P_o,c'|] (Some l.b_o) |> sigmoid
        hadmult (l.block_output_a c') output_gate, c'

    member l.runLayerNoI (y:d4M) (c:d4M) =
        let block_input = linear_layer_matmult [|l.U_z,y|] (Some l.b_z) |> l.block_input_a
        let input_gate = linear_layer_matmult [|l.U_i,y;l.P_i,c|] (Some l.b_i) |> sigmoid
        let forget_gate = linear_layer_matmult [|l.U_f,y;l.P_f,c|] (Some l.b_f) |> sigmoid
        let c' = linear_layer_hadmult [|block_input,input_gate;c,forget_gate|]
        let output_gate = linear_layer_matmult [|l.U_o,y;l.P_o,c'|] (Some l.b_o) |> sigmoid
        hadmult (l.block_output_a c') output_gate, c'


let load_data file_name is_constant =
    use stream_data = IO.File.OpenRead(file_name)
    use reader_data = new IO.BinaryReader(stream_data)

    let m = reader_data.ReadInt32()
    if m <> 929856 then failwith "Wrong file type in load_weights"

    let l = reader_data.ReadInt32()
    let weights = [|
        for i=1 to l do
            let num_rows = reader_data.ReadInt32()
            let num_cols = reader_data.ReadInt32()
            let ar = [|for x=1 to num_rows*num_cols do yield reader_data.ReadSingle()|]
            match is_constant with
            | true -> yield d4M.createConstant(num_cols,num_rows,1,1,ar)
            | false -> yield d4M.create(num_cols,num_rows,1,1,ar)
        |]

    weights
