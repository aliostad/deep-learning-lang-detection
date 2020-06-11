#load "./../common.fsx"

open Common

type Register = A | B | C | D
and Holder = Register of Register | Value of int
and Instruction = 
  | Inc of Register
  | Dec of Register
  | Copy of Holder*Register
  | JumpIfNonZero of Holder*Holder
and RegisterState = Map<Register,int>
and ProgramState = RegisterState*int
and StateChangeFn = ProgramState -> ProgramState

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module Register = 
  let extractValue = Map.find

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module Holder = 
  let extractValue = function | Value v -> (fun _ -> v) | Register r -> Register.extractValue r

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module Instruction = 

  let execute instruction = 
    match instruction with 
    | Copy (s,t) -> 
      let stateChange (rs : RegisterState, ptr) = 
        let valueToCopy = Holder.extractValue s rs
        (rs |> Map.add t valueToCopy, ptr + 1)
      stateChange
    | JumpIfNonZero (h, i) -> 
      let stateChange (rs : RegisterState, ptr) = 
        let holderValue = Holder.extractValue h rs
        let jumpValue = Holder.extractValue i rs
        if holderValue <> 0 then (rs, ptr + jumpValue)
        else (rs, ptr + 1)
      stateChange
    | Inc r -> 
      let stateChange (rs : RegisterState, ptr) = 
        let registerValue = Register.extractValue r rs
        (rs |> Map.add r (registerValue + 1), ptr + 1)
      stateChange
    | Dec r -> 
      let stateChange (rs : RegisterState, ptr) = 
        let registerValue = Register.extractValue r rs
        (rs |> Map.add r (registerValue - 1), ptr + 1)
      stateChange

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module Parsing = 

  let parseRegister (str : string) = 
    match str.Trim() with
    | "a" -> A
    | "b" -> B
    | "c" -> C
    | "d" -> D
    |> Register

  let parseHolder (str : string) = 
    match str |> Int.tryParse with
    | None -> parseRegister str
    | Some i -> Value i

  let (|Copy|_|) (str : string) = 
    match str.StartsWith("cpy") with
    | true -> 
        let [ holder; Register value ] = str |> String.split ' ' |> List.ofSeq |> List.skip 1 |> List.map(parseHolder)
        Some (holder, value)
    | false  -> None

  let (|Inc|_|) (str : string) = 
    match str.StartsWith("inc") with
    | true -> 
        let [ Register value ] = str |> String.split ' ' |> List.ofSeq |> List.skip 1 |> List.map(parseHolder)
        Some (value)
    | false  -> None

  let (|Dec|_|) (str : string) = 
    match str.StartsWith("dec") with
    | true -> 
        let [ Register value ] = str |> String.split ' ' |> List.ofSeq |> List.skip 1 |> List.map(parseHolder)
        Some (value)
    | false  -> None

  let (|Jump|_|) (str : string) = 
    match str.StartsWith("jnz") with
    | true ->  
        let [ holder ; value ] = str |> String.split ' ' |> List.ofSeq |> List.skip 1 |> List.map(parseHolder)
        Some (holder, value)
    | false  -> None

  let parse = function
    | Copy x -> Copy x
    | Inc x -> Inc x
    | Dec x -> Dec x
    | Jump x -> JumpIfNonZero x
    | y -> failwithf "Unparsable instruction: %s" y