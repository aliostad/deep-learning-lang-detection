// Program.fs

module Main
open System
open BlockDefinition
open BlockGenerator
open DebugPrinting
open ProgramSlice
open DeadCodeElimination
open ConstantFolding
open MFP

// to tokenize the user's command line input

let tokenize (value:System.String) = 
    if (value.Contains "detail") then
        printDetail <- true
    else
        printDetail <- false
    
    let mutable args = value.Split([|' '|])
    if value.Contains("\"") then
       let mutable progStr = value.Replace("\"","") 
       progStr <- progStr.Substring(args.[1].Length+1)
       args.[1] <- progStr
    if(args.Length>1) then
        args.[1]
    else
        args.[0]

// the main program
let Program()=
    printfn "****** Welcome to Program Analysis ******** \n\n"
    printfn "Commands : \n\n1. Parse File : parsefile FilePath
                      \n2. Parse string : parsestr \"string\"  
                      \n3. Program Slicing : PS pointofInterest [detail]
                      \n4. Dead Code Elimination: DC [detail] 
                      \n5. Constant Folding: CF [detail]
                      \n6. Help : help
                      \n7. Exit : exit
                      \n   []:: optional argument \n "

    let rec ProcessCommand() =
        printfn "\n****************************\n"
        let mutable command = Console.ReadLine()
        match command with
        | _ when command.StartsWith("PARSEFILE",true,null) // to parse file
          -> clearDataHandlers()
             let filepath = tokenize(command)
             let program = parseFromFile filepath
             let programCmd = generateProgramBlocks program
             ProcessCommand()

        | _ when command.StartsWith("PARSESTR",true,null) // to parse program given as input
          -> clearDataHandlers()
             let programString = tokenize(command)
             let program = parseFormString programString
             let programCmd = generateProgramBlocks program
             ProcessCommand()

        | _ when command.StartsWith("PS",true,null) // Program Slice
          -> let poi = Int32.Parse(tokenize(command))
             let sliceProgram = programSlice(blocks)(poi)
             printDetail <- false 
             ProcessCommand()

        | _ when command.StartsWith("DC",true,null) // Dead Code
          -> let deatail = tokenize(command)
             let deadCodeEliminate = deadCodeElimination(blocks)
             printfn "Final Dead Codes %A" (printFull deadCodeEliminate)
             printProgramDetails <- ""
             printDetail <- false 
             ProcessCommand()

        | _ when command.StartsWith("CF",true,null) // Constant Folding
          -> let detail = tokenize(command)
             let constantFold = constantFolding(blocks)
             if printDetail then
                printfn "\n\n Constant Propagation Deatails :::::>> \n\n %A" printProgramDetails
                printProgramDetails <- " "
             printfn "\n\n Folded Program \n"
             for i in constantFold.Keys do
                 printfn "\n%A" (blockToString (constantFold) (i))
             printDetail <- false 
             ProcessCommand()

        | _ when command.StartsWith("HELP",true,null) // the help command
          -> printfn "Commands : \n\n1. Parse File : parse FilePath
                      \n2. Parse string : parse string  
                      \n3. Program Slicing : PS pointofInterest [detail]
                      \n4. Dead Code Elimination: DC [detail] 
                      \n5. Constant Folding: CF [detail]
                      \n6. Help : help
                      \n7. Exit : exit
                      \n   []:: optional argument \n "
             ProcessCommand()

        | _ when command.StartsWith("EXIT",true,null) // exits the program
          -> printfn "Program terminates..."
             ()
        | _ 
          -> printfn "Sorry Invalid Command" // in case of invalid command
             ProcessCommand()
    ProcessCommand()
Program()    