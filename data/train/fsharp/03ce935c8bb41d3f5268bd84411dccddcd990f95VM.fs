module VM
open Redcode

exception AddWarriorException of string
exception InvalidArgumentsException of string

/// A warrior, as read in from a file, consisting of a name and
/// a list of commands.
type Warrior = { Name : string; Code : List<Command> };;

/// A process, consisting of a name and a program counter
type Process = { Name : string ; PID : int ; PC : int };;

/// The state of the Core, consisting of the memory map 
type Core = { Memory : Command[] ; Processes : List<Process> ; RunningPID : int };;

/// Initial instruction on grid is DAT #0 #0
let initialInstr = 
    let loc = { AddrMode = Immediate ; Value = 0 }
    { Instruction = DAT ; Loc1 = loc ; Loc2 = loc }

/// Set up an empty core, with the given memory size
let initialCore m_size = 
    let initial_mem = Array.create m_size initialInstr
    { Memory = initial_mem ; Processes = [] ; RunningPID = 0 }

/// Adds a process to the core
let addProcess core proc = 
    let procs' = core.Processes @ [proc]
    { core with Processes = procs' }

/// Converts a process to a string
let showProcess proc = 
    sprintf "Process %s, PC: %d" proc.Name proc.PC

/// Shows the core state 
let showCore core = 
    let proc_list = 
        List.fold (fun acc proc -> acc + (showProcess proc)) "" core.Processes 
    // Blerg, easier to just do this recursively
    let rec showCoreMem i cmds = 
        match cmds with
        | [] -> ""
        | x :: xs -> let instr_str = showCommand x
                     let procs_at_addr = [ for proc in core.Processes do 
                                            if proc.PC = i then yield proc ]
                     let procs_str = 
                        if procs_at_addr.Length > 0 then 
                            "<- " + List.fold (fun acc b -> acc + showProcess b + "; ") "" procs_at_addr
                        else ""
                     sprintf "%s %s\n" instr_str procs_str + (showCoreMem (i + 1) xs)
    proc_list + "\nCore:\n" + showCoreMem 0 (Array.toList core.Memory)

let printCore core = printfn "%s" (showCore core)

/// Gets the instruction at the given position in the given core, modulo the length
let getInstruction core pc = core.Memory.[pc % core.Memory.Length]

/// Sets instruction at the given position
let setInstruction core pc instr = 
    core.Memory.[pc] <- instr

/// Adds a warrior to the core in a random location
let addWarrior core warrior = 
    let warrior_len = warrior.Code.Length
    let core_len = core.Memory.Length
    // Function to get a loop slice for a circular array
    let loopSlice (arr : 't[]) i_from i_to =
        let slice_len = 
            if i_from < i_to then i_to - i_from
            else (arr.Length - i_from) + i_to
        [ for i in 0..slice_len -> arr.[(i + i_from) % arr.Length] ]
   
    // Grab all the possible indexes in which we may place a warrior.
    // To do this, grab slices of the warrior length for all locations, and
    // test to see whether these slices are empty (that is, eq to initialInstr)
    // If so, add the index to a list, and we can then just pick one randomly
    let poss_start_locs = 
      [ for i in 0..(core.Memory.Length - 1) do 
          let slice = loopSlice core.Memory i ((i + warrior_len) % core_len)
          if List.forall (fun instr -> instr.Equals initialInstr) slice then yield i ]
    if (poss_start_locs.Length = 0) then 
        raise (AddWarriorException "Not enough free space for the warrior")
    // Next, pick one randomly
    let rnd = System.Random()
    let start_loc = poss_start_locs.Item (rnd.Next poss_start_locs.Length)
    // Copy the instructions in
    let rec addInstructions instrs i = 
        match instrs with
            | [] -> () // Done
            | (x :: xs) -> core.Memory.[i % core_len] <- x
                           addInstructions xs (i + 1)
    // VM memory is mutable for efficiency, so this is a side-effecting call
    addInstructions warrior.Code start_loc
    // Finally, register the process
    let new_process = { Name = warrior.Name ; 
                        PID = core.RunningPID ; PC = start_loc }
    { core with Processes = new_process :: core.Processes ; 
                RunningPID = core.RunningPID + 1 }

/// Resolves a reference. That is, given a PC and a location, will return the
/// address referred to by the location, be it direct, indirect or immediate.
let resolveRef core pc loc = 
    let direct_res = (pc + loc.Value) % core.Memory.Length
    match loc.AddrMode with
        | Direct -> direct_res
        | Indirect -> 
            let instr1 = getInstruction core direct_res
            // Indirect addressing then adds the B-field to the given location
            (direct_res + instr1.Loc2.Value) % core.Memory.Length
        | Immediate -> pc // Immediate: current PC


/// Apply a numeric operation.
let applyOperation core op pc = 
    let instr = getInstruction core pc
    // Resolve references for both A and B fields.
    let src_addr = resolveRef core pc instr.Loc1
    let dest_addr = resolveRef core pc instr.Loc2
    let src = getInstruction core src_addr
    let dest = getInstruction core dest_addr

    // Now get the new values by applying the operations.
    // Only update the A field if *both* fields are references (not immediate)
    let new_a_val = 
        if instr.Loc1.AddrMode = Immediate || instr.Loc2.AddrMode = Immediate then 
            dest.Loc1.Value 
        else
            op (src.Loc1.Value) (dest.Loc1.Value)
    let new_b_val = 
        if instr.Loc1.AddrMode = Immediate || instr.Loc2.AddrMode = Immediate then
            op (src.Loc1.Value) (dest.Loc2.Value) // src will = dest in this case, but we use Loc1
        else 
            op (src.Loc2.Value) (dest.Loc2.Value)

    // Make new locations and update the dest instruction
    let new_a_loc = { src.Loc1 with Value = new_a_val }
    let new_b_loc = { src.Loc2 with Value = new_b_val }
    let new_dest = { dest with Loc1 = new_a_loc ; Loc2 = new_b_loc }
    setInstruction core dest_addr new_dest |> ignore

/// Checks to see whether a division would result in /0. 
/// Returns true if yes, false if not.
let divCheck core pc = 
    let instr = getInstruction core pc
    let dest = resolveRef core pc instr.Loc2 |> getInstruction core
    dest.Loc1.Value = 0 || dest.Loc2.Value = 0
    

let killProcess core proc = 
    let rec killProcess' pid procs = 
        match procs with
            | [] -> []
            | x :: xs -> if x.PID = pid then xs 
                                        else x :: killProcess' pid xs
    let new_proc_list = killProcess' proc.PID core.Processes
    { core with Processes = new_proc_list }

/// Updates the process entry for the given process ID.
/// If the process ID is not contained within the VM, then add it.
let updateProcess core pid proc = 
    let rec updateProcess' pid procs = 
        match procs with
            | [] -> [proc]
            | x :: xs -> if x.PID = pid then proc :: xs
                                        else x :: updateProcess' pid xs
    let new_proc_list = updateProcess' pid core.Processes
    { core with Processes = new_proc_list }

let incrementPC core proc = 
    let proc' = { proc with PC = (proc.PC + 1) % core.Memory.Length }
    updateProcess core proc.PID proc'

let doJump core proc instr =
    let new_pc = (proc.PC + instr.Loc1.Value) % core.Memory.Length
    let new_proc = { proc with PC = new_pc }
    updateProcess core proc.PID new_proc


/// Executes a process on the core.
/// If the core tries to execute a DAT instruction or /0, then it is
/// removed from the core altogether.
/// A new core is returned.
let executeProcess core proc =
    let pc = proc.PC
    let instr = core.Memory.[proc.PC]
    match instr.Instruction with
        | DAT -> killProcess core proc // Kill the process
        | MOV -> // Copy from Loc 1 to Loc 2 
            let src = resolveRef core pc instr.Loc1 |> getInstruction core
            let dest_pc = resolveRef core pc instr.Loc2
            setInstruction core dest_pc src
            incrementPC core proc
        | ADD -> applyOperation core (+) pc
                 incrementPC core proc
        | SUB -> applyOperation core (-) pc
                 incrementPC core proc
        | MUL -> applyOperation core (*) pc
                 incrementPC core proc
        | DIV -> if divCheck core pc then let core' = killProcess core proc
                                          incrementPC core' proc
                                     else applyOperation core (/) pc
                                          incrementPC core proc
        | MOD -> if divCheck core pc then let core' = killProcess core proc
                                          incrementPC core' proc
                                     else applyOperation core (%) pc
                                          incrementPC core proc
        | NOP -> incrementPC core proc
        | JMP -> doJump core proc instr
        | _ -> printfn "Warning: instruction %A not supported." instr.Instruction
               incrementPC core proc

/// Execute all processes
let executeStep core =
    List.fold (fun core' proc -> executeProcess core' proc) core core.Processes