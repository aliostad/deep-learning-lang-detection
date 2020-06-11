namespace AoC.Dec12

module Domain =

    type Register = A | B | C | D

    type Machine = { a : int; b : int; c : int; d : int }

    let getValue register machine =
        match register with
        | A -> machine.a
        | B -> machine.b
        | C -> machine.c
        | D -> machine.d

    type Value =
    | Constant of int
    | Register of Register

    let get value machine =
        match value with
        | Constant i -> i
        | Register r -> getValue r machine

    let set register value machine =
        match register with
        | A -> { machine with a = get value machine }
        | B -> { machine with b = get value machine }
        | C -> { machine with c = get value machine }
        | D -> { machine with d = get value machine }

    type Copy = { src : Value; dest : Register }
    type Jump = { condition : Value; steps : int }

    type Instruction =
    | Copy of Copy
    | Jump of Jump
    | Increment of Register
    | Decrement of Register

    type State = { current : int; machine : Machine }

    let mov steps state = { state with current = state.current + steps }
    let cpy state instr = mov 1 { state with machine = set instr.dest instr.src state.machine }
    let jnz state instr = if (get instr.condition state.machine) <> 0 then mov instr.steps state else mov 1 state
    let inc state instr = mov 1 { state with machine = set instr (Constant ((get (Register instr) state.machine) + 1)) state.machine }
    let dec state instr = mov 1 { state with machine = set instr (Constant ((get (Register instr) state.machine) - 1)) state.machine }

    let show state instr =
        let showReg r = match r with A -> "a" | B -> "b" | C -> "c" | D -> "d"

        let showVal v =
            match v with
            | Constant i -> sprintf "%d" i
            | Register r -> showReg r

        let showInstr i =
            match i with
            | Copy c -> sprintf "cpy %s %s" (showVal c.src) (showReg c.dest)
            | Jump j -> sprintf "jnz %s %d" (showVal j.condition) j.steps
            | Increment r -> sprintf "inc %s" (showReg r)
            | Decrement r -> sprintf "dec %s" (showReg r)

        let showMachine m =
            sprintf "[%d %d %d %d]" m.a m.b m.c m.d

        printfn "%s : %d : %s" (showMachine state.machine) state.current (showInstr instr)

    let apply state instr =
        match instr with
        | Copy c -> cpy state c
        | Jump j -> jnz state j
        | Increment r -> inc state r
        | Decrement r -> dec state r

    let rec applyAll state instructions =
        if state.current = List.length instructions
        then state.machine
        else applyAll (apply state instructions.[state.current]) instructions


module Parse =

    open AoC.Utils
    open Domain

    let private register r =
        match r with
        | "a" -> Some A
        | "b" -> Some B
        | "c" -> Some C
        | "d" -> Some D
        | _ -> None

    let private copyConstant v r =
        match Int.parse v, register r with
        | Some i, Some r' -> Some (Copy { src = Constant i; dest = r' })
        | _ -> None

    let private copyRegister s d =
        match register s, register d with
        | Some s', Some d' -> Some (Copy { src = Register s'; dest = d' })
        | _ -> None

    let private jumpRegister c s =
        match register c, Int.parse s with
        | Some c', Some s' -> Some (Jump { condition = Register c'; steps = s' })
        | _ -> None

    let private jumpConstant c s =
        match Int.parse c, Int.parse s with
        | Some c', Some s' -> Some (Jump { condition = Constant c' ; steps = s' })
        | _ -> None

    let private increment r =
        match register r with
        | Some r' -> Some (Increment r')
        | _ -> None

    let private decrement r =
        match register r with
        | Some r' -> Some (Decrement r')
        | _ -> None

    let instruction str =
        match str with
        | Regex.Match "^cpy (-?\d+) (\w)$" [v; r] -> copyConstant v r
        | Regex.Match "^cpy (\w) (\w)$" [src; dst] -> copyRegister src dst
        | Regex.Match "^jnz (-?\d+) (-?\d+)$" [cond; steps] -> jumpConstant cond steps
        | Regex.Match "^jnz (\w) (-?\d+)$" [cond; steps] -> jumpRegister cond steps
        | Regex.Match "^inc (\w)" [r] -> increment r
        | Regex.Match "^dec (\w)" [r] -> decrement r
        | _ -> None

    let instructions = List.choose instruction

module Solver =

    open Domain

    let solve initial =
        Parse.instructions
        >> applyAll initial
        >> (fun state -> state.a)
        >> sprintf "%d"

    module A =

        let solve = solve { machine = { a = 0; b = 0; c = 0; d = 0 }; current = 0 }

    module B =

        let solve = solve { machine = { a = 0; b = 0; c = 1; d = 0 }; current = 0 }
