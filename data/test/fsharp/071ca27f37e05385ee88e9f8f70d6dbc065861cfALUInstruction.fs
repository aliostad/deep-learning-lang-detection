namespace ARM7TDMI
/// ===========================================
/// ALU functions
/// ===========================================
module ALUInstruction = 
    open InstructionType 
    open MachineState
    open EmulatorHelper
    /// update register and set NZ based on new result   
    let private updateRegister state dest op2 s = 
        let newRegMap = Map.add dest op2 state.RegMap
        let newFlags = if s then ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.OTHER(op2)) else state.Flags
        {state with RegMap = newRegMap;Flags = newFlags}
    /// update register and set NZCV based on result with addition
    let private add state dest op1 op2 res s = 
        let newRegMap = Map.add dest res state.RegMap
        let newFlags = if s then ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.ADD(op1,op2,res)) else state.Flags
        {state with RegMap = newRegMap;Flags = newFlags}
    /// update register and set NZCV based on result with subtraction
    let private sub state dest op1 op2 res s = 
        let newRegMap = Map.add dest res state.RegMap
        let newFlags = if s then ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.SUB(op1,op2,res)) else state.Flags
        {state with RegMap = newRegMap;Flags = newFlags}
    /// update register and set NZCV based on result with subtraction
    let private subwc state dest op1 op2 res s = 
        let newRegMap = Map.add dest res state.RegMap
        let newFlags = if s then ProcessFlag.processFlags state (ProcessFlag.ProcessFlagType.SUBWC(op1,op2,res)) else state.Flags
        {state with RegMap = newRegMap;Flags = newFlags}
    /// execute ALU instruction 
    let executeInstruction state instruction s = 
        let er = Extractor.extractRegister state
        match instruction with
        | MOV(r,rol) -> updateRegister state r (er rol) s  // R:=ROL
        | MVN(r, rol) -> updateRegister state r ~~~(er rol) s //R:=NOT(ROL) 
        | AND(r1, r2, rol) -> updateRegister state r1 (state.RegMap.[r2]&&&(er rol)) s // R1:=R2 EOR ROL
        | EOR(r1, r2, rol) -> updateRegister state r1 (state.RegMap.[r2]^^^(er rol)) s // R1:=R2 EOR ROL
        | BIC(r1, r2, rol) -> updateRegister state r1 (state.RegMap.[r2]&&&(~~~(er rol))) s //R1:=R2 AND NOT(ROL)
        | ORR(r1, r2, rol) -> updateRegister state r1 (state.RegMap.[r2]|||(er rol)) s //R1:= R2 OR ROL
        | ADD(r1,r2,rol) -> add state r1 state.RegMap.[r2] (er rol) (state.RegMap.[r2]+(er rol))  s // R1:=R2+ROL
        | ADC(r1,r2,rol) -> add state r1 state.RegMap.[r2] (er rol) (state.RegMap.[r2]+(er rol)+System.Convert.ToInt32(state.Flags.C)) s //R1:=R2+ROl+C
        | SUB(r1,r2,rol) -> sub state r1 state.RegMap.[r2] (er rol) (state.RegMap.[r2]-(er rol)) s // R1:=R2-ROL
        | RSB(r1,r2,rol) -> sub state r1 (er rol) state.RegMap.[r2] ((er rol)-state.RegMap.[r2]) s //R1:=ROL-R2 
        | RSC(r1,r2,rol) -> sub state r1 (er rol) (state.RegMap.[r2]-System.Convert.ToInt32(state.Flags.C)+1) ((er rol)-state.RegMap.[r2]+System.Convert.ToInt32(state.Flags.C)-1) s //R1:=ROL-R2+C-1
        | SBC(r1,r2,rol) -> sub state r1 (state.RegMap.[r2]) ((er rol)-System.Convert.ToInt32(state.Flags.C)+1) (state.RegMap.[r2]-(er rol)+System.Convert.ToInt32(state.Flags.C)-1) s //R1:=R2-ROL+C-1


