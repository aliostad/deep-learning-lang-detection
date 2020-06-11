#if INTERACTIVE
fsi.ShowDeclarationValues <- false
fsi.ShowProperties <- false
fsi.ShowIEnumerable <- false
#endif

// The Spiral library v1. Basic reverse mode AD on the GPU.

#r "../packages/ManagedCuda-75-x64.7.5.7/lib/net45/x64/ManagedCuda.dll"
#r "../packages/ManagedCuda-75-x64.7.5.7/lib/net45/x64/NVRTC.dll"
#r "../packages/ManagedCuda-75-x64.7.5.7/lib/net45/x64/CudaBlas.dll"
#r "../packages/ManagedCuda-75-x64.7.5.7/lib/net45/x64/CudaRand.dll"
#r "../packages/ManagedCuda-75-x64.7.5.7/lib/net45/x64/NPP.dll"
#r "../packages/ManagedCuda-CudaDNN.3.0/lib/net45/CudaDNN.dll"

// Open up the namespaces.
open ManagedCuda
open ManagedCuda.BasicTypes
open ManagedCuda.VectorTypes
open ManagedCuda.CudaBlas
open ManagedCuda.CudaRand
open ManagedCuda.NVRTC
open ManagedCuda.CudaDNN

open System
open System.IO
open System.Collections

// Initialize the context. Analogous to a CPU process. Cuda tries to offload as much as possible during context creation so there aren't
// any unexpected delays later.
let ctx = new CudaContext()
let numSm = ctx.GetDeviceInfo().MultiProcessorCount // The number of streaming multiprocessors on the device.

// Make a stream class.
let str = new CudaStream()
// Set the Cuda libraries handles to the above stream.
let cublas = CudaBlas(str.Stream,PointerMode.Host,AtomicsMode.Allowed) // Better performance for some solver functions with atomics allowed.
let cudnn = new CudaDNN.CudaDNNContext()
cudnn.SetStream(str)
let cudaRandom = new CudaRand.CudaRandDevice(GeneratorType.PseudoDefault)
cudaRandom.SetStream(str.Stream)

// Type aliasing trick to make Spiral more generic. It is incomplete at the moment though due to Cuda math function being non-overloadable.
type floatType = float32
let inline floatType x = float32 x
let FloatTypeCpp = "float"

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

/// The main matrix type.
type dMatrix =
    {
    mutable num_rows:int
    mutable num_cols:int
    mutable dArray: CudaDeviceVariable<floatType>
    }  

    /// The main create function. A substitute for the constructor.
    static member create(num_rows: int,num_cols,dArray: CudaDeviceVariable<floatType>) =
        {num_rows=num_rows;num_cols=num_cols;dArray=dArray}

    /// Throws an exception if it tries to allocate an array of size 0.
    static member create(num_rows: int,num_cols) =
        let q = (num_rows*num_cols) |> SizeT
        let t = new CudaDeviceVariable<floatType>(q)
        {num_rows=num_rows;num_cols=num_cols;dArray=t}

    /// Copies a host to a device array.
    /// Throws an exception if it tries to allocate an array of size 0.
    static member create(num_rows: int,num_cols,dArray: floatType[]) =
        let q = num_rows*num_cols
        if dArray.Length <> q then failwith "Invalid size in dMatrix construction."
        let t = to_dev dArray
        {num_rows=num_rows;num_cols=num_cols;dArray=t}

    /// Returns a new instance of an (dMatrix.createEmpty) dMatrix.
    /// Unlike the let statements, the member statements are always reevaluated.
    static member createEmpty = dMatrix.create(0,0,CudaDeviceVariable.Null)

    /// Returns num_rows, num_cols as a tuple
    member inline t.rc = t.num_rows, t.num_cols
    /// Sets the matrix to zero.
    member inline t.setZero() = t.dArray.MemsetAsync(0u,str.Stream)
    /// Set the matrix to a value.
    member inline t.set (x: floatType) = 
        let v = BitConverter.ToUInt32(BitConverter.GetBytes(x),0)
        t.dArray.MemsetAsync(v,str.Stream)
    /// Creates a copy of this matrix with all the values set to zero.
    member inline t.zeroLike() =
        let c = dMatrix.create(t.num_rows,t.num_cols)
        c.setZero()
        c
    /// Copies a matrix.
    member inline t.copy() =
        let c = dMatrix.create(t.num_rows,t.num_cols)
        c.dArray.AsyncCopyToDevice(t.dArray,str)
        c

    /// Resized the dArray if the current one is less than nr*nc. Otherwise it only adjusts num_rows and num_cols.
    member inline t.ReplaceIf nr nc =
        if int t.dArray.Size < nr*nc 
        then
            (t :> IDisposable).Dispose()
            t.num_rows <- nr
            t.num_cols <- nc
            t.dArray <- new_dev (nr*nc)
        else
            t.num_rows <- nr
            t.num_cols <- nc

    /// Copies a matrix to a host array.
    member inline t.Gather() =
        let h_a = Array.zeroCreate<floatType> (int t.dArray.Size)
        t.dArray.CopyToHost(h_a)
        h_a

    member inline t.isEmpty = t.dArray.Equals(CudaDeviceVariable.Null)

    /// The unmanaged Cuda memory has to be freed explicitly or by letting go of the context by resetting  the F# Interactive.
    /// Finalizers work really poorly and can lead to unpredictable bugs when used to manage Cuda memory.
    interface IDisposable with
        member t.Dispose() = 
            if t.isEmpty = false then
                t.dArray.Dispose()

let T = Operation.Transpose
let nT = Operation.NonTranspose

/// General matrix-matrix multiply from cuBLAS.
let gemm transa transb (alpha: floatType) (A:dMatrix) (B:dMatrix) =
    let a_col = if transa = nT then A.num_cols else A.num_rows
    let b_row = if transb = nT then B.num_rows else B.num_cols
    if a_col <> b_row then failwith (sprintf "a_col <> b_row in gemm! %i <> %i" a_col b_row)
    let m = if transa = nT then A.num_rows else A.num_cols
    let n = if transb = nT then B.num_cols else B.num_rows
    let k = a_col

    let lda = if transa = nT then m else k
    let ldb = if transb = nT then k else n
    let ldc = m

    let C_dArray = new CudaDeviceVariable<floatType>(m*n |> SizeT)
    cublas.Gemm(transa, transb, m, n, k, alpha, A.dArray, lda, B.dArray, ldb, 0.0f, C_dArray, ldc)
    dMatrix.create(m,n,C_dArray)

/// General matrix-matrix multiply from cuBLAS. Inplace version
let gemm2 transa transb (alpha: floatType) (A:dMatrix) (B:dMatrix) beta (C:dMatrix) =
    let a_col = if transa = nT then A.num_cols else A.num_rows
    let b_row = if transb = nT then B.num_rows else B.num_cols
    if a_col <> b_row then failwith (sprintf "a_col <> b_row in gemm! %i <> %i" a_col b_row)
    let m = if transa = nT then A.num_rows else A.num_cols
    let n = if transb = nT then B.num_cols else B.num_rows
    let k = a_col

    let lda = if transa = nT then m else k
    let ldb = if transb = nT then k else n
    let ldc = m

    let C_dArray = C.dArray
    if m <> C.num_rows || n <> C.num_cols then failwith "m <> C.num_rows || n <> C.num_cols in gemm2"

    cublas.Gemm(transa, transb, m, n, k, alpha, A.dArray, lda, B.dArray, ldb, beta, C_dArray, ldc)

/// General matrix-matrix addition.
let geam transa transb (alpha: floatType) (A:dMatrix) beta (B:dMatrix) =
    let a_row = if transa = nT then A.num_rows else A.num_cols
    let a_col = if transa = nT then A.num_cols else A.num_rows
    let b_row = if transb = nT then B.num_rows else B.num_cols
    let b_col = if transb = nT then B.num_cols else B.num_rows
        
    if a_row <> b_row then failwith (sprintf "a_row <> b_row in geam! %i <> %i" a_row b_row)
    if a_col <> b_col then failwith (sprintf "a_col <> b_col in geam! %i <> %i" a_col b_col)

    let lda = if transa = nT then a_row else a_col
    let ldb = if transa = nT then b_row else b_col
    let ldc = a_row

    let C_dArray = new CudaDeviceVariable<floatType>(a_row*a_col |> SizeT)
    cublas.Geam(transa, transb, a_row, a_col, alpha, A.dArray, lda, B.dArray, ldb, beta, C_dArray, ldc)
    dMatrix.create(a_row,a_col,C_dArray)

/// General matrix-matrix addition. Inplace version.
let geam2 transa transb (alpha: floatType) (A:dMatrix) beta (B:dMatrix) (C:dMatrix) =
    let a_row = if transa = nT then A.num_rows else A.num_cols
    let a_col = if transa = nT then A.num_cols else A.num_rows
    let b_row = if transb = nT then B.num_rows else B.num_cols
    let b_col = if transb = nT then B.num_cols else B.num_rows
        
    if a_row <> b_row then failwith (sprintf "a_row <> b_row in geam2! %i <> %i" a_row b_row)
    if a_col <> b_col then failwith (sprintf "a_col <> b_col in geam2! %i <> %i" a_col b_col)

    if a_row <> C.num_rows then failwith (sprintf "a_row <> C.num_rows in geam2! %i <> %i" a_col b_col)
    if a_col <> C.num_cols then failwith (sprintf "a_col <> C.num_cols in geam2! %i <> %i" a_col b_col)

    let lda = if transa = nT then a_row else a_col
    let ldb = if transa = nT then b_row else b_col
    let ldc = a_row

    cublas.Geam(transa, transb, a_row, a_col, alpha, A.dArray, lda, B.dArray, ldb, beta, C.dArray, ldc)

let inline transpose t = geam T T 1.0f t 0.0f t // Transpose function


let biasTensorDesc = new TensorDescriptor()
let dstTensorDesc = new TensorDescriptor()
let SpiralCuDNNDataType = 
    if typeof<floatType> = typeof<float32> then cudnnDataType.Float
    else if typeof<floatType> = typeof<float> then cudnnDataType.Double
    else failwith "cudnnDataType not supported."

///o <- beta*mat + alpha*vec (matrix-vector broadcast addition)
let broadcastAdd beta (mat: dMatrix) alpha (vec: dMatrix) =
    let TensorFormat = cudnnTensorFormat.NCHW;
    biasTensorDesc.SetTensor4dDescriptor(TensorFormat, SpiralCuDNNDataType, 1, 1, vec.num_rows, vec.num_cols)
    dstTensorDesc.SetTensor4dDescriptor(TensorFormat, SpiralCuDNNDataType, 1, mat.num_cols, mat.num_rows, 1)
    let copy_mat = mat.copy()
    cudnn.AddTensor(alpha,biasTensorDesc,vec.dArray,beta,dstTensorDesc,copy_mat.dArray)
    copy_mat
    
