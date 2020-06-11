//open System.Data
//open System
//open System.Linq
//
//#r @"C:\projects\projectteddy\ProjectTeddySolution\ProjectTeddy.FSCore\bin\Debug\ProjectTeddy.FSCore.dll"
//#r @"C:\projects\projectteddy\ProjectTeddySolution\ProjectTeddy.HadoopHandler\bin\Debug\ProjectTeddy.HadoopHandler.dll"
//#r @"C:\projects\projectteddy\ProjectTeddySolution\ProjectTeddy.Core\bin\Debug\ProjectTeddy.Core.dll"
//open ProjectTeddy.HadoopHandler
//open ProjectTeddy.FSCore
//open ProjectTeddy.Core.EntityFramework
//
//let hReader = new HiveReader()
//let stuff = hReader.ReadAllWordRelationships()
//let first = stuff |> Seq.filter(fun r -> if(r.rScore > 0.0) then true else false) |> Seq.sortBy(fun r -> r.rScore) |> Seq.head



let s = "abc"
let b = "abc"

if s = b
then printfn "%s" "Match"
else printfn "%s" "No Match"