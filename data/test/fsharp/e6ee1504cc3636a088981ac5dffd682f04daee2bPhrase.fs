namespace BucklingSprings.Aware.Core.Classifiers

open BucklingSprings.Aware.Core.Models

module Phrase =
    
     let extractWords (w : ActivityWindowDetail) = 
        let wordsFrom (s : string) = 
            let cs = s.ToCharArray()
            let newCs = cs
                           |> Array.map (fun c -> if System.Char.IsPunctuation c then ' ' else System.Char.ToLower c)
            let s1 = System.String(newCs)
            s1.Split()
                |> Set.ofArray
                |> List.ofSeq
        List.concat [wordsFrom w.windowText; wordsFrom w.processInformation.processName]