///mat <- beta*mat + alpha*vec (matrix-vector broadcast addition)
let broadcastAdd2 beta (mat: dMatrix) alpha (vec: dMatrix) =
    let TensorFormat = cudnnTensorFormat.NCHW;
    biasTensorDesc.SetTensor4dDescriptor(TensorFormat, SpiralCuDNNDataType, 1, 1, vec.num_rows, vec.num_cols)
    dstTensorDesc.SetTensor4dDescriptor(TensorFormat, SpiralCuDNNDataType, 1, mat.num_cols, mat.num_rows, 1)
    cudnn.AddTensor(alpha,biasTensorDesc,vec.dArray,beta,dstTensorDesc,mat.dArray)

/// o <- sum_across_channels(alpha*mat)
/// For 2D matrices, channels are the columns.
/// The function sums along the rows.
let rowSum alpha (mat: dMatrix) =
    let TensorFormat = cudnnTensorFormat.NHWC;
    dstTensorDesc.SetTensor4dDescriptor(TensorFormat, SpiralCuDNNDataType, 1, mat.num_rows, 1, mat.num_cols)
    
    let vec = dMatrix.create(mat.num_rows,1)
    biasTensorDesc.SetTensor4dDescriptor(TensorFormat, SpiralCuDNNDataType, 1, vec.num_rows, 1, vec.num_cols)
    
    cudnn.ConvolutionBackwardBias(alpha,dstTensorDesc,mat.dArray,0.0f,biasTensorDesc,vec.dArray)
    vec

/// vec <- sum_across_channels(alpha*mat)+beta*vec
/// For 2D matrices, channels are the columns.
/// The function sums along the rows.
let rowSum2 alpha (mat: dMatrix) beta (vec: dMatrix) =
    let TensorFormat = cudnnTensorFormat.NHWC;
    dstTensorDesc.SetTensor4dDescriptor(TensorFormat, SpiralCuDNNDataType, 1, mat.num_rows, 1, mat.num_cols)
    biasTensorDesc.SetTensor4dDescriptor(TensorFormat, SpiralCuDNNDataType, 1, mat.num_rows, 1, vec.num_cols)
    
    cudnn.ConvolutionBackwardBias(alpha,dstTensorDesc,mat.dArray,beta,biasTensorDesc,vec.dArray)
    
type dMatrix with
    /// For accessing individual elements with the .[a,b] syntax.
    member t.Item
        with get(a: int, b: int) = t.dArray.[a+b*t.num_rows |> SizeT]
        and set(a: int, b: int) (value: floatType) = t.dArray.[a+b*t.num_rows |> SizeT] <- value

    /// For displaying column majors matrices inside Array2D (which is row major.)
    member inline t.Gather'() =
            let h_a = Array2D.zeroCreate<floatType> t.num_rows t.num_cols
            use t' = transpose t // Transpose to row major. The use keyword ensures that it is disposed automatically as soon as it goes out of scope.
            t'.dArray.CopyToHost(h_a) // Copy directly to host array.
            h_a


let inline divup a b = (a+b-1)/b // Integer division with rounding up. (a-1)/b+1 is another variant on this.

/// o <- f(x)
type DeviceUnaryTransformModule(op: string) = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __device__ inline "+FloatTypeCpp+" op("+FloatTypeCpp+" x)
            {
                return "+op+"
            }
        
            // Device code
            __global__ void Map1Kernel(const "+FloatTypeCpp+"* A, "+FloatTypeCpp+"* O, const int N)
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

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"Map1Kernel")
    do  
        try k.Compile([||])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"Map1Kernel")

    member t.A(x: CudaDeviceVariable<floatType>, n) =
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(x: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>, n) =
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,o.DevicePointer,n) |> ignore

    member t.A(x: dMatrix) =
        let o = dMatrix.create(x.num_rows,x.num_cols)
        t.A(x,o)
        o

    member t.A(x: dMatrix, o: dMatrix) =
        if x.rc <> o.rc then failwith "x.rc <> o.rc in DeviceUnaryTransformModule"
        t.A(x.dArray,o.dArray,x.num_rows*x.num_cols)

/// o <- f(x,y)
type DeviceBinaryTransformModule(op: string) = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __device__ inline "+FloatTypeCpp+" op("+FloatTypeCpp+" x, "+FloatTypeCpp+" y)
            {
                return "+op+"
            }
        
            // Device code
            __global__ void Map2Kernel(const "+FloatTypeCpp+"* A, const "+FloatTypeCpp+"* B, "+FloatTypeCpp+"* O, const int N)
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

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"Map2Kernel")
    do  
        try k.Compile([||])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"Map2Kernel")

    member t.A(x: CudaDeviceVariable<floatType>, y: CudaDeviceVariable<floatType>, n) =
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(x: CudaDeviceVariable<floatType>, y: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>, n) =
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,o.DevicePointer,n) |> ignore

    member t.A(x: dMatrix, y: dMatrix) =
        let o = dMatrix.create(x.num_rows,x.num_cols)
        t.A(x,y,o)
        o

    member t.A(x: dMatrix, y: dMatrix, o: dMatrix) =
        if x.rc <> y.rc then failwith "x.rc <> y.rc in DeviceBinaryTransformModule"
        if y.rc <> o.rc then failwith "y.rc <> o.rc in DeviceBinaryTransformModule"
        t.A(x.dArray,y.dArray,o.dArray,x.num_rows*x.num_cols)

/// o <- f(x,y,z)
type DeviceTrinaryTransformModule(op: string) = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __device__ inline "+FloatTypeCpp+" op("+FloatTypeCpp+" x, "+FloatTypeCpp+" y, "+FloatTypeCpp+" z)
            {
                return "+op+"
            }
        
            // Device code
            __global__ void Map3Kernel(const "+FloatTypeCpp+"* A, const "+FloatTypeCpp+"* B, const "+FloatTypeCpp+"* C, "+FloatTypeCpp+"* O, const int N)
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

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"Map3Kernel")
    do  
        try k.Compile([||])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"Map3Kernel")

    member t.A(x: CudaDeviceVariable<floatType>, y: CudaDeviceVariable<floatType>, z: CudaDeviceVariable<floatType>, n) =
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,z.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(x: CudaDeviceVariable<floatType>, y: CudaDeviceVariable<floatType>, z: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>,n) =
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,z.DevicePointer,o.DevicePointer,n) |> ignore

    member t.A(x: dMatrix, y: dMatrix, z: dMatrix) =
        let o = dMatrix.create(x.num_rows,x.num_cols)
        t.A(x,y,z,o)
        o

    member t.A(x: dMatrix, y: dMatrix, z: dMatrix, o: dMatrix) =
        if x.rc <> y.rc then failwith "x.rc <> y.rc in DeviceTrinaryTransformModule"
        if y.rc <> z.rc then failwith "y.rc <> z.rc in DeviceTrinaryTransformModule"
        if z.rc <> o.rc then failwith "z.rc <> o.rc in DeviceTrinaryTransformModule"
        t.A(x.dArray,y.dArray,z.dArray,o.dArray,x.num_rows*x.num_cols)

/// o <- sum(f(x))
type DeviceUnaryMapSumModule(op: string) = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __device__ inline "+FloatTypeCpp+" op("+FloatTypeCpp+" x)
            {
                return "+op+"
            }
        
            __device__ inline "+FloatTypeCpp+" warpDownReduce("+FloatTypeCpp+" value){
                #pragma unroll
	            for (int i = 16; i>0; i = i / 2) value += __shfl_down(value, i);
	            return value;
            }

            // Device code
            __global__ void MapSumKernel(const "+FloatTypeCpp+"* A, "+FloatTypeCpp+"* O, const int N)
            {
	            int i = blockDim.x * blockIdx.x + threadIdx.x;
	            const int stride = blockDim.x * gridDim.x;
	            __shared__ "+FloatTypeCpp+" temp[32];
                if (threadIdx.x < 32) {
                    temp[threadIdx.x] = 0.0f; 
                    if (blockIdx.x == 0) O[0] = 0.0f;
                    }
                
                    "+FloatTypeCpp+" acc = 0.0f;
	            while (i < N)
	            {
		            acc += op(A[i]);
		            i += stride;
	            }
	            __syncthreads(); "+FloatTypeCpp+" out_partial = warpDownReduce(acc);
	            if (threadIdx.x % 32 == 0) temp[threadIdx.x / 32] = out_partial;
	            __syncthreads();
	            if (threadIdx.x < 32) out_partial = warpDownReduce(temp[threadIdx.x]);
	            if (threadIdx.x == 0) atomicAdd(O, out_partial);
            }
        }

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"MapSumKernel")
    do  
        try k.Compile([|"-arch=compute_30"|])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"MapSumKernel")
    let o = new_dev<floatType> 1

    member t.A(x: CudaDeviceVariable<floatType>, n) =
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,o.DevicePointer,n) |> ignore
        o.[SizeT 0]

    member t.A(x: dMatrix) =
        t.A(x.dArray, x.num_rows*x.num_cols)

/// o <- sum(f(x,y))
type DeviceBinaryMapSumModule(op: string) = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __device__ inline "+FloatTypeCpp+" op("+FloatTypeCpp+" x, "+FloatTypeCpp+" y)
            {
                return "+op+"
            }
        
            __device__ inline "+FloatTypeCpp+" warpDownReduce("+FloatTypeCpp+" value){
                #pragma unroll
	            for (int i = 16; i>0; i = i / 2) value += __shfl_down(value, i);
	            return value;
            }

            // Device code
            __global__ void Map2SumKernel(const "+FloatTypeCpp+"* A, const "+FloatTypeCpp+"* B, "+FloatTypeCpp+"* O, const int N)
            {
	            int i = blockDim.x * blockIdx.x + threadIdx.x;
	            const int stride = blockDim.x * gridDim.x;
	            __shared__ "+FloatTypeCpp+" temp[32]; 
                if (threadIdx.x < 32) {
                    temp[threadIdx.x] = 0.0f; 
                    if (blockIdx.x == 0) O[0] = 0.0f;
                    }    
                    "+FloatTypeCpp+" acc = 0.0f;
	            while (i < N)
	            {
		            acc += op(A[i],B[i]);
		            i += stride;
	            }
	            __syncthreads(); "+FloatTypeCpp+" out_partial = warpDownReduce(acc);
	            if (threadIdx.x % 32 == 0) temp[threadIdx.x / 32] = out_partial;
	            __syncthreads();
	            if (threadIdx.x < 32) out_partial = warpDownReduce(temp[threadIdx.x]);
	            if (threadIdx.x == 0) atomicAdd(O, out_partial);
            }
        }

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"Map2SumKernel")
    do  
        try k.Compile([|"-arch=compute_30"|])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"Map2SumKernel")
    let o = new_dev<floatType> 1

    member t.A(x: CudaDeviceVariable<floatType>,y: CudaDeviceVariable<floatType>,n) =
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,o.DevicePointer,n) |> ignore
        o.[SizeT 0]

    member t.A(x: dMatrix,y: dMatrix) =
        if x.rc <> y.rc then failwith "x.rc <> y.rc in DeviceBinaryMapSumModule"
        t.A(x.dArray,y.dArray,x.num_rows*x.num_cols)

