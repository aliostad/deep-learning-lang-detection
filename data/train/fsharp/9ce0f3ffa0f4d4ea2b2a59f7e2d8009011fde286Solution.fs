namespace MDKnapsack

open System
open System.Text
open System.Collections
open MDKnapsack.Util

[<Class>]
[<Sealed>]
type Solution(itemsTaken : BitArray, prob : KnapsackProblem, openBits : int) = 
    static let mutable count = 0
    let price = 
        let mutable sum = 0
        for i = 0 to openBits - 1 do
            if itemsTaken.[i] then sum <- sum + prob.Items.[i].Price
        sum
    member x.ItemsTaken = itemsTaken
    member x.Prob = prob
    member x.OpenBits = openBits
    member x.Price = price
    static member Empty (p : KnapsackProblem) = (new BitArray(p.Items.Length, false), p, 0) |> Solution
    
    member x.IsValid =
            let items = prob.Items
            let knapsacks = prob.Knapsacks
            knapsacks |> Array.forall (fun knapsack -> 
                            let mutable sumOfConstraints = 0
                            for i = 0 to items.Length - 1 do
                                if itemsTaken.[i] then 
                                    sumOfConstraints <- sumOfConstraints + items.[i].ConstraintOf knapsack
                            sumOfConstraints < knapsack.Capacity)

    member x.ShouldPrune (bestPrice : int, upperBoundFunc : Solution -> int) : bool =
        upperBoundFunc x < bestPrice

    member x.Branch =
        if count % 2048 = 0 then
            respond()
        count <- count + 1
        let newCopy = itemsTaken.Clone () :?> BitArray
        if (itemsTaken.[openBits]) then
            newCopy.[openBits] <- false
            (Solution (itemsTaken, prob, openBits + 1), Solution (newCopy, prob, openBits + 1))
        else
            newCopy.[openBits] <- true
            (Solution (newCopy, prob, openBits + 1), Solution (itemsTaken, prob, openBits + 1))

    override x.ToString() = 
        let strBuilder = new StringBuilder()
        strBuilder.AppendLine("Price: " + x.Price.ToString()) |> ignore
        seq { 0..itemsTaken.Length - 1 }
        |> Seq.map (fun i -> (i, itemsTaken.[i]))
        |> Seq.sortByDescending snd
        |> Seq.map (fun (i, isTaken) -> 
               match isTaken with
               | true -> "\tTaken: " + prob.Items.[i].ToString().FillLinesWithTabs()
               | false -> "\tNot Taken: " + prob.Items.[i].ToString())
        |> Seq.map (strBuilder.AppendLine)
        |> Seq.iter ignore
        strBuilder.ToString()
        