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

let a = dMatrix.create(5,3)
a.set 1.5f
let b = dMatrix.create(3,4)
b.set 2.3f

let c = gemm nT nT 1.0f a b

let a' = a.Gather'()
let b' = b.Gather'()
let c' = c.Gather'()

let c'2 = geam nT nT 0.1f c 0.0f c // Multiplies the first array by 0.1f and the second by 0.0f
let c'2' = c'2.Gather'()

let bias = dMatrix.create(5,1)
for i=0 to 4 do bias.[i,0] <- 0.5f + floatType i

let bias' = bias.Gather'()

let d = broadcastAdd 1.0f c'2 1.0f bias
let d' = d.Gather'()
let e = rowSum 1.0f d
let e' = e.Gather'()
let e2 = rowSum 2.0f d
let e2' = e2.Gather'()