/// o <- f(coef_x,x)
type DeviceUnaryCoefTransformModule(op: string) = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __device__ inline "+FloatTypeCpp+" op("+FloatTypeCpp+" coef_x, "+FloatTypeCpp+" x)
            {
                return "+op+"
            }
        
            // Device code
            __global__ void MapCoefKernel(const "+FloatTypeCpp+" coef_A, const "+FloatTypeCpp+"* A, "+FloatTypeCpp+"* O, const int N)
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

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"MapCoefKernel")
    do  
        try k.Compile([||])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"MapCoefKernel")

    member t.A(coef_x: floatType, x: CudaDeviceVariable<floatType>,n) =
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(coef_x: floatType, x: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>,n) =
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,o.DevicePointer,n) |> ignore

    member t.A(coef_x, x: dMatrix) =
        let o = dMatrix.create(x.num_rows,x.num_cols)
        t.A(coef_x,x,o)
        o

    member t.A(coef_x, x: dMatrix, o: dMatrix) =
        if x.rc <> o.rc then failwith "x.rc <> o.rc in DeviceUnaryCoefTransformModule"
        t.A(coef_x,x.dArray,o.dArray,x.num_rows*x.num_cols)

/// o <- f(coef_x,x,coef_y,y)
type DeviceBinaryCoefTransformModule(op: string) = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __device__ inline "+FloatTypeCpp+" op("+FloatTypeCpp+" coef_x, "+FloatTypeCpp+" x, "+FloatTypeCpp+" coef_y, "+FloatTypeCpp+" y)
            {
                return "+op+"
            }
        
            // Device code
            __global__ void MapCoef2Kernel(const "+FloatTypeCpp+" coef_A, const "+FloatTypeCpp+"* A, const "+FloatTypeCpp+" coef_B, const "+FloatTypeCpp+"* B, "+FloatTypeCpp+"* O, const int N)
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

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"MapCoef2Kernel")
    do  
        try k.Compile([||])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"MapCoef2Kernel")

    member t.A(coef_x: floatType, x: CudaDeviceVariable<floatType>,coef_y: floatType, y: CudaDeviceVariable<floatType>,n) =
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,coef_y, y.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(coef_x: floatType, x: CudaDeviceVariable<floatType>, coef_y: floatType, y: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>,n) =
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,coef_y,y.DevicePointer,o.DevicePointer,n) |> ignore

    member t.A(coef_x, x: dMatrix, coef_y, y: dMatrix) =
        let o = dMatrix.create(x.num_rows,x.num_cols)
        t.A(coef_x,x,coef_y,y,o)
        o

    member t.A(coef_x, x: dMatrix, coef_y, y: dMatrix, o: dMatrix) =
        if x.rc <> y.rc then failwith "x.rc <> y.rc in DeviceBinaryCoefTransformModule"
        if y.rc <> o.rc then failwith "y.rc <> o.rc in DeviceBinaryCoefTransformModule"
        t.A(coef_x,x.dArray,coef_y,y.dArray,o.dArray,x.num_rows*x.num_cols)

/// o <- f(coef_x,x,coef_y,y,coef_z,z)
type DeviceTrinaryCoefTransformModule(op: string) = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __device__ inline "+FloatTypeCpp+" op("+FloatTypeCpp+" coef_x, "+FloatTypeCpp+" x, "+FloatTypeCpp+" coef_y, "+FloatTypeCpp+" y, "+FloatTypeCpp+" coef_z, "+FloatTypeCpp+" z)
            {
                return "+op+"
            }
        
            // Device code
            __global__ void MapCoef3Kernel(const "+FloatTypeCpp+" coef_A, const "+FloatTypeCpp+"* A, const "+FloatTypeCpp+" coef_B, const "+FloatTypeCpp+"* B, const "+FloatTypeCpp+" coef_C, const "+FloatTypeCpp+"* C, "+FloatTypeCpp+"* O, const int N)
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

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"MapCoef3Kernel")
    do  
        try k.Compile([||])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"MapCoef3Kernel")

    member t.A(coef_x: floatType, x: CudaDeviceVariable<floatType>, coef_y: floatType, y: CudaDeviceVariable<floatType>, coef_z: floatType, z: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>,n) =
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,coef_y,y.DevicePointer,coef_z,z.DevicePointer,o.DevicePointer,n) |> ignore

    member t.A(coef_x, x: dMatrix, coef_y, y: dMatrix, coef_z, z: dMatrix) =
        let o = dMatrix.create(x.num_rows,x.num_cols)
        t.A(coef_x,x,coef_y,y,coef_z,z,o)
        o

    member t.A(coef_x, x: dMatrix, coef_y, y: dMatrix, coef_z, z: dMatrix, o: dMatrix) =
        if x.rc <> y.rc then failwith "x.rc <> y.rc in DeviceTrinaryCoefTransformModule"
        if y.rc <> z.rc then failwith "y.rc <> z.rc in DeviceTrinaryCoefTransformModule"
        if z.rc <> o.rc then failwith "z.rc <> o.rc in DeviceTrinaryCoefTransformModule"
        t.A(coef_x,x.dArray,coef_y,y.dArray,coef_z,z.dArray,o.dArray,x.num_rows*x.num_cols)


// The gradient clipping module.
let gradclipModule = lazy DeviceUnaryCoefTransformModule "(x < -coef_x) ? -coef_x : (x > coef_x ? coef_x : x);"
   
// coef_x = scale
// coef_y = location
// y does not get used.
let randMapModule = lazy DeviceBinaryCoefTransformModule "coef_x*(x-0.5f)+coef_y;"

type dMatrix with
    /// Generates a matrix sampled from a random uniform distribution in <-1.0f,1.0f]
    static member createRandomUniformMatrix weights_num_rows weights_num_cols (scaling_factor : floatType) location =
        let weights_total_size = weights_num_rows*weights_num_cols
        
        let cudaBuffer = new_dev<floatType> weights_total_size
        cudaRandom.GenerateUniform(cudaBuffer)

        // 2.0f*scaling_factor ensures that it is rescaled around zero if the scaling_factor is 1.0f.
        randMapModule.Value.A(2.0f*scaling_factor,cudaBuffer,location,cudaBuffer,cudaBuffer,weights_total_size)

        dMatrix.create(weights_num_rows,weights_num_cols,cudaBuffer)

    /// Fills matrix by sampling from a random uniform distribution in <-1.0f,1.0f]
    member t.fillRandomUniformMatrix (scaling_factor : floatType) location =
        let weights_total_size = t.num_rows*t.num_cols

        cudaRandom.GenerateUniform(t.dArray)
        // 2.0f*scaling_factor ensures that it is rescaled around zero if the scaling_factor is 1.0f.
        randMapModule.Value.A(2.0f*scaling_factor,t,location,t,t)

type DeviceGetSliceModule() = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __global__ void getSliceKernel(const "+FloatTypeCpp+"* matrix, "+FloatTypeCpp+"* out_matrix, const int start_row, const int end_row, const int num_rows, const int start_col, const int end_col, const int num_cols, const unsigned col_major){
                const int stride = blockDim.x * gridDim.x;
                if (col_major){
                    int i = threadIdx.x+blockIdx.x*blockDim.x;
                    const int row_stride = end_row-start_row+1;
                    const int col_stride = end_col-start_col+1;
                    while (1) {
                        const int row_i = i % row_stride;
                        const int col_i = i / row_stride;
                        const int row = start_row+row_i;
                        const int col = start_col+col_i;
                        const int idx = row+col*num_rows;
                        if (row_i < row_stride && col_i < col_stride) {
                            out_matrix[i] = matrix[idx];
                            i += stride;
                        } else return;
                    }
                }
                else{
                    int i = threadIdx.x+blockIdx.x*blockDim.x;
                    const int row_stride = end_row-start_row+1;
                    const int col_stride = end_col-start_col+1;
                    while (1) {
                        const int row_i = i / col_stride;
                        const int col_i = i % col_stride;
                        const int row = start_row+row_i;
                        const int col = start_col+col_i;
                        const int idx = col+row*num_cols;
                        if (row_i < row_stride && col_i < col_stride) {
                            out_matrix[i] = matrix[idx];
                            i += stride;
                        } else return;
                    }
                }
            }
        }

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"getSliceKernel")
    do  
        try k.Compile([|"-arch=compute_30"|])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"getSliceKernel")

    /// For matrices stored in row major order.
    /// Zero based indexing.
    member t.AR(x: dMatrix, start_row, end_row, start_col, end_col) =
        if (start_row < 0 || start_col < 0) then failwith "start_row < 0 || start_col < 0"
        if (end_row >= x.num_rows || start_col >= x.num_cols) then failwith "end_row >= x.num_rows || start_col >= x.num_cols"
        let order = 0u
        let row_stride = end_row-start_row+1
        let col_stride = end_col-start_col+1
        let y = dMatrix.create(row_stride, col_stride)
        let n = row_stride*col_stride
        let gridSize = divup n block_size
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.dArray.DevicePointer,y.dArray.DevicePointer,start_row, end_row, x.num_rows, start_col, end_col, x.num_cols, order) |> ignore
        y

    /// For matrices stored in column major order.
    /// Zero based indexing.
    member t.AC(x: dMatrix, start_row, end_row, start_col, end_col) =
        if (start_row < 0 || start_col < 0) then failwith "start_row < 0 || start_col < 0"
        if (end_row >= x.num_rows || start_col >= x.num_cols) then failwith "end_row >= x.num_rows || start_col >= x.num_cols"
        let order = 1u
        let row_stride = end_row-start_row+1
        let col_stride = end_col-start_col+1
        let y = dMatrix.create(row_stride, col_stride)
        let n = row_stride*col_stride
        let gridSize = divup n block_size
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.dArray.DevicePointer,y.dArray.DevicePointer,start_row, end_row, x.num_rows, start_col, end_col, x.num_cols, order) |> ignore
        y

