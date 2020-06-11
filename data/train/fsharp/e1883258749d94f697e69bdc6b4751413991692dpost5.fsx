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
let cublas = CudaBlas(str.Stream)
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


let inline divup a b = (a+b-1)/b // Division with rounding up.

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

    member t.A(x: CudaDeviceVariable<floatType>) =
        let n = int x.Size
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(x: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>) =
        let n = int o.Size
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
        t.A(x.dArray,o.dArray)

let rng = System.Random()

let n = 9
let h_a = Array.init n (fun _ -> (rng.NextDouble()-0.5)*6.0 |> floatType)
let a = dMatrix.create(3,3,h_a)

let sigmoidModule = DeviceUnaryTransformModule "1.0f / (1.0f + expf(-x));"
let tanhModule = DeviceUnaryTransformModule "tanhf(x);"
let reluModule = DeviceUnaryTransformModule "x > 0.0f ? x : 0.0f;"

let sig_a = sigmoidModule.A(a)
let tanh_a = tanhModule.A(a)
let relu_a = reluModule.A(a)

let a' = a.Gather'()
let sig_a' = sig_a.Gather'()
let tanh_a' = tanh_a.Gather'()
let relu_a' = relu_a.Gather'()

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

    member t.A(x: CudaDeviceVariable<floatType>, y: CudaDeviceVariable<floatType>) =
        let n = int x.Size
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(x: CudaDeviceVariable<floatType>, y: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>) =
        let n = int o.Size
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
        t.A(x.dArray,y.dArray,o.dArray)

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

    member t.A(x: CudaDeviceVariable<floatType>, y: CudaDeviceVariable<floatType>, z: CudaDeviceVariable<floatType>) =
        let n = int x.Size
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,z.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(x: CudaDeviceVariable<floatType>, y: CudaDeviceVariable<floatType>, z: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>) =
        let n = int o.Size
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
        if z.rc <> o.rc then failwith "y.rc <> o.rc in DeviceTrinaryTransformModule"
        t.A(x.dArray,y.dArray,z.dArray,o.dArray)

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
	            for (int i = 16; i>0; i = i / 2) value += __shfl_down(value, i);
	            return value;
            }

            // Device code
            __global__ void MapSumKernel(const "+FloatTypeCpp+"* A, "+FloatTypeCpp+"* O, const int N)
            {
	            int i = blockDim.x * blockIdx.x + threadIdx.x;
	            const int stride = blockDim.x * gridDim.x;
	            __shared__ "+FloatTypeCpp+" temp[32];
                if (threadIdx.x < 32) temp[threadIdx.x] = 0.0f; "+FloatTypeCpp+" acc = 0.0f;
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

    member t.A(x: CudaDeviceVariable<floatType>) =
        let n = int x.Size
        use o = new_dev<floatType> 1
        o.Memset(0u)
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,o.DevicePointer,n) |> ignore
        o.[SizeT 0]

    member t.A(x: dMatrix) =
        t.A(x.dArray)

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
	            for (int i = 16; i>0; i = i / 2) value += __shfl_down(value, i);
	            return value;
            }

            // Device code
            __global__ void Map2SumKernel(const "+FloatTypeCpp+"* A, const "+FloatTypeCpp+"* B, "+FloatTypeCpp+"* O, const int N)
            {
	            int i = blockDim.x * blockIdx.x + threadIdx.x;
	            const int stride = blockDim.x * gridDim.x;
	            __shared__ "+FloatTypeCpp+" temp[32]; 
                if (threadIdx.x < 32) temp[threadIdx.x] = 0.0f; "+FloatTypeCpp+" acc = 0.0f;
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

    member t.A(x: CudaDeviceVariable<floatType>,y: CudaDeviceVariable<floatType>) =
        let n = int x.Size
        use o = new_dev<floatType> 1
        o.Memset(0u)
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, x.DevicePointer,y.DevicePointer,o.DevicePointer,n) |> ignore
        o.[SizeT 0]

    member t.A(x: dMatrix,y: dMatrix) =
        if x.rc <> y.rc then failwith "x.rc <> y.rc in DeviceBinaryMapSumModule"
        t.A(x.dArray,y.dArray)

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

    member t.A(coef_x: floatType, x: CudaDeviceVariable<floatType>) =
        let n = int x.Size
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(coef_x: floatType, x: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>) =
        let n = int o.Size
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
        t.A(coef_x,x.dArray,o.dArray)

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

    member t.A(coef_x: floatType, x: CudaDeviceVariable<floatType>,coef_y: floatType, y: CudaDeviceVariable<floatType>) =
        let n = int x.Size
        let o = new_dev<floatType> n
        let gridSize = min (2*numSm*(1024/block_size)) (divup n block_size)
        kernel.GridDimensions <- dim3(gridSize)
        kernel.BlockDimensions <- dim3(block_size)
        kernel.RunAsync(str.Stream, coef_x,x.DevicePointer,coef_y, y.DevicePointer,o.DevicePointer,n) |> ignore
        o

    member t.A(coef_x: floatType, x: CudaDeviceVariable<floatType>, coef_y: floatType, y: CudaDeviceVariable<floatType>, o: CudaDeviceVariable<floatType>) =
        let n = int o.Size
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
        t.A(coef_x,x.dArray,coef_y,y.dArray,o.dArray)

