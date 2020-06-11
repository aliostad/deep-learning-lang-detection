namespace ARM7TDMI
/// ===========================================
/// Shift functions
/// ===========================================
module SHIFTInstruction =
    open InstructionType 
    open MachineState
    open EmulatorHelper
    /// logical shit left
    let private lshl state dest op1 op2 s =  
        let res = if op2 >= 31 then 0 else (op1 <<< op2) //if op2 >= 31 then all bits shifted
        let newRegMap = Map.add dest res state.RegMap
        let newFlags = if s then ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.LSL(op1,op2,res)) else state.Flags
        {state with RegMap = newRegMap;Flags = newFlags}
        /// logical shift right
    let private lshr state dest op1 op2 s = 
        let res = if op2 >= 31 then 0 else int32((uint32)op1 >>> op2)  //if op2 >= 31 then all bits shifted
        let newRegMap = Map.add dest res state.RegMap
        let newFlags = if s then ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.LSR(op1,op2,res)) else state.Flags
        {state with RegMap = newRegMap;Flags = newFlags}
    /// arithmetic shift right
    let private ashr state dest op1 op2 s = 
        let res = if op2>31 && (op1 < 0) then -1 //if op2 >= 31 and op1 is -ve then all bits replaced with 1
                  elif op2>31 then 0 //if op1 is +ve and op2 >=31 then all bits replaced with 0
                  else op1 >>> op2 
        let newRegMap = Map.add dest res state.RegMap
        let newFlags = if s then ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.ASR(op1,op2,res)) else state.Flags
        {state with RegMap = newRegMap;Flags = newFlags}
    /// rotate right 
    let private ror state dest op1 op2 s = 
        let res =  int32((uint32(op1)>>>op2) ||| (uint32(op1)<<<(32-op2))) //do rotations on logical shifts 
        let newRegMap = Map.add dest res state.RegMap
        let newFlags = if s then ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.ROR(op1,op2,res)) else state.Flags
        {state with RegMap = newRegMap;Flags = newFlags}
    /// rotate right with extend
    let private rrx state dest exp s = 
        let newExp = int32((uint32(exp)>>>1) ||| (uint32(System.Convert.ToInt32(state.Flags.C))<<<(31))) //do rotate by 1 with logical shift
        let newRegMap = Map.add dest newExp state.RegMap
        let newC = if (exp &&& 1) = 1 then true else false
        let newFlags = if s then {ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.OTHER(newExp)) with C = newC} else state.Flags
        {state with RegMap = newRegMap;Flags = newFlags}
    ///execute shift function
    let executeInstruction state instruction s = 
        let er = Extractor.extractRegister state
        let get8lsbit x = (int32((uint8)(x))) //set shift to only the 8 LSB of op2
        match instruction with             
            | LSL(r1,r2,rol) -> lshl state r1 state.RegMap.[r2] (get8lsbit (er rol)) s //logical shift left
            | LSR(r1,r2,rol) -> lshr state r1 state.RegMap.[r2] (get8lsbit (er rol)) s //logical shift right
            | ASR(r1,r2,rol) -> ashr state r1 state.RegMap.[r2] (get8lsbit (er rol)) s //arithmetic shift right
            | ROR(r1,r2,rol) -> ror state r1 state.RegMap.[r2] (get8lsbit (er rol)) s //rotate right
            | RRX(r1,r2) -> rrx state r1 state.RegMap.[r2] s //rotate right and extend