type DeviceSetSliceModule() = 
    let block_size = 256

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            __global__ void setSliceKernel("+FloatTypeCpp+"* matrix, const "+FloatTypeCpp+"* out_matrix, const int start_row, const int end_row, const int num_rows, const int start_col, const int end_col, const int num_cols, const unsigned col_major){
                const int stride = blockDim.x * gridDim.x;
                if (col_major){
                    int i = threadIdx.x+blockIdx.x*blockDim.x;
                    const int row_stride = end_row-start_row+1;
                    const int col_stride = end_col-start_col+1;
                    while (1) {
                        const int row_i = i % row_stride;
                        const int col_i = i / row_stride;
                        const int row = start_row+row_i;
                        const int col = start_col+col_i;
                        const int idx = row+col*num_rows;
                        if (row_i < row_stride && col_i < col_stride) {
                            matrix[idx] = out_matrix[i];
                            i += stride;
                        } else return;
                    }
                }
                else{
                    int i = threadIdx.x+blockIdx.x*blockDim.x;
                    const int row_stride = end_row-start_row+1;
                    const int col_stride = end_col-start_col+1;
                    while (1) {
                        const int row_i = i / col_stride;
                        const int col_i = i % col_stride;
                        const int row = start_row+row_i;
                        const int col = start_col+col_i;
                        const int idx = col+row*num_cols;
                        if (row_i < row_stride && col_i < col_stride) {
                            matrix[idx] = out_matrix[i];
                            i += stride;
                        } else return;
                    }
                }
            }
        }

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"setSliceKernel")
    do  
        try k.Compile([|"-arch=compute_30"|])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"setSliceKernel")

    /// For matrices stored in row major order.
    /// Zero based indexing.
    member t.AR(x: dMatrix, y: dMatrix, start_row, end_row, start_col, end_col) =
        if (start_row < 0 || start_col < 0) then failwith "start_row < 0 || start_col < 0"
        if (end_row >= x.num_rows || start_col >= x.num_cols) then failwith "end_row >= x.num_rows || start_col >= x.num_cols"
        let order = 0u
        let row_stride = end_row-start_row+1
        let col_stride = end_col-start_col+1
        if y.rc <> (row_stride,col_stride) then failwith "y.rc <> row_stride,col_stride"
        let n = row_stride*col_stride
        let gridSize = divup n block_size
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.dArray.DevicePointer,y.dArray.DevicePointer,start_row, end_row, x.num_rows, start_col, end_col, x.num_cols, order) |> ignore

    /// For matrices stored in column major order.
    /// Zero based indexing.
    member t.AC(x: dMatrix, y: dMatrix, start_row, end_row, start_col, end_col) =
        if (start_row < 0 || start_col < 0) then failwith "start_row < 0 || start_col < 0"
        if (end_row >= x.num_rows || start_col >= x.num_cols) then failwith "end_row >= x.num_rows || start_col >= x.num_cols"
        let order = 1u
        let row_stride = end_row-start_row+1
        let col_stride = end_col-start_col+1
        if y.rc <> (row_stride,col_stride) then failwith "y.rc <> row_stride,col_stride"
        let n = row_stride*col_stride
        let gridSize = divup n block_size
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.dArray.DevicePointer,y.dArray.DevicePointer,start_row, end_row, x.num_rows, start_col, end_col, x.num_cols, order) |> ignore

// The Item and GetSlice operators. Column major
let setsliceModule = lazy DeviceSetSliceModule()
let getsliceModule = lazy DeviceGetSliceModule()

type dMatrix with
    member t.GetSlice(rowStart: int option, rowFinish : int option,
                         colStart: int option, colFinish : int option) =
        let rowStart = defaultArg rowStart 0
        let rowFinish = defaultArg rowFinish (t.num_rows-1)
        let colStart = defaultArg colStart 0
        let colFinish = defaultArg colFinish (t.num_cols-1)
        getsliceModule.Value.AC(t,rowStart,rowFinish,colStart,colFinish)

    member t.GetSlice(row: int, colStart: int option, colFinish: int option) =
            let colStart = defaultArg colStart 0
            let colFinish = defaultArg colFinish t.num_cols-1
            getsliceModule.Value.AC(t,row,row,colStart,colFinish)

    member t.GetSlice(rowStart: int option, rowFinish: int option, col: int) =
            let rowStart = defaultArg rowStart 0
            let rowFinish = defaultArg rowFinish t.num_rows-1
            getsliceModule.Value.AC(t,rowStart,rowFinish,col,col)

    member t.SetSlice(rowStart: int option, rowFinish : int option,
                         colStart: int option, colFinish : int option, y) =
        let rowStart = defaultArg rowStart 0
        let rowFinish = defaultArg rowFinish (t.num_rows-1)
        let colStart = defaultArg colStart 0
        let colFinish = defaultArg colFinish (t.num_cols-1)
        setsliceModule.Value.AC(t,y,rowStart,rowFinish,colStart,colFinish)

    member t.SetSlice(row: int, colStart: int option, colFinish: int option,y) =
            let colStart = defaultArg colStart 0
            let colFinish = defaultArg colFinish t.num_cols-1
            setsliceModule.Value.AC(t,y,row,row,colStart,colFinish)

    member t.SetSlice(rowStart: int option, rowFinish: int option, col: int,y) =
            let rowStart = defaultArg rowStart 0
            let rowFinish = defaultArg rowFinish t.num_rows-1
            setsliceModule.Value.AC(t,y,rowStart,rowFinish,col,col)

/// o <- max_col(x)
/// Sets all except one of the max of a column to zero.
type DeviceMaxColumnActivationModule() = 
    let block_size = 128

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            #define INIT __int_as_float(0xff800000) // The constant init for the reduce operations. This is float negative infinity.
            // The max reduce version.
            __device__ inline "+FloatTypeCpp+" warpReduce("+FloatTypeCpp+" value){
                #pragma unroll
	            for (int i=1; i<32; i*=2) {
                    "+FloatTypeCpp+" tmp = __shfl_xor(value, i);
                    value = (tmp > value) ? tmp : value;
                    }
	            return value;
            }
              
            __device__ inline "+FloatTypeCpp+" blockReduce("+FloatTypeCpp+" value){
	            __shared__ "+FloatTypeCpp+" temp[32];
                if (threadIdx.x < 32) temp[threadIdx.x] = INIT; "+FloatTypeCpp+" out_partial = warpReduce(value);
                __syncthreads();
	            if (threadIdx.x % 32 == 0) temp[threadIdx.x / 32] = out_partial;
                __syncthreads();
	            if (threadIdx.x < 32) out_partial = warpReduce(temp[threadIdx.x]);
                return out_partial;
            }

            // Device code
            __global__ void Kernel(const "+FloatTypeCpp+"* A, "+FloatTypeCpp+"* O, const int num_rows, const int num_cols)
            {
                int row = threadIdx.x;
                //const int col = blockIdx.x;
                int col_idx = blockIdx.x*num_rows; "+FloatTypeCpp+" max = INIT; // This is the negative infinity for floats.
                int index = -1;
                while (row < num_rows)
                {
                   if (A[row+col_idx] > max) {
                        max = A[row+col_idx];
                        index = row;
                        }
                    row += blockDim.x;
                }
                
                __shared__ "+FloatTypeCpp+" max_index;
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

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"Kernel")
    do  
        try k.Compile([|"-arch=compute_30"|])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"Kernel")

    member t.A(x: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>, m:int , n: int) =
        kernel.GridDimensions <- dim3(n)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream,x.DevicePointer,o.DevicePointer,m,n) |> ignore

    member t.A(x: dMatrix, o: dMatrix) =
        if x.rc <> o.rc then failwith "x.rc <> o.rc"
        t.A(x.dArray,o.dArray,x.num_rows,x.num_cols)

    member t.A(x: dMatrix) =
        let o = dMatrix.create(x.num_rows,x.num_cols)
        t.A(x.dArray,o.dArray,x.num_rows,x.num_cols)
        o

