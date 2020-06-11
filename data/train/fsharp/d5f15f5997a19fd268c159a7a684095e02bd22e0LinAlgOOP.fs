module LinAlgOOP
type Matrix = class
  val private _array: float[,]
  
  new(rows: int, cols: int) = {
    _array = Array2D.zeroCreate rows cols
  }
  
  new(a2DArray: float[,]) = {
    _array = a2DArray
  }

  member this.Item
    with get(a: int, b: int) = this._array.[a, b]
    and set(a: int, b: int) (value:float) = this._array.[a, b] <- value

  member this.ToArray =
    this._array
    
  member this.rows =
    this._array.GetLength(0)
    
  member this.cols =
    this._array.GetLength(1)

  // Note, can still be called from this module
  member private this.Copy(a: float[,], ?row: int, ?col: int) =
    let row = 
      match row with
        | Some(v) -> v
        | None -> 0
    let col = 
      match col with
        | Some(v) -> v
        | None -> 0
    for i in 0..a.GetLength(0)-1 do
      for j in 0..a.GetLength(1)-1 do
        this._array.[row+i,col+j] <- a.[i,j]
    this

  // Note, can still be called from this module
  member private this.CopyCol(a: float[], ?row: int, ?col: int) =
    let row = 
      match row with
        | Some(v) -> v
        | None -> 0
    let col = 
      match col with
        | Some(v) -> v
        | None -> 0
    for i in 0..a.GetLength(0)-1 do
      this._array.[row+i,col] <- a.[i]
    this

  // Note, can still be called from this module
  member private this.CopyRow(a: float[], ?row: int, ?col: int) =
    let row = 
      match row with
        | Some(v) -> v
        | None -> 0
    let col = 
      match col with
        | Some(v) -> v
        | None -> 0
    for j in 0..a.GetLength(0)-1 do
      this._array.[row,col+j] <- a.[j]
    this

  member this.GetSlice(rowStart: int option, rowFinish: int option, colStart: int option, colFinish: int option) =
    let rowStart =
      match rowStart with
        | Some(v) -> v
        | None -> 0
    let rowFinish =
      match rowFinish with
        | Some(v) -> v
        | None -> this._array.GetLength(0) - 1
    let colStart =
      match colStart with
        | Some(v) -> v
        | None -> 0
    let colFinish =
      match colFinish with
        | Some(v) -> v
        | None -> this._array.GetLength(1) - 1
    let rows = rowFinish-rowStart+1
    let cols = colFinish-colStart+1
    let slice = new Matrix(rows,cols)
    slice.Copy(this._array.[rowStart..rowFinish, colStart..colFinish])

  member this.GetSlice(row: int, colStart: int option, colFinish: int option) =
    let colStart =
      match colStart with
        | Some(v) -> v
        | None -> 0
    let colFinish =
      match colFinish with
        | Some(v) -> v
        | None -> this._array.GetLength(1) - 1
    let slice = new Matrix(1,colFinish-colStart+1)
    slice.CopyRow(this._array.[row, colStart..colFinish])

  member this.GetSlice(rowStart: int option, rowFinish: int option, col: int) =
    let rowStart =
      match rowStart with
        | Some(v) -> v
        | None -> 0
    let rowFinish =
      match rowFinish with
        | Some(v) -> v
        | None -> this._array.GetLength(0) - 1
    let slice = new Matrix(rowFinish-rowStart+1,1)
    slice.CopyCol(this._array.[rowStart..rowFinish, col])

  member this.ColConcat(other: Matrix) =
    if this.rows <> other.rows then
      invalidArg "other" "The matrix row sizes do not match"
    else
      let result = Matrix(this.rows,this.cols+other.cols)
      result.Copy(this.ToArray) |> ignore
      result.Copy(other.ToArray, 0, this.cols) |> ignore
      result
        
  member this.RowConcat(other: Matrix) =
    if this.cols <> other.cols then
      invalidArg "other" "The matrix column sizes do not match"
    else
      let result = Matrix(this.rows+other.rows,this.cols)
      result.Copy(this.ToArray) |> ignore
      result.Copy(other.ToArray, this.rows, 0) |> ignore
      result

  member this.Minor(i:int, j:int) =
    let result = Matrix(this.rows-1,this.cols-1)
    if i>0 && j>0 then result.Copy(this._array.[0..i-1,0..j-1]) |> ignore
    if i>0 && j<this.cols-1 then result.Copy(this._array.[0..i-1,j+1..this.cols-1],0,j) |> ignore
    if i<this.rows && j>0 then result.Copy(this._array.[i+1..this.rows-1,0..j-1],i,0) |> ignore
    if i<this.rows && j<this.cols-1 then result.Copy(this._array.[i+1..this.rows-1,j+1..this.cols-1],i,j) |> ignore
    result

  member this.Det =
    let mutable sum = 0.0
    if this.rows = 2 then
      sum <- this._array.[0,0]*this._array.[1,1]-this._array.[0,1]*this._array.[1,0]
    else
      for j in 0..this.cols-1 do
        let minor = this.Minor(0,j)
        let minorDet = minor.Det
        let cofactor = (-1.0**float j)*this._array.[0,j]*minorDet
        sum <- sum+cofactor
    sum
      
  static member Id(rows:int) =
    let result = new Matrix(rows,rows)
    for i in 0..rows-1 do
      result.[i,i] <- 1.0
    result

  member this.Transpose =
    let result = new Matrix(this.cols,this.rows)
    for i in 0..this.rows-1 do
      for j in 0..this.cols-1 do
        result.[j,i] <- this._array.[i,j]
    result

  member this.Add(other: Matrix) =
    if this.rows <> other.rows && this.cols <> other.cols then
      invalidArg "other" "The matrix sizes do not match"
    else
      let result = Matrix(this.rows,this.cols)
      for i in 0..this.rows-1 do
        for j in 0..this.cols-1 do
          result.[i,j] <- this._array.[i,j] + other.[i,j]
      result
        
  member this.Mul(a: float) =
    let result = Matrix(this.rows,this.cols)
    for i in 0..this.rows-1 do
      for j in 0..this.cols-1 do
        result.[i,j] <- this._array.[i,j]*a
    result

  member this.Mul(other: Matrix) =
    if this.cols <> other.rows && this.cols <> other.cols then
      invalidArg "other" "The matrix number of rows does not match this' number of columns"
    else
      let result = Matrix(this.rows,other.cols)
      for i in 0..this.rows-1 do
        for j in 0..other.cols-1 do
          result.[i,j] <- 0.0;
          for k in 0..this.cols-1 do
            result.[i,j] <- result.[i,j] + this._array.[i,k]*other.[k,j]
      result

  member this.Cramer(b: Matrix) =
    let x = new Matrix(this.rows, 1)
    let detA = this.Det
    for i in 0..this.rows-1 do
      let ai = this._array.[*,i]
      this.Copy(b.ToArray,0,i) |> ignore
      x.[i,0] <- this.Det/detA
      this.CopyCol(ai,0,i) |> ignore
    x

  member this.Inverse() =
    let Inv = new Matrix(this.cols, this.rows)
    for i in 0..this.rows-1 do
      let e = Matrix(this.cols,1)
      e.[i,0]<-1.0
      let x = this.Cramer(e)
      let b = this.Mul(x)
      printfn "Ax=\n%A" b.ToArray
      Inv.Copy(x.ToArray, 0, i) |> ignore
    printfn "Inv=\n%A" Inv.ToArray
    Inv

  static member Random (rows:int) (cols:int)=
    let A = new Matrix(rows, cols)
    let rnd = System.Random()
    for i in 0..rows-1 do
      for j in 0..cols-1 do
        A.[i,j]<-rnd.NextDouble()
    A
end
