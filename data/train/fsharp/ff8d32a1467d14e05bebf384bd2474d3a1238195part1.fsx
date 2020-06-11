open System;;
open System.Text.RegularExpressions;;

exception Ex of string;;

type Instruction =
    | CopyImmediate of int * string
    | CopyRegister of string * string
    | Inc of string
    | Dec of string
    | JumpNotZeroImmediate of int * int
    | JumpNotZeroReg of string * int
;;

type State = { inst : int; registers : Map<string, int> };;

let rexmatch pat str =
    let m = Regex.Match(str, pat) in
    if m.Groups.Count = 0 then
        []
    else
        List.tail [ for g in m.Groups -> g.Value ]
;;

let parseInstruction line =
    match rexmatch @"^cpy (-?\d+) ([a-zA-Z]+)$" line with
    | [a; b] -> CopyImmediate(Convert.ToInt32(a), b)
    | [] ->
        match rexmatch @"^cpy ([a-zA-Z]+) ([a-zA-Z]+)$" line with
        | [a; b] -> CopyRegister(a, b)
        | [] ->
            match rexmatch @"^inc ([a-zA-Z]+)$" line with
            | [a] -> Inc(a)
            | [] ->
                match rexmatch @"^dec ([a-zA-Z]+)$" line with
                | [a] -> Dec(a)
                | [] ->
                    match rexmatch @"^jnz (-?\d+) (-?\d+)$" line with
                    | [a; b] -> JumpNotZeroImmediate(Convert.ToInt32(a), Convert.ToInt32(b))
                    | [] ->
                        match rexmatch @"^jnz ([a-zA-Z]+) (-?\d+)$" line with
                        | [a; b] -> JumpNotZeroReg(a, Convert.ToInt32(b))
                        | _ -> raise (Ex (sprintf "invalid directive! %s" line))
                    | _ -> raise (Ex (sprintf "invalid directive! %s" line))
                | _ -> raise (Ex (sprintf "invalid directive! %s" line))
            | _ -> raise (Ex (sprintf "invalid directive! %s" line))
        | _ -> raise (Ex (sprintf "invalid directive! %s" line))
    | _ -> raise (Ex (sprintf "invalid directive! %s" line))
;;

let rec processLines programSoFar =
    let line = Console.ReadLine() in
    if String.length line = 0 then
        programSoFar
    else
        let inst = parseInstruction line in
        processLines (programSoFar @ [inst])
;;

let rec runProgram program state =
    (*let _ = printfn "state: %A" state in*)
    let doJumpNotZero value offset =
        let instOffset =
            if value = 0 then
                1
            else
                offset
        in
        { inst = state.inst + instOffset; registers = state.registers }
    in
    if state.inst < (Array.length program) then
        (*let _ = printfn "inst: %A" program.[state.inst] in*)
        let newState =
            match program.[state.inst] with
            | CopyImmediate(value, reg) -> { inst = state.inst + 1; registers = (Map.add reg value state.registers) }
            | CopyRegister(srcReg, destReg) -> { inst = state.inst + 1; registers = (Map.add destReg (Map.tryFind srcReg state.registers).Value state.registers) }
            | Inc(reg) -> { inst = state.inst + 1; registers = (Map.add reg ((Map.tryFind reg state.registers).Value + 1) state.registers) }
            | Dec(reg) -> { inst = state.inst + 1; registers = (Map.add reg ((Map.tryFind reg state.registers).Value - 1) state.registers) }
            | JumpNotZeroImmediate(value, offset) -> doJumpNotZero value offset
            | JumpNotZeroReg(reg, offset) -> doJumpNotZero (Map.tryFind reg state.registers).Value offset
        in
        (*let _ = printfn "" in*)
        runProgram program newState
    else
        state
;;

let REGISTERS =
    [
        ("a", 0);
        ("b", 0);
        ("c", 1);
        ("d", 0);
    ]
;;

let instructionList = processLines [] in
let program = Array.ofList instructionList in
let _ = List.iteri (printfn "%3d: %A") instructionList in
let _ = printfn "" in
let initialRegisters = List.fold (fun map (reg, value) -> Map.add reg value map) Map.empty REGISTERS in
let finalState = runProgram program { inst = 0; registers = initialRegisters } in
printfn "%A" finalState
;;