/// o <- max_k(tranpose_if(x))
/// Sets all except the k number of max of a column to zero.
/// Unlike for the other modules, to ensure it works swiftly, the column size and the number of iterations is fixed so the compiler can unroll the loops.
type DeviceMaxSelectColumnActivationModule(column_size: int) = 
    let block_size_x = 32 // This should not be changed for this module. Small block sizes such as these are much more efficient on Maxwell.
    let block_size_y = 16 // This should be a mutliple of 2. On the GTX 970, 16 seems to work best, although 4,8,16,32 are quite close.

    let kernel_code = "
        //Kernel code:
        extern \"C\" {
            #define INIT_MIN __int_as_float(0xff800000) // The constant init for the reduce operations. This is the float negative infinity.
            #define INIT_MAX __int_as_float(0x7f800000) // The constant init for the reduce operations. This is the float positive infinity.
            #define NUM_VARS "+string (divup column_size 32)+" // This is to ensure that the number of variables is encoded as a constant.
            #define NUM_COLS_32 "+string ((divup column_size 32)*32)+" // The column size has to be static for the shared memory array. This also to ensures it is a multiple of 32.
            #define BLOCK_SIZE_Y "+string block_size_y+" // I am not sure whether gridDim.x is a compile time constant. It was not in Alea.
            #define ROW_ITERS "+string (divup 32 block_size_y)+" // The number of iterations that should be done across the rows in shared memory.
            typedef "+FloatTypeCpp+" floatType;
            // The max reduce version.
            __device__ inline floatType warpReduce(floatType value){
                #pragma unroll
	            for (int i=1; i<32; i*=2) {
                    floatType tmp = __shfl_xor(value, i);
                    value = (tmp > value) ? tmp : value;
                    }
	            return value;
            }
              
            // Device code
            __global__ void Kernel(const floatType* A, floatType* O, const int num_rows, const int num_cols, const int k, const int transpose)
            {
                if (transpose) {
                    __shared__ floatType ar[32][NUM_COLS_32+1];
                    // The reason why the second dimension is a mutliple of 32 is so that in the warp reduction phase, there are no inactive threads.
                    // Inactive threads during the warp shuffle give undefined values. One has to go an extra mile to ensure that they are defined.
                    {
                    const int row = threadIdx.x;
                    const int row_idx = row+blockIdx.x*32;
                    #pragma unroll // Unroll the loops for performance.
                    for (int i = 0; i < NUM_VARS*ROW_ITERS; i++) { // Stores everything into shared memory first by reading from the global in a contiguous manner.
                        const int col = threadIdx.y + i*BLOCK_SIZE_Y;
                        ar[row][col] = (row_idx < num_rows && col < num_cols) ? A[row_idx+col*num_rows] : INIT_MIN;
                        }
                    }
                    __syncthreads();
                
                    floatType vars[NUM_VARS]; // The local array size needs to be made constant so the variables there get stored into registers instead of being spilled into global memory.
                    #pragma unroll // Unroll the loop for performance. All the variables in the loop conditional are static.
                    for (int row_iter=0; row_iter < ROW_ITERS; row_iter++) { 
                    
                        // This loop does max selection on the rows in shared memory.
                        // Unlike for the global memory, not only is shared memory much faster, but it does not need to be read 
                        // contiguosly to hit peak performance.

                        // From shared memory, I put it into the local register memory and operate on that for even further speed gains.
                        // This transposed kernel is adapted from the one in the other branch by adding the shared memory steps.

                        floatType upper_bound = INIT_MAX; // This is the positive infinity for floats.
                        floatType lower_bound = INIT_MIN; // This is the negative infinity for floats.

                        #pragma unroll // Loop unrolling for improved performance. For this to work the number of unrolls has to be defined as a constant.
                        for (int i=0; i < NUM_VARS;i++) { 
                            const int col = threadIdx.x + i*32;
                            const int row_idx = threadIdx.y + row_iter*BLOCK_SIZE_Y;
                            if (row_idx < 32) vars[i] = ar[row_idx][col];
                        }
                        for (int iters=1; iters <= k; iters++){
                            #pragma unroll
                            for (int i=0; i < NUM_VARS;i++) { 
                                if (vars[i] < upper_bound && lower_bound < vars[i]) lower_bound = vars[i];
                            }
                            upper_bound = warpReduce(lower_bound); // Lowers the upper bound.
                            lower_bound = INIT_MIN;
                        }
                        #pragma unroll
                        for (int i=0; i < NUM_VARS;i++) { 
                            const int col = threadIdx.x + i*32;
                            const int row_idx = threadIdx.y + row_iter*BLOCK_SIZE_Y;
                            if (row_idx < 32) ar[row_idx][col] = (vars[i] < upper_bound) ? 0.0f : vars[i];
                        }
                    }
                    __syncthreads();

                    {
                    const int row = threadIdx.x;
                    const int row_idx = row+blockIdx.x*32;
                    #pragma unroll // Unroll the loops for performance.
                    for (int i = 0; i < NUM_VARS*ROW_ITERS; i++) { // Stores the results from shared into global memory.
                        const int col = threadIdx.y + i*BLOCK_SIZE_Y;
                        if (row_idx < num_rows && col < num_cols) O[row_idx+col*num_rows] = ar[row][col];
                        }
                    }
                }
                else { // Does not need a to do a tranpose so it reads directly off global memory.
                    //int row = threadIdx.x;
                    //const int col = blockIdx.x;
                    const int col_idx = blockIdx.x*num_rows; 
                    floatType upper_bound = INIT_MAX; // This is the positive infinity for floats.
                    floatType lower_bound = INIT_MIN; // This is the negative infinity for floats.
                
                    floatType vars[NUM_VARS]; // The local array size needs to be made constant so the variables there get stored into registers instead of being spilled into global memory.

                    #pragma unroll // Loop unrolling for improved performance. For this to work the number of unrolls has to be defined as a constant.
                    for (int i=0; i < NUM_VARS;i++) { 
                        const int row = threadIdx.x + i*32;
                        const int idx = row+col_idx;
                        vars[i] = (row < num_rows) ? A[idx] : INIT_MIN;
                    }
                    for (int iters=1; iters <= k; iters++){
                        #pragma unroll
                        for (int i=0; i < NUM_VARS;i++) { 
                            const int row = threadIdx.x + i*32;
                            if (vars[i] < upper_bound && lower_bound < vars[i]) lower_bound = vars[i];
                        }
                        upper_bound = warpReduce(lower_bound); // Lowers the upper bound.
                        lower_bound = INIT_MIN;
                    }
                    #pragma unroll
                    for (int i=0; i < NUM_VARS;i++) { 
                        const int row = threadIdx.x + i*32;
                        const int idx = row+col_idx;
                        if (row < num_rows){
                            O[idx] = (vars[i] < upper_bound) ? 0.0f : vars[i];
                        }
                    }
                }
            }
        }

        "
    let k = new ManagedCuda.NVRTC.CudaRuntimeCompiler(kernel_code,"Kernel")
    do  
        try k.Compile([|"-arch=compute_30"|])
        with 
        | :? NVRTCException as x -> 
            printfn "%s" (k.GetLogAsString())
            reraise()

    let kernel = ctx.LoadKernelPTX(k.GetPTX(),"Kernel")

    member t.AT(x: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>, m:int, n: int, k: int) =
        kernel.GridDimensions <- dim3(divup m 32)
        kernel.BlockDimensions <- dim3(block_size_x,block_size_y)
        kernel.RunAsync(str.Stream,x.DevicePointer,o.DevicePointer,m,n,k,1) |> ignore

    /// Does a transpose in shared memory first.
    member t.AT(x: dMatrix, k, o: dMatrix) =
        if x.rc <> o.rc then failwith "x.rc <> o.rc"
        if x.num_cols <> column_size then failwith "Wrong num_cols."
        t.AT(x.dArray,o.dArray,x.num_rows,x.num_cols,k)

    /// Does a transpose in shared memory first.
    member t.AT(x: dMatrix, k) =
        let o = dMatrix.create(x.num_rows,x.num_cols)
        if x.num_cols <> column_size then failwith "Wrong num_cols."
        t.AT(x.dArray,o.dArray,x.num_rows,x.num_cols,k)
        o

    member t.A(x: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>, m:int, n: int, k: int) =
        kernel.GridDimensions <- dim3(n)
        kernel.BlockDimensions <- dim3(block_size_x)
        kernel.RunAsync(str.Stream,x.DevicePointer,o.DevicePointer,m,n,k,0) |> ignore

    member t.A(x: dMatrix, k, o: dMatrix) =
        if x.rc <> o.rc then failwith "x.rc <> o.rc"
        if divup x.num_rows 32 <> divup column_size 32 then failwith "Wrong num_rows."
        t.A(x.dArray,o.dArray,x.num_rows,x.num_cols,k)

    member t.A(x: dMatrix, k) =
        let o = dMatrix.create(x.num_rows,x.num_cols)
        if divup x.num_rows 32 <> divup column_size 32 then failwith "Wrong num_rows."
        t.A(x.dArray,o.dArray,x.num_rows,x.num_cols,k)
        o

type Df_rec = {
    P : floatType ref
    A : floatType ref
    is_constant : bool
    } with

    static member create P =
        {P=P;A=ref 0.0f;is_constant=false}
    static member createConstant P =
        {P=P;A=ref 0.0f;is_constant=true}

type DM_rec = {
    P : dMatrix
    A : dMatrix
    is_constant : bool
    } with

    static member create (P: dMatrix) =
        {P=P;A=P.zeroLike();is_constant=false}
        
    static member createConstant (P: dMatrix) =
        {P=P;A=dMatrix.createEmpty;is_constant=true}

    static member createEmpty =
        {P=dMatrix.createEmpty;A=dMatrix.createEmpty;is_constant=false}
        
    static member createEmptyConstant =
        {P=dMatrix.createEmpty;A=dMatrix.createEmpty;is_constant=true}

    /// Resizes the primal and the adjoint if they are below nr*nc in size.
    member t.Resize nr nc =
        let p = t.P
        let a = t.A

        // This is an optimization to prevent an clogup of dMatrix objects here.
        // GC can't free up memory if the dMatrix instances are pointing to the same dArray.

        // If the class is larger, replace the reference else the function will mutably just adjust
        // the num_rows and num_col fields.
        p.ReplaceIf nr nc
        a.ReplaceIf nr nc

    member t.Dispose() = 
        (t.P :> IDisposable).Dispose()
        (t.A :> IDisposable).Dispose()

let Noop() = ()
type Df = 
    {
    r: Df_rec
    ff : (unit -> unit)
    fb : (unit -> unit)
    }
    static member create(r,ff,fb) = {r=r;ff=ff;fb=fb}
    static member createEmpty = {r=Df_rec.create(ref 0.0f);ff=Noop;fb=Noop}
and DM =
    {
    r: DM_rec
    ff : (unit -> unit)
    fb : (unit -> unit)
    }
    static member create(r,ff,fb) = {r=r;ff=ff;fb=fb}

    static member makeNode(hidden_size, input_size) =
        let p = dMatrix.create(hidden_size,input_size)
        {r=DM_rec.create p;ff=Noop;fb=Noop}
    static member makeNode(hidden_size, input_size, input: floatType[]) =
        let p = dMatrix.create(hidden_size,input_size, input)
        {r=DM_rec.create p;ff=Noop;fb=Noop}
    static member makeNode p =
        {r=DM_rec.create p;ff=Noop;fb=Noop}

    static member makeConstantNode(hidden_size, input_size, input: floatType[]) =
        let p = dMatrix.create(hidden_size,input_size, input)
        {r=DM_rec.createConstant p;ff=Noop;fb=Noop}
    static member makeConstantNode p =
        {r=DM_rec.createConstant p;ff=Noop;fb=Noop}

    static member makeUniformRandomNode(hidden_size,input_size) =
        let scale = (1.0f / sqrt(hidden_size+input_size |> floatType))
        let p = dMatrix.createRandomUniformMatrix hidden_size input_size scale 0.0f
        {r=DM_rec.create p;ff=Noop;fb=Noop}
and BlockReverse() = class end // The type that blocks reverse propagation. Used for layerwise pretraining.

open System.Collections.Generic
type tapeType() =
    let d = Dictionary<int,List<obj>*(List<DM_rec>*int ref)>()
    let mutable select = 0
    /// Instantiates a new List if none is present at the selection and adds to it, else it just adds to the selected one.
    /// The default select is 0.
    member t.Add a =
        if d.ContainsKey(select) = false then
            let tape = List()
            let memory_dm = List(), ref 0
            d.Add(select, (tape, memory_dm))
            tape.Add(a)
        else
            let tape,_ = d.[select]
            tape.Add(a)

    /// Sets the select to input.
    member t.Select i = select <- i

    /// Runs all the forward functions in the currently selected tape.
    member t.forwardpropTape select = 
        let tape,_ = d.[select]
        for i=0 to tape.Count-1 do 
            match tape.[i] with
            | :? Df as x -> x.ff()
            | :? DM as x -> x.ff()
            | :? BlockReverse as x -> ()
            | _ -> failwith "Type not supported"
    /// Runs all the backward functions in the currently selected tape, starting from the top.
    member t.reversepropTape select = 
        let tape,_ = d.[select]
        let mutable i = tape.Count-1
        while i >= 0 do 
            match tape.[i] with
            | :? Df as x -> x.fb(); i <- i-1
            | :? DM as x -> x.fb(); i <- i-1
            | :? BlockReverse as x -> i <- -1
            | _ -> failwith "Type not supported"
    /// Resets the adjoints of the selected tape.
    member t.resetTapeAdjoint select = 
        let tape,_ = d.[select]
        for i=tape.Count-1 downto 0 do 
            match tape.[i] with
            | :? Df as x -> x.r.A := 0.0f
            | :? DM as x -> x.r.A.setZero()
            | :? BlockReverse as x -> ()
            | _ -> failwith "Type not supported"
    /// Resets the adjoints of the selected tape.
    member t.resetTapePrimal select = 
        if d.ContainsKey(select) then
            let tape,_ = d.[select]
            for i=tape.Count-1 downto 0 do 
                match tape.[i] with
                | :? Df as x -> x.r.P := 0.0f
                | :? DM as x -> x.r.P.setZero()
                | :? BlockReverse as x -> ()
                | _ -> failwith "Type not supported"
    /// Disposes all the elements of the select tape and then clears it including the memory buffer.
    member t.Dispose select =
        let tape,mp = d.[select]
        let memory,dm_pointer = mp
        for x in tape do 
            match x with
            | :? Df as x -> ()
            | :? DM as x -> x.r.Dispose()
            | :? BlockReverse as x -> ()
            | _ -> failwith "Type not supported"
        for x in memory do x.Dispose()
        tape.Clear()
        memory.Clear()
        dm_pointer := 0
    /// Clears the select tape without disposing it or the memory buffer.
    /// Also sets the pointer to zero for the select.
    member t.Clear select =
        if d.ContainsKey(select) then
            let tape,mp = d.[select]
            let memory,dm_pointer = mp
            tape.Clear()
            dm_pointer := 0
    /// Disposes all the elements of all the tapes and then clears them including the memory buffer.
    member t.DisposeAll() =
        for tape,mp in d.Values do
            let memory,dm_pointer = mp
            for x in tape do 
                match x with
                | :? Df as x -> ()
                | :? DM as x -> x.r.Dispose()
                | :? BlockReverse as x -> ()
                | _ -> failwith "Type not supported"
            for x in memory do x.Dispose()
            tape.Clear()
            memory.Clear()
            dm_pointer := 0
    /// Returns an empty DM_rec if none exists at the pointer and adds it to the memory buffer, else it returns the DM_rec at the pointer to be reused.
    /// Increments the pointer afterwards.
    member t.GetDMIf =
        if d.ContainsKey(select) then
            let _, mp = d.[select]
            let memory,dm_pointer = mp
            if memory.Count > !dm_pointer then
                dm_pointer := !dm_pointer+1
                memory.[!dm_pointer-1]
            else
                dm_pointer := !dm_pointer+1
                let t = DM_rec.createEmpty
                memory.Add(t)
                t
        else
            let tape = List()
            let memory = List()
            let dm_pointer = ref 1
            d.Add(select, (tape, (memory,dm_pointer)))
            let t = DM_rec.createEmpty
            memory.Add(t)
            t

