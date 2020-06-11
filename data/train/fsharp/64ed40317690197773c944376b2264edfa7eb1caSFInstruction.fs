namespace ARM7TDMI

/// ===========================================
/// Set flag functions
/// ===========================================
module SFInstruction =         
    open InstructionType 
    open MachineState
    open EmulatorHelper
    /// execute set flag instruction
    let executeInstruction state instruction = 
        let er = Extractor.extractRegister state
        let newFlags = 
            match instruction with
            | TST(r,rol) -> ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.OTHER(state.RegMap.[r]&&&(er rol)))  //R AND ROL
            | TEQ(r, rol) -> ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.OTHER(state.RegMap.[r]^^^(er rol))) // R EOR ROL
            | CMP(r,rol) -> ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.SUB(state.RegMap.[r],(er rol),state.RegMap.[r]-(er rol))) // R-ROL
            | CMN(r, rol) -> ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.ADD(state.RegMap.[r],(er rol),state.RegMap.[r]+(er rol))) // R+ROL
        {state with Flags = newFlags}


