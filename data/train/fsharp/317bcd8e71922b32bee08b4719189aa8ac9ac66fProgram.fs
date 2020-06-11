
type Computer = { a:int; b:int; c:int; d:int; pc:int }

type Copy = { src:string; dest: string }
type Increment = { register: string }
type Decrement = { register: string }
type JumpNZ = { register: string; amount:int }
type Command =
    | Cpy of Copy
    | Inc of Increment
    | Dec of Decrement
    | Jnz of JumpNZ

let validRegister (s:string) =
    if (s="a" || s="b" || s="c" || s="d") then true
    else false

let isInt (s:string) =
    let is,_ = System.Int32.TryParse(s)
    is

let strToCmd (s:string) : (Command Option) =
    match (s.Substring(0, 3)) with
    | "cpy" -> 
        let parts = s.Split([|' '|], 3)
        if (validRegister (parts.[2]) && (validRegister (parts.[1]) || isInt (parts.[1]))) then
            Some (Cpy { src=parts.[1]; dest=parts.[2] })
        else
            None
    | "inc" ->
        let parts = s.Split([|' '|], 2)
        if (validRegister (parts.[1])) then Some (Inc { register=(parts.[1]) })
        else None
    | "dec" ->
        let parts = s.Split([|' '|], 2)
        if (validRegister (parts.[1])) then Some (Dec { register=(parts.[1]) })
        else None
    | "jnz" ->
        let parts = s.Split([|' '|], 3)
        if ((validRegister (parts.[1]) || isInt (parts.[1])) && isInt (parts.[2])) then
            Some (Jnz { register=parts.[1]; amount=(System.Int32.Parse(parts.[2])) })
        else
            None
    | _ -> None

let setRegister (c:Computer) (r:string) (v:int) =
    match r with
    | "a" -> { c with a=v }
    | "b" -> { c with b=v }
    | "c" -> { c with c=v }
    | "d" -> { c with d=v }
    | _ -> c

let getRegister (c:Computer) (r:string) =
    match r with
    | "a" -> c.a
    | "b" -> c.b
    | "c" -> c.c
    | "d" -> c.d
    | _ -> 0

let doCopy (c:Computer) (cmd:Copy) =
    let copyVal =
        if (isInt cmd.src) then System.Int32.Parse(cmd.src)
        else getRegister c cmd.src
    let c' = setRegister c cmd.dest copyVal
    { c' with pc=(c'.pc + 1) }

let doIncrement (c:Computer) (cmd:Increment) =
    let cur = getRegister c cmd.register
    let c' = setRegister c cmd.register (cur+1)
    { c' with pc=(c'.pc + 1) }

let doDecrement (c:Computer) (cmd:Decrement) =
    let cur = getRegister c cmd.register
    let c' = setRegister c cmd.register (cur-1)
    { c' with pc=(c'.pc + 1) }

let doJNZ (c:Computer) (cmd:JumpNZ) =
    let cur = 
        if (isInt cmd.register) then System.Int32.Parse(cmd.register)
        else getRegister c cmd.register
    if (cur=0) then
        { c with pc=(c.pc + 1) }
    else
        { c with pc=(c.pc + cmd.amount ) }

let runCommand (c:Computer) (cmd:Command) =
    match cmd with
    | Cpy i -> doCopy c i
    | Inc i -> doIncrement c i
    | Dec i -> doDecrement c i
    | Jnz i -> doJNZ c i

let rec runProgram (c:Computer) (cmds:Command array) =
    if (c.pc >= cmds.Length) then
        c
    else
        let c' = runCommand c cmds.[c.pc]
        runProgram c' cmds

[<EntryPoint>]
let main argv = 
    let file = System.IO.File.ReadAllLines("Input.txt")
    let cmds = Array.map strToCmd file |> Array.choose id
    //Array.iteri (fun i x -> printfn "%d:%A" i x) cmds
    let start = { a=0; b=0; c=0; d=0; pc=0 }
    let result = runProgram start cmds
    printfn "%A" result
    let start' = { a=0; b=0; c=1; d=0; pc=0 }
    let result' = runProgram start' cmds
    printfn "%A" result'
    0 // return an integer exit code
