// DeadCodeElimination.fs

// Module for Dead Code Elimination
module DeadCodeElimination
open System.Collections.Generic
open BlockDefinition
open BlockGenerator
open MFP
open DebugPrinting

// storing the detail of Dead Code Elimination for detail printing purpose
let mutable deadCodeStr:string=""
let mutable fCallcount = 0

/// Live Variables analysis Transfer Function
let LVtransfer (LVcircle:Set<string>) (label:int) (currentBlocks:Dictionary<int,Block>):Set<string> =
    let mutable lvTransfer = Set.empty
    let genLV = currentBlocks.[label].FreeVar
    
    if printKillGenStat then
        printProgramDetails <- printProgramDetails + "\n\n Label " + label.ToString() 
        printProgramDetails <- printProgramDetails + "\n      genLV :: " + (printFull genLV)
    
    if (currentBlocks.[label].KillSet.IsNone) then
        lvTransfer <- LVcircle
        if printKillGenStat then
            printProgramDetails <- printProgramDetails + "\n      KillLV :: []" 
            printKillGenStat <- false
    else
        for var in LVcircle do
            if (not(var = (currentBlocks.[label].KillSet.Value))) then
               lvTransfer <- lvTransfer.Add(var)
        if printKillGenStat then
            printProgramDetails <- printProgramDetails + "\n      KillLV :: " + currentBlocks.[label].KillSet.Value 
            printKillGenStat <- false 
               
    lvTransfer <- lvTransfer + genLV
    lvTransfer    

/// Calculating live variable analysis
let LiveVariables(currentBlocks:Dictionary<int,Block>) 
    = MFP Set.empty (reverseFlow(currentBlocks)) programFinal (Set.empty) LVtransfer currentBlocks

let mutable programCopy = new Dictionary<int,Block>()
let mutable deadCodes = Set.empty

/// Algorithm for Dead Code Elimination
let deadCodeElimination(currentBlocks:Dictionary<int,Block>) =
    
    // make a copy of the program blocks  
    programCopy <- CloneBlocks(currentBlocks)
   
    let recCount = ref 0;
    let rec deadCodeDetection ():Set<int>=
            
        let (LVcircle:Set<(string)>[], LVbullet:Set<(string)>[]) = LiveVariables(programCopy)
       
        let mutable tempDeadCodes = Set.empty
        let forCount = ref 0;
        deadCodeStr <- " "
        deadCodeStr <- deadCodeStr + "\n Dead Codes at :: "
        tempDeadCodes <- Set [for label in programCopy.Keys do
                               // label not in deadcode already and there is any kill
                               incr forCount
                               deadCodeStr <- deadCodeStr + "\n    Iteration " + (!forCount).ToString() + ":: " + "current label "+ label.ToString() + ": "
                               if (not(deadCodes.Contains(label)) && (programCopy.[label].KillSet.IsSome)) then
                                   let var = programCopy.[label].KillSet.Value
                                   if not(LVcircle.[label-1].Contains(var)) then
                                           deadCodeStr <- deadCodeStr + label.ToString()
                                           yield label]
        
        deadCodes <- deadCodes + tempDeadCodes
        incr recCount 
        printProgramDetails <- printProgramDetails + "\n" + deadCodeStr + "\nToal DeadCodes at recursive iteration "+ (!recCount).ToString()
                        + ":: " + (printFull deadCodes)
        if not(tempDeadCodes.IsEmpty) then    
            //replace all dead blocks with skip
            for l in tempDeadCodes do
                let skipBlock = new Skip(programCopy.[l].EntrySet,programCopy.[l].Guard, programCopy.[l].ScopeNumber)
                skipBlock.ExitSet <- programCopy.[l].ExitSet
                programCopy.[l] <- skipBlock
            // run dead code detection on the updated blocks
            deadCodeDetection() |> ignore
        if printDetail then
            printfn ">>\n" 
            printBlocks(currentBlocks)
            printfn "\n\n%A" circle_bullet            
            printfn "\n\n DeadCode Elimination Details :::::>> \n\n %A" printProgramDetails
            deadCodeStr<-" "
            circle_bullet<-" "
            printDetail <- false
        deadCodes
    deadCodeDetection()