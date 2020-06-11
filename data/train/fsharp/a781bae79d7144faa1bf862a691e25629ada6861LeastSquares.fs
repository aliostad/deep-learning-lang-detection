module Xaye.LeastSquares

open System
open Microsoft.FSharp.NativeInterop
open Microsoft.FSharp.Math
open Xaye.LinearAlgebra

[<Literal>]
let private rowMajor = 101

let gls (y:vector) (x:matrix) (cov:matrix) = 
    if x.IsSparse || cov.IsSparse then raise (new System.NotSupportedException("Matrices must be dense matrices."))
    if cov.NumRows <> cov.NumCols then invalidArg "w" "w must be square."
    if x.NumRows <> cov.NumRows then invalidArg "w" "w's order must be the number of columns of x."

    let m = x.NumRows
    let n = x.NumCols
    let e = Vector.zero m
    let b = Vector.zero n

    let yy = Vector.copy y
    let xx = Matrix.copy x
    let w = Matrix.copy cov

    use yp = PinnedArray.of_vector yy
    use xp = PinnedArray2.of_matrix xx
    use wp = PinnedArray2.of_matrix w
    use ep = PinnedArray.of_vector e
    use bp = PinnedArray.of_vector b

    let status = SafeNativeMethods.LAPACKE_dggglm(rowMajor, m, n, m, xp.Ptr, n, wp.Ptr, m, yp.Ptr, bp.Ptr, ep.Ptr)
    if status <> 0 then raise (NativeException ("Error calling ggglm.", status))    

    b,e

let private betaX (i:int) (beta:vector) (X:matrix) : float= 
    Vector.foldi( fun j acc elem -> acc + (elem * X.[i,j])) 0.0 beta 

let ols (y:vector) (x:matrix) =
    let est = Lapack.solveQR  x (Matrix.ofVector y)
    let beta = est.Column 0
    let error = Vector.mapi(fun i elem -> elem - (betaX i beta x)) y
    beta, error
        

