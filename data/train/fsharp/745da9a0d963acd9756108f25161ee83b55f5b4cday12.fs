module day12

open System.Text.RegularExpressions

type Registers = { a: int; b: int; c: int; d: int }

let initRegisters = {a=0; b=0; c=0; d=0}
let updateRegister regs r v = match r with 
                              | 'a' -> { regs with a = v }
                              | 'b' -> { regs with b = v }
                              | 'c' -> { regs with c = v }
                              | _   -> { regs with d = v }

let getRegister regs = function 
                       | 'a' -> regs.a
                       | 'b' -> regs.b
                       | 'c' -> regs.c
                       | _   -> regs.d

let addRegister regs r v =
    getRegister regs r |> ((+) v) |> updateRegister regs r

type Instruction = 
    | CopyValue of int * char
    | CopyRegister of char * char
    | Increment of char
    | Decrement of char
    | Jump of int * int
    | JumpRegister of char * int

let executeInstruction (index, regs) = 
    let inc = (+) 1
    function CopyValue (v, r)       -> inc index, updateRegister regs r v
           | CopyRegister (rf, rt)  -> inc index, getRegister regs rf |> updateRegister regs rt
           | Increment r            -> inc index, addRegister regs r 1
           | Decrement r            -> inc index, addRegister regs r -1
           | Jump (0, _)            -> inc index, regs
           | Jump (_, x)            -> index + x, regs
           | JumpRegister (r, v)    -> (if getRegister regs r = 0 then inc index
                                        else index + v), regs

let runProgram registers (instructions : Instruction []) =
    let rec execute ((index, _) as state) =
        if index >= instructions.Length then state
        else instructions.[index] |> executeInstruction state |> execute
    execute (0, registers) |> snd 

let (|RegexMatch|_|) pattern input = 
  let m = Regex.Match(input, pattern)
  if m.Success
  then [ for g in m.Groups -> g.Value ] |> List.tail |> Some
  else None

let parseInstruction = function
                       | RegexMatch "cpy ([a-d]) (\w)" [r1; r2]        -> CopyRegister (Seq.head r1, Seq.head r2)
                       | RegexMatch "cpy (-?[0-9]+) (\w)" [v; r]       -> CopyValue (int v, Seq.head r)
                       | RegexMatch "inc ([a-d])" [r]                  -> Increment (Seq.head r)
                       | RegexMatch "dec ([a-d])" [r]                  -> Decrement (Seq.head r)
                       | RegexMatch "jnz ([a-d]) (-?[0-9]+)" [r; v]    -> JumpRegister (Seq.head r, int v)
                       | RegexMatch "jnz (-?[0-9]+) (-?[0-9]+)" [r; v] -> Jump (int r, int v)
                       | failed                                        -> failwith (sprintf "Line failed to parse: %s" failed)


[<EntryPoint>]
let main argv =
    let program = argv.[0] |> System.IO.File.ReadAllLines
                  |> Seq.filter (not << System.String.IsNullOrEmpty)
                  |> Seq.map parseInstruction
                  |> Array.ofSeq

                  
    program |> runProgram initRegisters
    |> (fun {a = aVal} -> aVal)
    |> printfn "Day 12 part 1 result: %d"

    program |> runProgram {initRegisters with c = 1}
    |> (fun {a = aVal} -> aVal)
    |> printfn "Day 12 part 2 result: %d"
    0 // return an integer exit code
