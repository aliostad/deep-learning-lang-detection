module ConcurrentWordCount

open System
open System.IO
open System.Collections.Generic
open System.Collections.Concurrent

// Simple version (not the best way to count words in practice):
let WordCount dirPath wildCard =

   let wordCounts = Dictionary<string, int>()

   let ProcessFile fileName =
      let text = File.ReadAllText(fileName)

      // Would need more robust word-splitting in practice:
      text.Split([|'.'; ' '; '\r'|], StringSplitOptions.RemoveEmptyEntries)
      |> Array.map (fun w -> w.Trim())
      |> Array.filter (fun w -> w.Length > 2)
      |> Array.iter (fun w -> 
         let ok, count = wordCounts.TryGetValue(w)
         if ok then
            wordCounts.[w] <- count+1
         else
            wordCounts.[w] <- 1)

   Directory.EnumerateFiles(dirPath, wildCard)
   |> Seq.iter ProcessFile

   wordCounts
   |> Seq.sortBy (fun kv -> -kv.Value)
   // |> Seq.sumBy (fun kv -> kv.Value)

// Naive concurrent version (produces exceptions and
// inconsistent results):
let WordCount2 dirPath wildCard =

   let wordCounts = Dictionary<string, int>()

   let ProcessFile fileName =
      let text = File.ReadAllText(fileName)

      // Would need more robust word-splitting in practice:
      text.Split([|'.'; ' '; '\r'|], StringSplitOptions.RemoveEmptyEntries)
      |> Array.map (fun w -> w.Trim())
      |> Array.filter (fun w -> w.Length > 2)
      |> Array.iter (fun w -> 
         let ok, count = wordCounts.TryGetValue(w)
         if ok then
            wordCounts.[w] <- count+1
         else
            wordCounts.[w] <- 1)

   Directory.EnumerateFiles(dirPath, wildCard)
   |> Array.ofSeq
   |> Array.Parallel.iter ProcessFile

   wordCounts   
   |> Seq.sortBy (fun kv -> -kv.Value)
   // |> Seq.sumBy (fun kv -> kv.Value)

// Safe concurrent version:
let WordCount3 dirPath wildCard =

   let wordCounts = ConcurrentDictionary<string, int>()

   let ProcessFile fileName =
      let text = File.ReadAllText(fileName)

      // Would need more robust word-splitting in practice:
      text.Split([|'.'; ' '; '\r'|], StringSplitOptions.RemoveEmptyEntries)
      |> Array.map (fun w -> w.Trim())
      |> Array.filter (fun w -> w.Length > 2)
      |> Array.iter (fun w -> wordCounts.AddOrUpdate(w, 1, (fun _ count -> count+1 )) |> ignore)

   Directory.EnumerateFiles(dirPath, wildCard)
   |> Array.ofSeq
   |> Array.Parallel.iter ProcessFile

   wordCounts 
   |> Seq.sortBy (fun kv -> -kv.Value)
   // |> Seq.sumBy (fun kv -> kv.Value)
