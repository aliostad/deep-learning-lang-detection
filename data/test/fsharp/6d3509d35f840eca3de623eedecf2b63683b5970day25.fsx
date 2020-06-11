type Source= Constant of int | Register of string 

type Instruction = Copy of Source*Source | Inc of Source | Dec of Source  |Jnz of Source*Source | Toggle of Source | Out of Source

type State = { Registers:Map<string,int>; Program:Instruction[]; Index:int; Output:int list}
let read (state:Map<string,int>) = function | Constant n -> n | Register r -> state.[r]
let copy source dest (registers:Map<string,int>) =
    //printfn "copying %A to %A" source dest
    match dest with 
    | Register register -> registers.Add(register, read registers source)
    | _ -> registers
let inc arg (registers:Map<string,int>) =
    //printfn "incrementing %A" arg
    match arg with 
    | Register register -> registers.Add(register, registers.[register] + 1)
    | _ -> registers
let dec arg (registers:Map<string,int>) =
    //printfn "decrementing %A" arg
    match arg with
    | Register register -> registers.Add(register, registers.[register] - 1)
    | _ -> registers

let jnz source offset (registers:Map<string,int>) =
    //printfn "jnz %A %A" source offset
    if read registers source = 0 then 1 else read registers offset

let out source state =
    let emit = (read state.Registers source)
    let expect = match state.Output with
                    | [] -> 0
                    | head::tail -> if head = 0 then 1 else 0
    //printfn "%d" emit
    let next = if emit=expect then state.Index + 1 else 1001
    if List.length state.Output = 20 then
        printfn "SUCCESS"
        failwith "get out of here" 
    else                
        { state with Output = emit :: state.Output; Index = next }

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
                        | _ -> failwith "toggle undefined"
        //printfn "toggled %A to %A" prog.[offset] toggled
        prog.[offset] <- toggled
    state,1

let apply (st:State) : State = 
    if st.Index = 3 then // multiplication loops
        { st with 
            Registers= (st.Registers.Add("d",st.Registers.["d"] + (abs st.Registers.["c"]) * (abs st.Registers.["b"]))); 
            Index = st.Index + 5 }
    else
        //printf "[%d] " index
        match st.Program.[st.Index] with
        | Copy (source, register) -> { st with Registers = copy source register st.Registers; Index =st.Index + 1 } 
        | Inc register -> { st with Registers = inc register st.Registers; Index = st.Index + 1 }
        | Dec register -> { st with Registers = dec register st.Registers; Index = st.Index + 1 }
        | Jnz (source,offset) -> { st with Index = st.Index + jnz source offset st.Registers }
        | Toggle source -> failwith "not supported" // toggle st state.Registers prog index
        | Out source -> out source st

let rec solve state =
    if state.Index >= state.Program.Length  then
        state
    else
        let newState = apply state  
        solve newState

let (|Source|_|) str = match System.Int32.TryParse str with true, value -> Some (Constant value) | _ -> Some (Register str)

let parseInstruction (inst:string) =
    let parts = inst.Split(' ')
    match parts with 
    | [| "cpy"; Source src; Source dst |] -> Copy (src,dst)
    | [| "inc"; Source reg |] -> Inc reg
    | [| "dec"; Source reg |] -> Dec reg
    | [| "jnz"; Source src; Source offset |] -> Jnz (src, offset) 
    | [| "tgl"; Source src |] -> Toggle src
    | [| "out"; Source src |] -> Out src
    | _ -> failwith ("can't parse " + inst)

let program = System.IO.File.ReadAllLines (__SOURCE_DIRECTORY__ + "\\input.txt") |> Array.map parseInstruction

let startState = Map.empty.Add("a",2539).Add("b",0).Add("c",0).Add("d",0)

for a in [0..10000] do
    printfn "Trying %d" a
    let x = solve { Registers = startState.Add("a",a); Program=program; Index = 0; Output = [] } 
    printfn "Fail"



//let endState = solve (program |> Array.copy) startState 0
//printfn "part a: %d" endState.["a"] // 12860

// program is mutated
//let endStateB = solve (program |> Array.copy) (startState.Add("a",12)) 0
//printfn "part b: %d" endStateB.["a"] // 479009420