// The gradient clipping module.
let gradclipModule = DeviceUnaryCoefTransformModule "(x < -coef_x) ? -coef_x : (x > coef_x ? coef_x : x);"
   
// coef_x = scale
// coef_y = location
// y does not get used.
let randMapModule = DeviceBinaryCoefTransformModule "coef_x*(x-0.5f)+coef_y;"

type dMatrix with
    /// Generates a matrix sampled from a random uniform distribution in <-1.0f,1.0f]
    static member createRandomUniformMatrix weights_num_rows weights_num_cols (scaling_factor : floatType) location =
        let weights_total_size = weights_num_rows*weights_num_cols
        
        let cudaBuffer = new_dev<floatType> weights_total_size
        cudaRandom.GenerateUniform(cudaBuffer)
        //str.Synchronize()

        // 2.0f*scaling_factor ensures that it is rescaled around zero if the scaling_factor is 1.0f.
        randMapModule.A(2.0f*scaling_factor,cudaBuffer,location,cudaBuffer,cudaBuffer)

        dMatrix.create(weights_num_rows,weights_num_cols,cudaBuffer)

    /// Fills matrix by sampling from a random uniform distribution in <-1.0f,1.0f]
    member t.fillRandomUniformMatrix (scaling_factor : floatType) location =
        let weights_total_size = t.num_rows*t.num_cols

        cudaRandom.GenerateUniform(t.dArray)
        // 2.0f*scaling_factor ensures that it is rescaled around zero if the scaling_factor is 1.0f.
        randMapModule.A(2.0f*scaling_factor,t.dArray,location,t.dArray,t.dArray)

let W = dMatrix.createRandomUniformMatrix     3 2 1.0f 0.0f
let bias = dMatrix.createRandomUniformMatrix  3 1 1.0f 0.0f
let W2 = dMatrix.createRandomUniformMatrix    1 3 1.0f 0.0f
let bias2 = dMatrix.createRandomUniformMatrix 1 1 1.0f 0.0f

let input = dMatrix.create(2,4,[|0.0f;0.0f;0.0f;1.0f;1.0f;0.0f;1.0f;1.0f|])
let targets = dMatrix.create(1,4,[|0.0f;1.0f;1.0f;0.0f|])

let inline mm a b = gemm nT nT 1.0f a b
let inline badd a b = broadcastAdd 1.0f a 1.0f b
let inline tanh_act (a: dMatrix) = tanhModule.A(a)
let inline sig_act (a: dMatrix) = sigmoidModule.A(a)

// tanh(W*input + bias)
let a1 = badd (mm W input) bias |> tanh_act
// sigmoid(W2*a1 + bias2)
let o = badd (mm W2 a1) bias2 |> sig_act

let W' = W.Gather'()
let bias' = bias.Gather'()
let W2' = W2.Gather'()
let bias2' = bias2.Gather'()
let input' = input.Gather'()
let targets' = targets.Gather'()

let a1' = a1.Gather'()
let o' = o.Gather'()

let squareDifferenceModule = new DeviceBinaryMapSumModule "(x-y)*(x-y);"

let L2_cost = squareDifferenceModule.A(targets,o)