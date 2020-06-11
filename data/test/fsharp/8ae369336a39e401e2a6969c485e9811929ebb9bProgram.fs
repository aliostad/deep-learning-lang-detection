module BrainFuckInstruction
open Instructions
open MachineState

let advanceInstruction state =
    match state.instructions with
    | [] -> state
    | x::xs -> { state with instructions = xs }

let processTapeElem elemPosition tape elemAction =
    let myTape = tape |> List.mapi (fun currentPosition currentElem ->
            if currentPosition = elemPosition 
            then elemAction currentElem 
            else currentElem)
    myTape

/// <param name="instructionsAtBeginningOfRoutine">It is the instructions list when a loop was started.
/// if it equals None then we are not inside a loop. Otherwise we use it to re execute the loop
/// when an end of loop instruction is encountered.</param>
let rec processRoutine instructionsAtBeginningOfRoutine currentState =
    let { 
            position = position; 
            instructions = currentInstructions; 
            tape = tape;
            input = currentInput;
        } = currentState
    let operateOnTapeElem = processTapeElem position tape
    let handleInstruction instruction =
        match instruction with
        | Debug -> currentState
        | Increment -> { currentState with position = position+1 }
        | Decrement -> { currentState with position = position-1 }
        | Plus -> { currentState with tape = operateOnTapeElem (fun elem -> elem+1uy) }
        | Minus -> { currentState with tape = operateOnTapeElem (fun elem -> elem-1uy) }
        | StartOfLoop -> 
            match tape.Item position with
            | 0uy -> 
                let instructionsAfterLoop = skipLoop currentInstructions
                { currentState with instructions = instructionsAfterLoop }

            | _ -> processRoutine (Some currentInstructions.Tail) (currentState |> advanceInstruction)
        | EndOfLoop ->
            match instructionsAtBeginningOfRoutine with
                | Some instructions' -> 
                    if tape.Item position <> 0uy
                    then processRoutine (Some instructions') { currentState with instructions = instructions' }
                    else currentState
                | None ->
                    failwith "Unmatched end of loop operator"
        | Point -> 
            let currentByte = List.item currentState.position currentState.tape
            printf "%s" (System.Text.Encoding.ASCII.GetString [|currentByte|])
            currentState
        | Comma -> 
            if Seq.isEmpty currentInput
            then failwith "Input is empty"
            else 
                let input = Seq.head currentInput
                let newTape = operateOnTapeElem (fun _ -> input)
                { currentState with tape = newTape; input = Seq.tail currentInput }
        
    match currentInstructions with
    | [] -> currentState
    | x::xs ->
        let newState = handleInstruction x
        if (x<>EndOfLoop) 
        then processRoutine instructionsAtBeginningOfRoutine (newState |> advanceInstruction)
        else newState

let processProgram = processRoutine None

let inputToByteSeq input = 
    seq { for c in input -> Array.head(System.Text.Encoding.ASCII.GetBytes [|c|]) }

[<EntryPoint>]
let main argv = 
    let instructions = 
//        """+++[>+++[>+<-]<-]"""
        """+++++++++++>+>>>>++++++++++++++++++++++++++++++++++++++++++++>++++++++++++++++++++++++++++++++<<<<<<[>[>>>>>>+>+<<<<<<<-]>>>>>>>[<<<<<<<+>>>>>>>-]<[>++++++++++[-<-[>>+>+<<<-]>>>[<<<+>>>-]+<[>[-]<[-]#]>[<<[>>>+<<<-]>>[-]]<<]>>>[>>+>+<<<-]>>>[<<<+>>>-]+<[>[-]<[-]]>[<<+>>[-]]<<<<<<<]>>>>>[++++++++++++++++++++++++++++++++++++++++++++++++.[-]]++++++++++<[->-<]>++++++++++++++++++++++++++++++++++++++++++++++++.[-]<<<<<<<<<<<<[>>>+>+<<<<-]>>>>[<<<<+>>>>-]<-[>>.>.<<<[-]]<<[>>+>+<<<-]>>>[<<<+>>>-]<<[<+>-]>[<+>-]<<<-]"""
        |> Instructions.parseProgram

    
    let program = 
        (instructions, "hola" |> inputToByteSeq)
            |> MachineState.create
            |> processProgram
    0 // return an integer exit code