open System.IO
open System
open System.Numerics
#r "bin/Debug/Library.dll"
open Advent.Library

let (|REG|_|) = function
   | "a" -> Some 0
   | "b" -> Some 1
   | "c" -> Some 2
   | "d" -> Some 3
   | _ -> None

type Value = Register of string | Value of int
type Instr = | Copy of Value * Value | Inc of Value | Dec of Value | Jump of Value * Value | Toggle of Value | Out of Value
let parse (s:string) = 
    match s with
    | Prefix "cpy " (TakeWhile ' ' ((Int d), Prefix " " (register))) -> Copy(Value d,Register register)
    | Prefix "cpy " (TakeWhile ' ' (register1, Prefix " " (register2))) -> Copy(Register register1,Register register2)
    | Prefix "inc " register -> Inc(Register register)
    | Prefix "dec " register -> Dec(Register register)
    | Prefix "jnz " (TakeWhile ' ' ((Int d), Prefix " " (Int instructions) )) -> Jump(Value d,          Value instructions)
    | Prefix "jnz " (TakeWhile ' ' (register1, Prefix " " (Int instructions))) -> Jump(Register register1,Value instructions)
    | Prefix "jnz " (TakeWhile ' ' ((Int d), Prefix " " (register2))) -> Jump(Value d,Register register2)
    | Prefix "jnz " (TakeWhile ' ' (register1, Prefix " " (register2))) -> Jump(Register register1,Register register2)
    | Prefix "tgl " (Int d) -> Toggle(Value(d))
    | Prefix "tgl " register -> Toggle(Register(register))
    | Prefix "out " (Int d) -> Out(Value(d))
    | Prefix "out " register -> Out(Register(register))
    | x -> failwith <| sprintf "Couldn't parse %s" x
let toggle  = function
    | Copy (v,v2) -> Jump(v,v2)
    | Inc (v) -> Dec(v) 
    | Out(v) | Dec (v) | Toggle(v) -> Inc(v)
    | Jump (v,i) -> Copy(v,i)
let doWork registers instructions  = seq {
    let (|AnyVal|_|) = function
        | Register (REG ind) -> Some (Array.item ind registers)
        | Value (d) -> Some d
        | _ -> None
    let (|Instr|) (instructions:_[]) start =
        Array.item start instructions
    while registers.[4] < (Array.length instructions) do
        let instrNumber = registers.[4] |> int 
        match instrNumber with
        | Instr instructions (Copy(AnyVal d, Register(REG ind))) -> registers.[ind] <- d; registers.[4] <- registers.[4] + 1
        | Instr instructions (Inc(Register (REG ind)))-> registers.[ind] <- registers.[ind] + 1; registers.[4] <- registers.[4] + 1
        | Instr instructions (Dec(Register (REG ind)))-> registers.[ind] <- registers.[ind] - 1; registers.[4] <- registers.[4] + 1
        | Instr instructions (Jump(AnyVal d,AnyVal instructionsJump) )-> if d = 0 then registers.[4] <- registers.[4] + 1
                                                                         else registers.[4] <- registers.[4] + instructionsJump
        | Instr instructions (Toggle(AnyVal d)) when registers.[4] + d < instructions.Length -> instructions.[registers.[4] + d] <- toggle instructions.[registers.[4] + d]; registers.[4] <- registers.[4] + 1
        | Instr instructions (Out (AnyVal d)  ) -> yield d; registers.[4] <- registers.[4] + 1
        | x -> printfn "Didn't do %A" x; registers.[4] <- registers.[4] + 1
}

let file = "\input.txt"
let instructions = File.ReadAllLines(__SOURCE_DIRECTORY__ + file) |> Array.map parse 
let genSignal = (fun i -> 
                        let signal = doWork [| i;0;0;0;0 |] instructions
                        if signal |> Seq.chunkBySize 2 |> Seq.take 1000 |> Seq.forall (fun [|x;y|] -> x = 0 && y = 1) then (i,true)
                        else (i,false))

Seq.initInfinite genSignal 
|> Seq.skipWhile (snd >> not)
|> Seq.take 1
|> Seq.map(fst)
|> Seq.head