/// The global tape instance.
let tape = tapeType()

let hadamaradMultiplicationModule = lazy new DeviceBinaryTransformModule "x*y;"
let hadamaradMultiplicationErrorModule = lazy new DeviceTrinaryTransformModule "x*y+z;"
/// Hadamarad (elementwise) multiplication function.
let hadmult (a: DM) (b: DM) =
    let va = a.r.P
    let vb = b.r.P
    let el = a.r.A
    let er = b.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr, nc = va.rc
        node.Resize nr nc
        hadamaradMultiplicationModule.Value.A(va, vb, c)
    let fb () = 
        if a.r.is_constant = false then hadamaradMultiplicationErrorModule.Value.A(vb,error,el,el)
        if b.r.is_constant = false then hadamaradMultiplicationErrorModule.Value.A(va,error,er,er)
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t


/// This is an optimization of the linear layer because the best optimization is to remove operations entirely.
/// Doing it standardly involves too many unnecessary allocations.
/// Can be used for both matrix-matrix standards and Hadamarad multiplications, but it is not intended that they be used at the same time.
/// Has been split into two function below.
let linear_layer (mm: (DM*DM) []) (hads: (DM*DM) []) (bias: DM option) =
    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff() =
        if mm.Length > 0 then 
            let l,r = mm.[0]
            let nr = l.r.P.num_rows
            let nc = r.r.P.num_cols
            node.Resize nr nc
        else if hads.Length > 0 then
            let l,r = hads.[0]
            let nr,nc = l.r.P.rc
            node.Resize nr nc
        else failwith "Invalid input into linear_layer."

        match bias with
        | Some bias -> broadcastAdd2 0.0f c 1.0f bias.r.P
        | None -> c.setZero()
                
        for l,r in mm do gemm2 nT nT 1.0f l.r.P r.r.P 1.0f c
        for l,r in hads do hadamaradMultiplicationErrorModule.Value.A(l.r.P, r.r.P, c, c) //c = l.*r+c

    let fb() =
        for l,r in mm do
            if l.r.is_constant = false then gemm2 nT T 1.0f error r.r.P 1.0f l.r.A
            if r.r.is_constant = false then gemm2 T nT 1.0f l.r.P error 1.0f r.r.A
        for l,r in hads do 
            if l.r.is_constant = false then hadamaradMultiplicationErrorModule.Value.A(error, r.r.P, l.r.A, l.r.A)
            if r.r.is_constant = false then hadamaradMultiplicationErrorModule.Value.A(l.r.P, error, r.r.A, r.r.A)
        
        match bias with
        | Some bias -> rowSum2 1.0f error 1.0f bias.r.A
        | None -> ()
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

let linear_layer_matmult (mm: (DM*DM) []) (bias: DM option) =
    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff() =
        let l,r = mm.[0]
        let nr = (l.r.P).num_rows
        let nc = (r.r.P).num_cols
        node.Resize nr nc

        gemm2 nT nT 1.0f l.r.P r.r.P 0.0f c
        for l,r in mm.[1..] do gemm2 nT nT 1.0f l.r.P r.r.P 1.0f c

        match bias with
        | Some bias -> broadcastAdd2 1.0f c 1.0f bias.r.P
        | None -> ()

    let fb() =
        for l,r in mm do
            if l.r.is_constant = false then gemm2 nT T 1.0f error r.r.P 1.0f l.r.A
            if r.r.is_constant = false then gemm2 T nT 1.0f l.r.P error 1.0f r.r.A
        match bias with
        | Some bias -> rowSum2 1.0f error 1.0f bias.r.A
        | None -> ()
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

let linear_layer_hads (hads: (DM*DM) []) =
    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff() =
        let l,r = hads.[0]
        let nr,nc = (l.r.P).rc
        node.Resize nr nc
        hadamaradMultiplicationModule.Value.A(l.r.P,r.r.P,c)
        for l,r in hads.[1..] do hadamaradMultiplicationErrorModule.Value.A(l.r.P, r.r.P, c, c) //c = l.*r+c
    let fb() =
        for l,r in hads do 
            if l.r.is_constant = false then hadamaradMultiplicationErrorModule.Value.A(error, r.r.P, l.r.A, l.r.A)
            if r.r.is_constant = false then hadamaradMultiplicationErrorModule.Value.A(l.r.P, error, r.r.A, r.r.A)
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t
    
/// Matrix-matrix multiply.
let matmult (a: DM) (b:DM) =
    let va = a.r.P
    let vb = b.r.P
    let el = a.r.A
    let er = b.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A
        
    let ff () = 
        let nr = (va).num_rows
        let nc = (vb).num_cols
        node.Resize nr nc
        gemm2 nT nT 1.0f va vb 0.0f c
    let fb () = 
        if a.r.is_constant = false then gemm2 nT T 1.0f error vb 1.0f el// The derivative with respect to the left. So the above argument gets inserted from the right left. Usually error * input.
        if b.r.is_constant = false then gemm2 T nT 1.0f va error 1.0f er// The derivative with respect to the right. So the above argument gets inserted from the right side. Usually weights * error.
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

/// Matrix-matrix multiply with the first argument transposed.
let matmultTN (a: DM) (b:DM) =
    let va = a.r.P
    let vb = b.r.P
    let el = a.r.A
    let er = b.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A
        
    let ff () = 
        let nr = (va).num_cols
        let nc = (vb).num_cols
        node.Resize nr nc
        gemm2 T nT 1.0f va vb 0.0f c
    let fb () = 
        if a.r.is_constant = false then gemm2 nT T 1.0f vb error 1.0f el// The derivative with respect to the left. So the above argument gets inserted from the right left. Usually error * input.
        if b.r.is_constant = false then gemm2 nT nT 1.0f va error 1.0f er// The derivative with respect to the right. So the above argument gets inserted from the right side. Usually weights * error.
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t
    

/// Addition with broadcasting.
let addb (a: DM) (b: DM) = // b is for bias and a is for preactivations.
    let va = a.r.P
    let vb = b.r.P
    let el = a.r.A
    let er = b.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        geam2 nT nT 1.0f va 0.0f c c
        broadcastAdd2 1.0f c 1.0f vb
    let fb () = 
        geam2 nT nT 1.0f el 1.0f error el
        rowSum2 1.0f error 1.0f er
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

//coef_x=scalar
let scalarAddModule = lazy new DeviceUnaryCoefTransformModule "coef_x + x;"
let scalar_add (a:DM) b =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        scalarAddModule.Value.A(b,va,c)
    let fb () = geam2 nT nT 1.0f error 1.0f el el
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t
    
let sigmoidModule = lazy new DeviceUnaryTransformModule "1.0f/(1.0f+expf(-x));"
//y = error
//z = previous adjoint value
let sigmoidErrorModule = lazy new DeviceTrinaryTransformModule "x*(1.0f-x)*y + z;"
let sigmoid (a:DM) =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        sigmoidModule.Value.A(va,c)
    let fb () = sigmoidErrorModule.Value.A(c,error,el,el)
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t
    
let steepSigmoidModule = lazy new DeviceUnaryCoefTransformModule "1.0f/(1.0f+expf(-coef_x*x));"
//y = error
//z = previous adjoint value
let steepSigmoidErrorModule = lazy new DeviceTrinaryCoefTransformModule "coef_x*x*(1.0f-x)*y + z;"
let steep_sigmoid coef (a:DM) =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        steepSigmoidModule.Value.A(coef,va,c)
    let fb () = steepSigmoidErrorModule.Value.A(coef,c,coef,error,coef,el,el)
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

let tanhModule = lazy new DeviceUnaryTransformModule "tanhf(x);"
//y = error
//z = previous adjoint value
let tanhErrorModule = lazy new DeviceTrinaryTransformModule "(1.0f-x*x)*y + z;"
let tanh_ (a:DM) =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        tanhModule.Value.A(va,c)
    let fb () = tanhErrorModule.Value.A(c,error,el,el)
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

let clipModule = lazy new DeviceTrinaryCoefTransformModule "((x < coef_x) ? coef_x : (x > coef_y ? coef_y : x))+coef_z;"
let clipErrorModule = lazy new DeviceTrinaryCoefTransformModule "y*((x < coef_x) ? 0.0f : (x > coef_y ? 0.0f : 1.0f))+z;"
/// o <- clip(min,max,a)+scalar
/// The clip function. Can be used as Relu by setting max to positive infinity. 
/// Can be used to make linear clipped sigmoid by setting min,max,scalar to -0.5f,0.5f,0.5f.
let clip min max a scalar =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        clipModule.Value.A(min,va,max,va,scalar,va,c)
    let fb () = 
        clipErrorModule.Value.A(min,va,max,error,max,el,el)
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

