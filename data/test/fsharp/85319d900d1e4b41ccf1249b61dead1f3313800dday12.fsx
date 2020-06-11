type Source= Constant of int | Register of string 
type Instruction = Copy of Source*string | Inc of string | Dec of string  |Jnz of Source*int

let startState = Map.empty.Add("a",0).Add("b",0).Add("c",0).Add("d",0)

let copy source register (state:Map<string,int>) =
    match source with
    | Constant n -> state.Add(register, n)
    | Register r -> state.Add(register, state.[r])
let inc register (state:Map<string,int>) =
    state.Add(register, state.[register] + 1)

let dec register (state:Map<string,int>) =
    state.Add(register, state.[register] - 1)

let jnz source offset (state:Map<string,int>) =
    let test = match source with
                | Register register -> state.[register]
                | Constant constant -> constant 
    if test = 0 then 1 else offset
let apply st = function 
    | Copy (source, register) -> copy source register st, 1
    | Inc register -> inc register st, 1
    | Dec register -> dec register st, 1
    | Jnz (source,offset) -> st, jnz source offset st
    
let rec solve (instructions:Instruction[]) (state:Map<string,int>) index =
    if index >= instructions.Length then
        state
    else
        let newState,next = apply state instructions.[index] 
        solve instructions newState (index+next)


let testInstructions = [|
                        Copy (Constant 41, "a")
                        Inc "a"
                        Inc "a"
                        Dec "a"
                        Jnz (Register "a", 2)
                        Dec "a"
|]

solve testInstructions startState 0 // 42

let (|Source|_|) str = match System.Int32.TryParse str with true, value -> Some (Constant value) | _ -> Some (Register str)
let parseInstruction (inst:string) =
    let parts = inst.Split(' ')
    match parts with 
    | [| "cpy"; Source src; dst |] -> Copy (src,dst)
    | [| "inc"; reg |] -> Inc reg
    | [| "dec"; reg |] -> Dec reg
    | [| "jnz"; Source src; offset |] -> Jnz (src, int offset) 
    | _ -> failwith ("can't parse " + inst)

let instructions = System.IO.File.ReadAllLines (__SOURCE_DIRECTORY__ + "\\input.txt") |> Array.map parseInstruction

let endState = solve instructions startState 0
printfn "part a: %d" endState.["a"] // 318117 
let endStateB = solve instructions (startState.Add("c",1)) 0
printfn "part b: %d" endStateB.["a"] // 9227771
