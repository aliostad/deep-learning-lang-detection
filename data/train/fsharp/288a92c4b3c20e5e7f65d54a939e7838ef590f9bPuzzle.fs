namespace Sudoku

type Value = 
  | One
  | Two
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight
  | Nine

type Cell = 
  | Value of Value
  | Possibles of Value list

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module Cell = 
  let removeValue value cell = 
    match cell with
    | Value _ -> cell
    | Possibles p -> 
      p
      |> List.filter (fun v -> v <> value)
      |> Possibles
  
  let removeValues values cells = values |> List.fold (fun c v -> removeValue v c) cells
  let getSquare (x, y) = (x / 3) + 3 * (y / 3)
  
  let areRelated coords1 coords2 = 
    match coords1, coords2 with
    | (x1, y1), (x2, y2) when x1 = x2 || y1 = y2 -> true
    | _ -> 
      match (getSquare coords1), (getSquare coords2) with
      | s1, s2 when s1 = s2 -> true
      | _ -> false

type GroupType = 
  | Square
  | Row
  | Column

type CellGroup = 
  { groupType : GroupType
    index : int
    cells : Cell list }

type Puzzle = 
  | Puzzle of Cell [,]

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module Puzzle = 
  let intToCell i = 
    match i with
    | 1 -> Value One
    | 2 -> Value Two
    | 3 -> Value Three
    | 4 -> Value Four
    | 5 -> Value Five
    | 6 -> Value Six
    | 7 -> Value Seven
    | 8 -> Value Eight
    | 9 -> Value Nine
    | _ -> Possibles [ One; Two; Three; Four; Five; Six; Seven; Eight; Nine ]

  let valueToInt v = 
    match v with
    | One -> 1
    | Two -> 2
    | Three -> 3
    | Four -> 4
    | Five -> 5
    | Six -> 6
    | Seven -> 7
    | Eight -> 8
    | Nine -> 9
  
  let parseList (grid : int list list) = 
    let a = array2D grid
    match Array2D.length1 a, Array2D.length2 a with
    | 9, 9 -> 
      a
      |> Array2D.map intToCell
      |> Puzzle
    | _, _ -> failwith "incorrect grid"
  
  let isComplete (Puzzle grid) = 
    grid
    |> Array2D.toSeq
    |> Seq.forall (fun c -> 
         match c with
         | Value c -> true
         | _ -> false)
  
  let square i (Puzzle grid) = 
    let x = (i % 3) * 3
    let y = (i / 3) * 3
    grid.[y..y + 2, x..x + 2] |> Seq.cast<Cell>
  
  let squareGroups puzzle = 
    [ for i in 0..8 do
        yield { groupType = Square
                index = i
                cells = square i puzzle |> List.ofSeq } ]
  
  let row i (Puzzle grid) = grid.[i..i, *] |> Seq.cast<Cell>
  
  let rowGroups puzzle = 
    [ for i in 0..8 do
        yield { groupType = Row
                index = i
                cells = row i puzzle |> List.ofSeq } ]
  
  let column i (Puzzle grid) = grid.[*, i..i] |> Seq.cast<Cell>
  
  let columnGroups puzzle = 
    [ for i in 0..8 do
        yield { groupType = Column
                index = i
                cells = column i puzzle |> List.ofSeq } ]
  
  let groups puzzle = 
    [ squareGroups puzzle
      rowGroups puzzle
      columnGroups puzzle ]
    |> List.concat
  
  let cells (Puzzle grid) = 
    grid
    |> Array2D.mapi (fun y x cell -> x, y, cell)
    |> Seq.cast<int * int * Cell>
    |> List.ofSeq
  
  let completeCells puzzle = 
    puzzle
    |> cells
    |> List.choose (function 
         | x, y, Value(v) -> Some(x, y, v)
         | _ -> None)
  
  let isValid puzzle = 
    puzzle
    |> cells
    |> List.forall (function 
         | _, _, Possibles(p) -> List.length p > 0
         | _ -> true)
    && puzzle
       |> groups
       |> List.forall (fun { cells = c } -> 
            c
            |> List.choose (function 
                 | Value(v) -> Some v
                 | _ -> None)
            |> List.groupBy (fun c -> c)
            |> List.forall (fun (_, g) -> (List.length g) < 2))
  
  let replaceCell (c : option<int * int * Cell>) puzzle = 
    match c with
    | None -> puzzle
    | Some(x, y, cell) -> 
      let (Puzzle grid) = puzzle
      let copy = Array2D.copy grid
      copy.[y, x] <- cell
      Puzzle copy
  
  let replaceGroup (group : option<CellGroup>) puzzle = 
    match group with
    | None -> puzzle
    | Some({ groupType = Square; index = index; cells = cells }) -> 
      let (Puzzle grid) = puzzle
      let copy = Array2D.copy grid
      let startX = (index % 3) * 3
      let startY = (index / 3) * 3
      cells |> List.iteri (fun i c -> 
                 let x = startX + i % 3
                 let y = startY + i / 3
                 copy.[y, x] <- c)
      Puzzle copy
    | Some({ groupType = Row; index = index; cells = cells }) -> 
      let (Puzzle grid) = puzzle
      let copy = Array2D.copy grid
      cells |> List.iteri (fun i c -> copy.[index, i] <- c)
      Puzzle copy
    | Some({ groupType = Column; index = index; cells = cells }) -> 
      let (Puzzle grid) = puzzle
      let copy = Array2D.copy grid
      cells |> List.iteri (fun i c -> copy.[i, index] <- c)
      Puzzle copy
