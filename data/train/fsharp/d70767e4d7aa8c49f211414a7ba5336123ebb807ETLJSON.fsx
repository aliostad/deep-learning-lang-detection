#r "System.Data.dll"
#r "System.Data.Linq.dll"
#r "FSharp.Data.TypeProviders.dll"
#r @"..\packages\FSharp.Data.2.2.5\lib\net40\FSharp.Data.dll"

open FSharp.Data
open Microsoft.FSharp.Data.TypeProviders

type SourceJson = JsonProvider<"https://api.github.com/users/bslatner/repos">
type DestSql = SqlDataConnection<"Data Source=localhost; Initial Catalog=Test; Integrated Security=True;">

let importRepositories() =
    let getDestination (source : SourceJson.Root) =
        let dest = new DestSql.ServiceTypes.Repository()
        dest.Name <- source.Name
        dest.FullName <- source.FullName
        dest.CloneUrl <- source.CloneUrl
        dest

    let sourceDB = SourceJson.Load("https://api.github.com/users/bslatner/repos")
    use destDB = DestSql.GetDataContext()

    let copyToDestination repo =
        destDB.Repository.InsertOnSubmit repo
        printfn "Importing repository %s" repo.Name

    sourceDB
    |> Seq.map getDestination
    |> Seq.iter copyToDestination

    destDB.DataContext.SubmitChanges()

printfn "Starting import"
importRepositories()
printfn "Done"