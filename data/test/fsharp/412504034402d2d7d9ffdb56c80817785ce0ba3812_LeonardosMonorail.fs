module LeonardosMonorail

type Instruction =
    | CpyR of int * int
    | CpyN of int * int
    | Inc of int
    | Dec of int
    | JnzR of int * int
    | JnzN of int * int

type Cpu =
    {
        PC : int
        R : int array
    }

let parseInstruction (instruction:string) =
    let parts = instruction |> split ' '
    printfn "%A" parts
    let parseRegister (r:char) = System.Convert.ToInt32(r) - System.Convert.ToInt32('a')
    match parts.[0] with
    | "cpy" ->
        match System.Int32.TryParse(parts.[1]) with
        | false, _ -> CpyR ((parts.[1].[0] |> parseRegister), (parts.[2].[0] |> parseRegister))
        | true, n -> CpyN (n, (parts.[2].[0] |> parseRegister))
    | "jnz" ->
        match System.Int32.TryParse(parts.[1]) with
        | false, _ -> JnzR ((parts.[1].[0] |> parseRegister), (int parts.[2]))
        | true, n -> JnzN (n, int parts.[2])
    | "inc" -> Inc ((parts.[1].[0] |> parseRegister))
    | "dec" -> Dec ((parts.[1].[0] |> parseRegister))
    | _ -> failwith "Nope"

let runInstruction cpu instruction =
    match instruction with
    | CpyN (n, r) -> 
        let newArray = Array.copy cpu.R
        newArray.[r] <- n
        { cpu with R = newArray; PC = cpu.PC + 1 }
    | CpyR (rs, rd) ->
        let newArray = Array.copy cpu.R
        newArray.[rd] <- newArray.[rs]
        { cpu with R = newArray; PC = cpu.PC + 1 }
    | Inc r ->
        let newArray = Array.copy cpu.R
        newArray.[r] <- newArray.[r] + 1
        { cpu with R = newArray; PC = cpu.PC + 1 }
    | Dec r ->
        let newArray = Array.copy cpu.R
        newArray.[r] <- newArray.[r] - 1
        { cpu with R = newArray; PC = cpu.PC + 1 }
    | JnzN (n0, n1) ->
        if n0 <> 0 then
            { cpu with PC = cpu.PC + n1 }
        else
            { cpu with PC = cpu.PC + 1 }
    | JnzR (r, n) ->
        if cpu.R.[r] <> 0 then
            { cpu with PC = cpu.PC + n }
        else
            { cpu with PC = cpu.PC + 1 }

let run (instructions:array<_>) =
    let mutable cpu = { PC = 0; R = Array.zeroCreate 4 }
    //cpu.R.[2] <- 1 //Uncomment for puzzle 2
    while cpu.PC <= (instructions.Length - 1) do
        cpu <- runInstruction cpu instructions.[cpu.PC]
    cpu

let main input =
    let result = input 
                    |> splitLines
                    |> Array.map parseInstruction
                    |> run
                    |> sprintf "%A"
    [
        result
    ]