let inline clipped_sigmoid x = clip 0.0001f 0.9999f (sigmoid x) 0.0f
let inline clipped_steep_sigmoid coef x = clip 0.0001f 0.9999f (steep_sigmoid coef x) 0.0f
let inline relu x = clip 0.0f Single.PositiveInfinity x 0.0f

// The linear versions of the sigmoid and tanh.
let inline clipped_linear_sigmoid x = clip -0.4999f 0.4999f x 0.5f // Clipped linear sigmoid in the [0.001,0.999] range.
let inline linear_sigmoid x = clip -0.5f 0.5f x 0.5f // Linear sigmoid in the [0.0,1.0] range.
let inline linear_tanh x = clip -1.0f 1.0f x 0.0f // Linear tanh in the [-1.0,1.0] range.


let DeviceMaxSelectDict = lazy Dictionary<int,DeviceMaxSelectColumnActivationModule>()
/// o <- max_k(x)
/// Sets all except the k number of max of a column to zero.
/// Unlike for the other modules, to ensure it works swiftly, the column size and the number of iterations is fixed so the compiler can unroll the loops.
/// This name is for a function wrapper for the Dict that holds the DeviceMaxSelectColumnActivation modules.
let DeviceMaxSelectColumnActivationModule column_size =
    let d = DeviceMaxSelectDict.Value
    if d.ContainsKey(divup column_size 32) then
        d.[divup column_size 32]
    else
        let t = DeviceMaxSelectColumnActivationModule column_size
        d.Add(divup column_size 32,t)
        t

/// The winner take all activation. Zeroes out the non top-k values along the row.
let sparseActivationErrorModule = lazy new DeviceTrinaryTransformModule "y*((x == 0.0f) ? 0.0f : 1.0f)+z;"
let WTA k (a:DM) =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        DeviceMaxSelectColumnActivationModule(nc).AT(va,k,c)
    let fb () = sparseActivationErrorModule.Value.A(c,error,el,el)
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t


let add alpha (a: DM) beta (b: DM) =
    let va = a.r.P
    let vb = b.r.P
    let el = a.r.A
    let er = b.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        geam2 nT nT alpha va beta vb c
    let fb () = 
        let nr,nc = (va).rc
        if (a.r.is_constant) = false then geam2 nT nT alpha error 1.0f el el
        if (b.r.is_constant) = false then geam2 nT nT 1.0f er beta error er
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

(*
/// The old inneficient linear layer that just does everything as a sequence of matrix multiplication operation. For debugging purposes.
let linear_layer_ (mm: (RDM*RDM) []) (hh: (RDM*RDM) []) (bias: RDM option) =
    let mats = [|for l,r in mm do yield matmult l r|]
    let hads = [|for l,r in hh do yield hadmult l r|]
    let t = [|mats;hads|] |> Array.concat
    let sum = Array.fold (fun state x -> add 1.0f state 1.0f x) t.[0] t.[1..]
    match bias with
    | Some bias -> addb sum bias
    | None -> sum
*)

let squareModule = lazy new DeviceUnaryTransformModule "x*x;"
//y = error
//z = previous adjoint value
let squareErrorModule = lazy new DeviceTrinaryTransformModule "2.0f*x*y + z;"
let square (a:DM) =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        squareModule.Value.A(va,c)
    let fb () = squareErrorModule.Value.A(va,error,el,el)
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

let sumModule = lazy new DeviceUnaryMapSumModule "x;"
let sumErrorModule = lazy new DeviceUnaryCoefTransformModule "coef_x + x;" 
let sum (a:DM) =
    let va = a.r.P
    let el = a.r.A

    let node = Df_rec.create (ref 0.0f)
    let error = node.A
    
    let ff () = node.P := sumModule.Value.A(va)
    let fb () = sumErrorModule.Value.A(!error,el,el)
    let t = Df.create(node,ff,fb)
    tape.Add(t)
    t

let scale (alpha: floatType) (a:Df) =
    let node = Df_rec.create (ref 0.0f)

    let ff () = node.P := alpha * !a.r.P
    let fb () = a.r.A := alpha * !node.A + !a.r.A
    let t = Df.create(node,ff,fb)
    tape.Add(t)
    t

let sum_scalars (a:Df[]) =
    let node = Df_rec.create (ref 0.0f)

    let ff () = 
        let c = ref 0.0f
        for l in a do c := !c + !l.r.P
        node.P := !c
    let fb () = 
        for l in a do l.r.A := !node.A + !l.r.A
    let t = Df.create(node,ff,fb)
    tape.Add(t)
    t

let logModule = lazy new DeviceUnaryTransformModule "logf(x);"
//y=error
//z=previous adjoint
let logErrorModule = lazy new DeviceTrinaryTransformModule "y / x + z;"
let log_ (a:DM) =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        logModule.Value.A(va,c)
    let fb () = logErrorModule.Value.A(va,error, el, el)
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

//coef_x = scalar
//coef_y = coef
let scalarMatrixAddModule = lazy new DeviceBinaryCoefTransformModule "coef_x + coef_y*x;"
/// o <- scalar + coef*a
let scalar_matrix_add scalar coef (a:DM) =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        scalarMatrixAddModule.Value.A(scalar,va,coef,va,c)
    let fb () = if a.r.is_constant = false then geam2 nT nT coef error 1.0f el el
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

let neg (a:DM) =
    let va = a.r.P
    let el = a.r.A

    let node = tape.GetDMIf
    let c = node.P
    let error = node.A

    let ff () = 
        let nr,nc = (va).rc
        node.Resize nr nc
        geam2 nT nT -1.0f va 0.0f va c
    let fb () = if a.r.is_constant = false then geam2 nT nT -1.0f error 1.0f el el
    let t = DM.create(node,ff,fb)
    tape.Add(t)
    t

let cross_entropy_cost target activations =
    let cross_ent = linear_layer_hads [|target,log_ activations;scalar_matrix_add 1.0f -1.0f target, log_ (scalar_matrix_add 1.0f -1.0f activations)|]
    let s = sum cross_ent
    scale (-1.0f/floatType (target.r.P).num_cols) s

let squared_error_cost target activations =
    let r1 = add 1.0f target -1.0f activations
    let r2 = square r1
    let r3 = sum r2
    scale (0.5f/floatType (target.r.P).num_cols) r3

let maxColumnModule = lazy new DeviceMaxColumnActivationModule()
let accuracyModule = lazy new DeviceBinaryMapSumModule "(x*y == 0.0f) ? 0.0f : 1.0f;"
let get_accuracy targets activations =
    let o = tape.GetDMIf
    o.P.ReplaceIf activations.num_rows activations.num_cols
    maxColumnModule.Value.A(activations,o.P)
    accuracyModule.Value.A(targets,o.P)

type IFeedforwardLayer =
    abstract runLayer: DM -> DM
    abstract ToArray: DM[]

// A feedforward layer of neurons
type FeedforwardLayer =
    {
    W:DM  // Input weight matrix
    b:DM  // Bias vector
    a:DM->DM
    } with     // Activation function
     
    static member fromArray (a : DM[]) act =
        {
         W = a.[0]
         b = a.[1]
         a = act
        }

    static member createRandomLayer hidden_size input_size act =
        {
         W = DM.makeUniformRandomNode(hidden_size, input_size)
         b = DM.makeUniformRandomNode(hidden_size, 1)
         a = act
        } 

    member l.runLayer (x:DM) =
        linear_layer_matmult [|l.W,x|] (Some l.b) |> l.a

    member l.ToArray = 
        [|l.W;l.b|]

    interface IFeedforwardLayer with
        member l.runLayer (x:DM) = l.runLayer x
        member l.ToArray = l.ToArray
            

// An inverse feedforward layer of neurons made from a regular one. Used in autoencoders
type InverseFeedforwardLayer =
    {
    W:DM  // Input weight matrix
    b:DM  // Bias vector
    a:DM->DM
    } with     // Activation function
     
    member l.ToArray = 
        [|l.W;l.b|]

    static member fromArray (a : DM[]) act =
        {
         W = a.[0]
         b = a.[1]
         a = act
        }

    static member createRandomLayer (l: FeedforwardLayer) act =
        {
         W = l.W
         b = DM.makeUniformRandomNode(l.W.r.P.num_cols, 1)
         a = act
        } 

    member l.runLayer (x:DM) =
        addb (matmultTN l.W x) l.b |> l.a

    interface IFeedforwardLayer with
        member l.runLayer (x:DM) = l.runLayer x
        member l.ToArray = l.ToArray


// A recurrent layer of neurons
type Layer =
    {
    W:DM  // Input weight matrix
    U:DM  // Recurrent weight matrix
    b:DM  // Bias vector
    a:DM->DM
    } with     // Activation function
     
    member l.ToArray = 
        [|l.W;l.U;l.b|]

    static member fromArray (a : DM[]) act =
        {
         W = a.[0]
         U = a.[1]
         b = a.[2]
         a = act
        }

    static member createRandomLayer hidden_size input_size act =
        {
         W = DM.makeUniformRandomNode(hidden_size, input_size)
         U = DM.makeUniformRandomNode(hidden_size, hidden_size)
         b = DM.makeUniformRandomNode(hidden_size, 1)
         a = act
        } 

    // For the section with no previous hidden state.
    member l.runLayerNoH (x:DM) =
        linear_layer [|l.W,x|] [||] (Some l.b) |> l.a
    
    // For the section with no input
    member l.runLayerNoI (y:DM) =
        linear_layer [|l.U,y|] [||] (Some l.b) |> l.a

    // For the section with previous hidden state
    member l.runLayer (x:DM) (y:DM) =
        linear_layer [|l.W,x;l.U,y|] [||] (Some l.b) |> l.a


