namespace PaintShop

open System.Linq
open System.Collections.Generic

module Permutation =

    let permutations n =
            let rotate lst =
                List.tail lst @ [List.head lst] 
            
            let types = [| for i in 0 .. n - 1 -> Gloss |]
            let permutations = List<array<ColourType>> ()
            types |> Array.copy |> permutations.Add
            for i = 0 to Array.length types - 2 do
                types.[i] <- Matte
                let mutable tmp = Array.copy types
                for j = 0 to Array.length types - 1 do
                    tmp <- tmp |> Seq.toList |> rotate |> Seq.toArray
                    tmp |> Array.copy |> permutations.Add
            types.[types.Length - 1] <- Matte
            permutations.Add (types |> Seq.toArray)
            permutations