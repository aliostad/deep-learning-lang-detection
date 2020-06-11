namespace ReturnControl
open Main
module AST =
    let getTokenList (tokenList,_,_) = tokenList
    let getInputArgs (_,inputArgs,_) = inputArgs
    let getOutputConsts (_,_,outputConsts) = outputConsts

    let ReturnWrapper getInputInfoFrom getOutputFuncFrom func data =
        let runFunc unwrappedData =
            let completedInputInfo = getInputInfoFrom unwrappedData
            let tokenList = getTokenList completedInputInfo
            let inputArgs = getInputArgs completedInputInfo
            let outputProcesses = getOutputFuncFrom (getOutputConsts completedInputInfo)
            let processFuncOutputs = fst outputProcesses
            func inputArgs tokenList
            |> UnwrapResultThrough processFuncOutputs
        data
        |> UnwrapResultInto runFunc

    let OptionalReturnWrapper getInputInfoFrom getOutputFuncFrom (|MatchFunc|_|) data =
        let processReturn unwrappedData =
            let completedInputInfo = getInputInfoFrom unwrappedData
            let tokenList = getTokenList completedInputInfo
            let inputArgs = getInputArgs completedInputInfo
            let outputProcesses = getOutputFuncFrom (getOutputConsts completedInputInfo)
            let processFuncOutputs = fst outputProcesses
            let ignoreFuncOutput = snd outputProcesses
            match tokenList with
            | MatchFunc inputArgs matchedResult ->
                matchedResult
                |> UnwrapResultThrough processFuncOutputs
            | _ -> Result(ignoreFuncOutput)
        data
        |> UnwrapResultInto processReturn