type Source= Constant of int | Register of string 

type Instruction = Copy of Source*Source | Inc of Source | Dec of Source  |Jnz of Source*Source | Toggle of Source

let read (state:Map<string,int>) = function | Constant n -> n | Register r -> state.[r]
let copy source dest (state:Map<string,int>) =
    //printfn "copying %A to %A" source dest
    match dest with 
    | Register register -> state.Add(register, read state source)
    | _ -> state
let inc arg (state:Map<string,int>) =
    //printfn "incrementing %A" arg
    match arg with 
    | Register register -> state.Add(register, state.[register] + 1)
    | _ -> state
let dec arg (state:Map<string,int>) =
    //printfn "decrementing %A" arg
    match arg with
    | Register register -> state.Add(register, state.[register] - 1)
    | _ -> state

let jnz source offset (state:Map<string,int>) =
    //printfn "jnz %A %A" source offset
    if read state source = 0 then 1 else read state offset

let toggle state source (prog:_[]) index =
    let offset = index + (read state source)
    //printfn "toggle %A (offset %d)" source offset
    if offset >= 0 && offset < prog.Length then
        let toggled = match prog.[offset] with
                        | Copy (source, register) -> Jnz (source, register) 
                        | Inc register -> Dec register 
                        | Dec register -> Inc register
                        | Jnz (source,off) -> Copy (source, off)
                        | Toggle source -> Inc source
        //printfn "toggled %A to %A" prog.[offset] toggled
        prog.[offset] <- toggled
    state,1

let apply (st:Map<string,int>) (prog:_[]) index = 
    if index = 5 || index = 21 then // multiplication loops
        st.Add("a",st.["a"] + (abs st.["c"]) * (abs st.["d"])), 5
    else
        //printf "[%d] " index
        match prog.[index] with
        | Copy (source, register) -> copy source register st, 1
        | Inc register -> inc register st, 1
        | Dec register -> dec register st, 1
        | Jnz (source,offset) -> st, jnz source offset st
        | Toggle source -> toggle st source prog index

let rec solve (prog:Instruction[]) (state:Map<string,int>) index =
    if index >= prog.Length then
        state
    else
        let newState,next = apply state prog index 
        solve prog newState (index+next)

let (|Source|_|) str = match System.Int32.TryParse str with true, value -> Some (Constant value) | _ -> Some (Register str)

let parseInstruction (inst:string) =
    let parts = inst.Split(' ')
    match parts with 
    | [| "cpy"; Source src; Source dst |] -> Copy (src,dst)
    | [| "inc"; Source reg |] -> Inc reg
    | [| "dec"; Source reg |] -> Dec reg
    | [| "jnz"; Source src; Source offset |] -> Jnz (src, offset) 
    | [| "tgl"; Source src |] -> Toggle src
    | _ -> failwith ("can't parse " + inst)

let program = System.IO.File.ReadAllLines (__SOURCE_DIRECTORY__ + "\\input.txt") |> Array.map parseInstruction

let testProg = [|"cpy 2 a";"tgl a";"tgl a";"tgl a";"cpy 1 a";"dec a";"dec a"|] |> Array.map parseInstruction


let startState = Map.empty.Add("a",7).Add("b",0).Add("c",0).Add("d",0)

// (solve testProg startState 0).["a"] |> printfn "test: %d" // expect 3
let endState = solve (program |> Array.copy) startState 0
printfn "part a: %d" endState.["a"] // 12860

// program is mutated
let endStateB = solve (program |> Array.copy) (startState.Add("a",12)) 0
printfn "part b: %d" endStateB.["a"] // 479009420

// loop 1 is index 5-9
// loop 2 is index 21-25