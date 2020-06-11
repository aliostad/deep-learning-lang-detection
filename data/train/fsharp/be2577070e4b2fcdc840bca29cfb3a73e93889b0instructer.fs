//Decode/depatch
namespace VisualMIPS

module Executor =
    open Types
    open Instructions
    open MachineState
    open Rtypes
    open Itypes
    open Jtypes

    //Note : 
    // uint32 sign extends if it converts a int8/16, does not sign extend with uints
    // difference between uint32 and int32 is how the systems interprets the MSB if it is a 1 in a comparison for eg

    // R execution
    let processSimpleR (instr: Instruction) (mach : MachineState) =
        let rs = T.getValue(getReg instr.rs mach)
        let rt = T.getValue(getReg instr.rt mach)
        let tmp = 
             match instr.opcode with
             | ADDU -> rs + rt
             | AND -> rs &&& rt
             | OR -> rs ||| rt
             | NOR -> ~~~ (rs ||| rt)
             | SRAV -> uint32(int32 rt >>> int32 rs)
             | SRLV -> rt >>> int32 rs
             | SLLV -> rt <<< int32 rs
             | SUBU -> rs - rt
             | XOR -> rs ^^^ rt
             | SLT -> 
                match int32(rs) < int32(rt) with
                | true -> 1u 
                | false -> 0u
             | SLTU ->
                match rs < rt with
                | true -> 1u
                | false -> 0u
             | MFHI -> T.getValue(getHi mach)
             | MFLO -> T.getValue(getLo mach)
             | _ -> failwith "opcode does not belong to processSimpleR functions"
        let output = Word(tmp)
        setReg instr.rd output mach
    
    let processShiftR (instr : Instruction) (mach : MachineState) =
        let rt = T.getValue(getReg instr.rt mach)
        let shiftval = int32 (T.getValue(instr.shift))
        let tmp = 
            match instr.opcode with 
            | SRA -> uint32 (int32 rt >>> shiftval)
            | SRL -> rt >>> shiftval
            | SLL -> rt <<< shiftval
            | _ -> failwith "opcode does not belong to processShiftR functions"
        let output = Word(tmp)
        setReg instr.rd output mach
        

    let processFullR (instr: Instruction) (mach : MachineState) =
        let localMap1 = Map[(ADD,opADD);(SUB,opSUB);(JALR,opJALR)] //can change rd
        let localMap2 = Map[(DIV,opDIV);(DIVU,opDIVU);(MULT,opMULT);(MULTU,opMULTU);
                            (JR,opJR);(MTHI,opMTHI);(MTLO,opMTLO)] //no need to change rd
        let rs = getReg instr.rs mach
        let rt = getReg instr.rt mach
        let returnMach =
            match (Map.containsKey instr.opcode localMap1) with
            | true ->
                let fn1 = Map.find instr.opcode localMap1
                let (output,newMach) = fn1 mach instr rs rt
                let newMach1 = setReg instr.rd output newMach 
                newMach1
            | false ->
                let fn2 = Map.find instr.opcode localMap2
                let newMach2 = fn2 mach instr rs rt
                newMach2 
        returnMach 


    // I execution

    let processSimpleI (instr: Instruction) (mach : MachineState) =
        let rs = T.getValue(getReg instr.rs mach)
        let rt = T.getValue(getReg instr.rt mach)
        let immediateUnsigned = uint32(T.getValue instr.immed) //pads with 16-bit of zeros
        let immediateSigned = int32( int16( T.getValue instr.immed))
        let tmp = 
             match instr.opcode with
             | ADDIU -> rs + uint32(immediateSigned) 
             | ANDI -> rs &&& immediateUnsigned
             | ORI -> rs ||| immediateUnsigned
             | XORI -> rs ^^^ immediateUnsigned
             | LUI -> immediateUnsigned <<< 16
             | SLTI ->
                match int32(rs) < immediateSigned with
                | true -> 1u 
                | false -> 0u
             | SLTIU ->
                match rs < uint32(immediateSigned) with
                | true -> 1u
                | false -> 0u
             | _ -> failwith "opcode does not belong to processSimpleI functions"
        let output = Word(tmp)
        let newMach = setReg instr.rt output mach
        newMach

    let processBranchI (instr: Instruction) (mach : MachineState) =
        let immed = (T.getValue instr.immed)
        let rs = T.getValue( getReg instr.rs mach )
        let rt = T.getValue( getReg instr.rt mach )//Only used in a couple.
        let (branch, link) = match instr.opcode with
                                | BGEZ when rs >= 0u -> (true,false)
                                | BGEZAL when rs >= 0u -> (true,true)
                                | BEQ when rs = rt -> (true,false)
                                | BNE when rs <> rt -> (true,false)
                                | BLEZ when rs <= 0u -> (true, false)
                                | BLTZ when rs < 0u -> (true, false)
                                | BLTZAL when rs < 0u -> (true, true)
                                | BGTZ when rs >= 0u -> (true, false)
                                //FIXME: Do the link commands always link? Spec seems to suggest that.
                                | _ -> (false, false)
        let newMach = setNextNextPC (Word ((getNextPC mach |> T.getValue) + 4u*(uint32 immed))) mach//need to sign extend when converting to uint32
        newMach

    let processFullI (instr: Instruction) (mach : MachineState) =
        let localMap = Map[(ADDI,opADDI)]
        let rs = getReg instr.rs mach
        let immediate = instr.immed
        let fn = Map.find instr.opcode localMap
        let (output,newMach) = fn mach instr rs immediate
        let returnMach = setReg instr.rt output newMach
        returnMach

    let processMemI (instr: Instruction) (mach : MachineState) =
        let localMap = Map[(LB,opLB);(LBU,opLBU);(LH,opLH);(LHU,opLHU);(LW,opLW);
                            (LWL,opLWL);(LWR,opLWR);(SB,opSB);(SH,opSH);(SW,opSW)]
        let rt = getReg instr.rt mach
        let myBase = getReg instr.rs mach // 'base' used by F# for name of base class object
        let offset = instr.immed
        let fn = Map.find instr.opcode localMap
        let newMach = fn mach instr rt myBase offset
        newMach
    
    
    // J execution

    let processFullJ (instr: Instruction) (mach : MachineState) =
        let localMap = Map[(J,opJ);(JAL,opJAL)]
        let target = instr.target
        let fn = Map.find instr.opcode localMap
        let newMach = fn mach target
        newMach


    // --------------- //

    // Dispatch execution

    let opTypeMap = Map [
                        ([ADDU; AND; NOR; OR; SRAV; SRLV; SLLV; SUBU; XOR; SLT; SLTU; MFHI; MFLO], processSimpleR);
                        ([SRA; SRL; SLL], processShiftR);
                        ([ADD; SUB; JALR; DIV; DIVU; MULT; MULTU; JR; MTHI; MTLO], processFullR);
                        ([ADDIU; ANDI; ORI; XORI; LUI; SLTI; SLTIU],processSimpleI);
                        ([BGEZ; BGEZAL; BEQ; BNE; BLEZ; BLTZ; BLTZAL; BGTZ], processBranchI);
                        ([ADDI], processFullI);
                        ([LB; LBU; LH; LHU; LW; LWL; LWR; SB; SH; SW], processMemI);
                        ([J;JAL], processFullJ);
                        ]

    let executeInstruction (instr : Instruction) (mach : MachineState) =
        let key = Map.findKey (fun x _ -> List.contains instr.opcode x) opTypeMap //Could be slightly simpler with a map.findWith style
        let fn = Map.find key opTypeMap
        mach |> fn instr |> advancePC