type GRULayer =
    {W_u:DM  // Input weight matrix for the update gate
     U_u:DM  // Recurrent weight matrix for the update gate
     b_u:DM  // Bias vector for the update gate

     W_r:DM  // Input weight matrix for the reset gate
     U_r:DM  // Recurrent weight matrix for the reset gate
     b_r:DM  // Bias vector for the reset gate

     W_n:DM  // Input weight matrix for the potential new state
     U_n:DM  // Recurrent weight matrix for the potential new state
     b_n:DM  // Bias vector for the potential new state

     a : DM -> DM
     } with
    
    /// Returns all the weights in an array.
    member l.ToArray =
        [|l.W_u;l.U_u;l.b_u;l.W_r;l.U_r;l.b_r;l.W_n;l.U_n;l.b_n|]

    static member createRandomGRULayer hidden_size input_size act =
        {
        W_u = DM.makeUniformRandomNode(hidden_size, input_size)
        U_u = DM.makeUniformRandomNode(hidden_size, hidden_size)
        b_u = DM.makeUniformRandomNode(hidden_size, 1)

        W_r = DM.makeUniformRandomNode(hidden_size, input_size)
        U_r = DM.makeUniformRandomNode(hidden_size, hidden_size)
        b_r = DM.makeUniformRandomNode(hidden_size, 1)

        W_n = DM.makeUniformRandomNode(hidden_size, input_size)
        U_n = DM.makeUniformRandomNode(hidden_size, hidden_size)
        b_n = DM.makeUniformRandomNode(hidden_size, 1)

        a = act
        }

    // For the section with no previous hidden state.
    member l.runLayerNoH (x:DM) =
        let update_gate = linear_layer [|l.W_u,x|] [||] (Some l.b_u) |> sigmoid
        let potential_new_state = linear_layer [|l.W_n,x|] [||] (Some l.b_n) |> l.a
        let output_b = hadmult (scalar_matrix_add 1.0f -1.0f update_gate) potential_new_state
        output_b
    
    // For the section with no input
    member l.runLayerNoI (y:DM) =
        let update_gate = linear_layer [|l.U_u,y|] [||] (Some l.b_u) |> sigmoid
        let reset_gate = linear_layer [|l.U_r,y|] [||] (Some l.b_r) |> sigmoid
        let potential_new_state = linear_layer [|l.U_n, (hadmult reset_gate y)|] [||] (Some l.b_n) |> l.a
        linear_layer [||] [|update_gate,y;(scalar_matrix_add 1.0f -1.0f update_gate),potential_new_state|] None

    // For the section with previous hidden state
    member l.runLayer (x:DM) (y:DM) =
        let update_gate = linear_layer [|l.W_u,x;l.U_u,y|] [||] (Some l.b_u) |> sigmoid
        let reset_gate = linear_layer [|l.W_r,x;l.U_r,y|] [||] (Some l.b_r) |> sigmoid
        let potential_new_state = linear_layer [|l.W_n,x;l.U_n, (hadmult reset_gate y)|] [||] (Some l.b_n) |> l.a
        linear_layer [||] [|update_gate,y;(scalar_matrix_add 1.0f -1.0f update_gate),potential_new_state|] None

// Does gradient clipping in addition to adding weight adjoints to primals.
let add_gradients_to_weights (base_nodes: DM[]) learning_rate clip_coef = 
    for x in base_nodes do 
        gradclipModule.Value.A(clip_coef,x.r.A,x.r.A)
        geam2 nT nT 1.0f x.r.P -learning_rate x.r.A x.r.P

let add_gradients_to_weights' (base_nodes: DM[]) learning_rate = 
    for x in base_nodes do 
        geam2 nT nT 1.0f x.r.P -learning_rate x.r.A x.r.P

let nesterov_add_gradients (base_nodes: DM[]) (momentum_matrices: dMatrix[]) (copy_weights: dMatrix[]) learning_rate momentum_rate clip_coef = 
    for i=0 to base_nodes.Length-1 do
        let x = base_nodes.[i] 
        let m = momentum_matrices.[i]
        let c = copy_weights.[i]
        gradclipModule.Value.A(clip_coef,x.r.A,x.r.A)
        geam2 nT nT -learning_rate x.r.A momentum_rate m m // Add the gradients to the momentum matrices
        geam2 nT nT 1.0f m 1.0f c c // Add momentum to the copy matrix
        geam2 nT nT 1.0f c momentum_rate m x.r.P // Apply Nesterov's momentum to the weights. It is really the copy weights that serve as the basis.

let save_data filename (ar: DM []) =
    use stream_data = File.OpenWrite(filename)
    use writer_data = new BinaryWriter(stream_data)

    // Magic number
    writer_data.Write(929856)

    writer_data.Write(ar.Length)
    for x in ar do
        writer_data.Write((x.r.P).num_rows)
        writer_data.Write((x.r.P).num_cols)
        let t = (x.r.P).dArray.Gather()
        for f in t do writer_data.Write(f)


let load_data file_name is_constant =
    use stream_data = File.OpenRead(file_name)
    use reader_data = new BinaryReader(stream_data)

    let m = reader_data.ReadInt32()
    if m <> 929856 then failwith "Wrong file type in load_weights"

    let l = reader_data.ReadInt32()
    let weights = [|
        for i=1 to l do
            let num_rows = reader_data.ReadInt32()
            let num_cols = reader_data.ReadInt32()
            let ar = [|for x=1 to num_rows*num_cols do yield reader_data.ReadSingle()|]
            match is_constant with
            | true -> yield DM.makeConstantNode(num_rows,num_cols,ar)
            | false -> yield DM.makeNode(num_rows,num_cols,ar)
        |]

    weights

type LSTMLayer =
    {W_z:DM  // Input weight matrix for the block input
     U_z:DM  // Recurrent weight matrix for the block input
     b_z:DM  // Bias vector for the block input

     W_i:DM  // Input weight matrix for the input gate
     U_i:DM  // Recurrent weight matrix for the input gate
     b_i:DM  // Bias vector for the input gate
     P_i:DM  // Peephole weight matrix for the input gate

     W_f:DM  // Input weight matrix for the forget gate
     U_f:DM  // Recurrent weight matrix for the forget gate
     b_f:DM  // Bias vector for the forget gate
     P_f:DM  // Peephole weight matrix for the forget gate

     W_o:DM  // Input weight matrix for the output gate
     U_o:DM  // Recurrent weight matrix for the output gate
     b_o:DM  // Bias vector for the output gate
     P_o:DM  // Peephole weight matrix for the output gate

     block_input_a : DM -> DM
     block_output_a : DM -> DM
     } with
    
    /// Returns all the weights in an array.
    member l.ToArray = [|l.W_z;l.U_z;l.b_z;l.W_i;l.U_i;l.b_i;l.P_i;l.W_f;l.U_f;l.b_f;l.P_f;l.W_o;l.U_o;l.b_o;l.P_o|]
    static member fromArray (a: DM[]) block_input_a block_output_a =
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

    static member createRandomLSTMLayer hidden_size input_size block_input_a block_output_a =
        {
        W_z = DM.makeUniformRandomNode(hidden_size, input_size)
        U_z = DM.makeUniformRandomNode(hidden_size, hidden_size)
        b_z = DM.makeUniformRandomNode(hidden_size, 1)

        W_i = DM.makeUniformRandomNode(hidden_size, input_size)
        U_i = DM.makeUniformRandomNode(hidden_size, hidden_size)
        b_i = DM.makeUniformRandomNode(hidden_size, 1)
        P_i = DM.makeUniformRandomNode(hidden_size, hidden_size)

        W_f = DM.makeUniformRandomNode(hidden_size, input_size)
        U_f = DM.makeUniformRandomNode(hidden_size, hidden_size)
        b_f = DM.makeUniformRandomNode(hidden_size, 1)
        P_f = DM.makeUniformRandomNode(hidden_size, hidden_size)

        W_o = DM.makeUniformRandomNode(hidden_size, input_size)
        U_o = DM.makeUniformRandomNode(hidden_size, hidden_size)
        b_o = DM.makeUniformRandomNode(hidden_size, 1)
        P_o = DM.makeUniformRandomNode(hidden_size, hidden_size)

        block_input_a = block_input_a
        block_output_a = block_output_a
        }

    member l.runLayer (x:DM) (y:DM) (c:DM) =
        let block_input = linear_layer [|l.W_z,x;l.U_z,y|] [||] (Some l.b_z) |> l.block_input_a
        let input_gate = linear_layer [|l.W_i,x;l.U_i,y;l.P_i,c|] [||] (Some l.b_i) |> sigmoid
        let forget_gate = linear_layer [|l.W_f,x;l.U_f,y;l.P_f,c|] [||] (Some l.b_f) |> sigmoid
        let c' = linear_layer [||] [|block_input,input_gate;c,forget_gate|] None
        let output_gate = linear_layer [|l.W_o,x;l.U_o,y;l.P_o,c'|] [||] (Some l.b_o) |> sigmoid
        hadmult (l.block_output_a c') output_gate, c'

    member l.runLayerNoH (x:DM) =
        let block_input = linear_layer [|l.W_z,x|] [||] (Some l.b_z) |> l.block_input_a
        let input_gate = linear_layer [|l.W_i,x|] [||] (Some l.b_i) |> sigmoid
        let forget_gate = linear_layer [|l.W_f,x|] [||] (Some l.b_f) |> sigmoid
        let c' = hadmult block_input input_gate
        let output_gate = linear_layer [|l.W_o,x;l.P_o,c'|] [||] (Some l.b_o) |> sigmoid
        hadmult (l.block_output_a c') output_gate, c'

    member l.runLayerNoI (y:DM) (c:DM) =
        let block_input = linear_layer [|l.U_z,y|] [||] (Some l.b_z) |> l.block_input_a
        let input_gate = linear_layer [|l.U_i,y;l.P_i,c|] [||] (Some l.b_i) |> sigmoid
        let forget_gate = linear_layer [|l.U_f,y;l.P_f,c|] [||] (Some l.b_f) |> sigmoid
        let c' = linear_layer [||] [|block_input,input_gate;c,forget_gate|] None
        let output_gate = linear_layer [|l.U_o,y;l.P_o,c'|] [||] (Some l.b_o) |> sigmoid
        hadmult (l.block_output_a c') output_gate, c'

open System.Drawing

/// Makes a bitmap from dMatrix.
let make_bitmap_from_dmatrix (imageset : dMatrix) row_size col_size num_rows num_cols =
    use imageset = transpose imageset
    let map_slice_to_bitmap (slice : float32 []) (bitmap : Bitmap) start_x end_x start_y end_y =
        let mutable slice_ind = 0
        for x=start_x to end_x do
            for y=start_y to end_y do
                let c = int (slice.[slice_ind])
                slice_ind <- slice_ind+1
                let color = Color.FromArgb(c,c,c)
                bitmap.SetPixel(y,x,color) 
    let float_array = imageset.dArray.Gather()
    let format = System.Drawing.Imaging.PixelFormat.Format24bppRgb
    let bitmap_digit = new Bitmap(col_size*num_cols,row_size*num_rows,format)
    let mutable digits = 0
    for x=0 to num_rows-1 do
        for y=0 to num_cols-1 do
            let start_slice = digits*imageset.num_rows
            let end_slice = (digits+1)*imageset.num_rows-1
            let slice = float_array.[start_slice..end_slice]
            digits <- digits+1

            // Normalization steps for each column.
            let norm = sqrt(slice |> Array.fold (fun state x -> state + x*x) 0.0f)
            let normed_slice = slice |> Array.map ( fun x -> (x / norm) * 127.0f + 127.0f)

            let start_x = x*row_size
            let end_x = start_x+row_size-1
            let start_y = y*col_size
            let end_y = start_y+col_size-1

            if (end_x-start_x+1)*(end_y-start_y+1) <> imageset.num_rows then failwith "(end_x-start_x+1)*(end_y-start_y+1) <> imageset.num_rows"

            map_slice_to_bitmap normed_slice bitmap_digit start_x end_x start_y end_y
    bitmap_digit
