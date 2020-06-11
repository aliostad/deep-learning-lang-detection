namespace Ack_i86

open Address

module TransState =

    type arg =
        | ArgSrc
        | ArgDest
        | ArgTempReg
        | ArgTempMem
        | ArgAddr of addr
        | ArgReg of reg

    type instructionType = | Word | Byte

    type transState = {
         iType: instructionType
         srcAddress: addr
         destAddress: addr
         destValue: addr
         tempReg: reg option
         preProcess: (transState -> string * transState) list;
         midProcess: (transState -> string * transState) list;
         postProcess: (transState -> string * transState) list;
    }


    let extractCodeText state =
        let preCodeList, state' =
            List.fold (fun (codes, s) x -> let (code, s') = x s in code :: codes, s')
                      ([], state)
                      state.preProcess
        let midCodeList, state'' =
            List.fold (fun (codes, s) x -> let (code, s') = x s in code :: codes, s')
                      ([], state')
                      state'.midProcess
        let postCodeList, _ =
            List.fold (fun (codes, s) x -> let (code, s') = x s in code :: codes, s')
                      ([], state'')
                      state''.postProcess
        String.concat ";  " (List.rev (postCodeList @ midCodeList @ preCodeList))


