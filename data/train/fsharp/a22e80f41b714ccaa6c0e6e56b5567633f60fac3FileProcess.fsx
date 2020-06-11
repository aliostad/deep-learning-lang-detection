#light

module Objectville.FSharp.Sample.FileProcessing

open System
open System.IO

// parse data line
let convertDataRow (csvLine : string) = 
    let cells = List.ofSeq(csvLine.Split(','))
    match cells with
        | title::number::_ -> 
          let parseNumber = Int32.Parse(number)
          (title, parseNumber)
        |_ -> failwith "Incorrect data format!"

// parse data lines recursively
let rec processDataLines (lines) = 
    match lines with
    | [] -> []
    | headerLine :: reminingLines ->
        let headerCells = convertDataRow(headerLine)
        let reminingCells = processDataLines(reminingLines)
        headerCells :: reminingCells // return tuple list

//----------------------------------------------
// 1. read the data file
// 2. process the data file by mapping the data to record or object
// 3. calculate premium
// 4. read the data from bottom up
// 5. query data file by identifier
// 6. group the data line by identifier
// 7. read multiple files (read from a directory)
// 8. Compare the data line by identifer

open System.IO


type reinsuranceRecord = 
     {
       Policy_ClientPolicyNumber: string;
       Policy_IssueDate: string;
       Coverage_CoverageNumber: string;
       Coverage_Duration : string;
       Coverage_LifeType : string;
       Coverage_ApplicationType : string
     }
     member x.Identifier = 
          x.Policy_ClientPolicyNumber + x.Coverage_CoverageNumber

let processDataLine (line: string) = 
     {
         Policy_ClientPolicyNumber = line.Substring(4, 9).Trim(); 
         Policy_IssueDate = line.Substring(69, 8).Trim();
         Coverage_CoverageNumber = line.Substring(14,4).Trim();
         Coverage_Duration = line.Substring(55, 2).Trim();
         Coverage_LifeType = line.Substring(89, 1).Trim();
         Coverage_ApplicationType = line.Substring(95, 1).Trim()
     }
      

let readFile filePath = 
          File.ReadLines(filePath)
          |> Seq.skip 1
          |> Seq.take 1
          |> Seq.iter (fun line -> 
                          let reinsurance = processDataLine line
                          printfn "Coverage Identifier: %s" (reinsurance.Identifier);
                      )           
           
readFile @"F:\deployment\aurigen\DataProcess\dev\temp\SUN-20081130-load.txt";;    
