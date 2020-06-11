namespace DataSource.Styles

open System
open FSharp.Data

type StyleJson = JsonProvider<"../data/styles.json">

[<AutoOpen>]
type Style(id: int, name: string) =
    member this.Id = id
    member this.Name = name

[<AutoOpen>]
type Styles =
    static member Load(apiKey: string) = 
        let uri = String.Format("https://api.brewerydb.com/v2/styles?key={0}", apiKey)
        let styles= StyleJson.Load(uri)

        query {
                for b in styles.Data do
                select (Style(b.Id, b.Name))
            }
