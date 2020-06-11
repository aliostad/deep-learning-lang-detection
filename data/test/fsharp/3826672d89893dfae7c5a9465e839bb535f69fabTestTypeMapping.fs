
namespace TestJson

open System
open System.Collections.Generic
open Newtonsoft.Json

module TestTypeMapping =

    let private testDictionary() =
        // ************************** serialize
        let original = dict [(99,"stasi");(6,"cheka");(88,"KGB")]

        let text = JsonConvert.SerializeObject(original,Formatting.Indented)
        printfn "%s" text

        // ************************** deserialize
        let copy = JsonConvert.DeserializeObject<IDictionary<int,string>>(text)
        copy
        |> Seq.iter (fun kv -> printfn "key=%d,value=%s" kv.Key kv.Value)

    let main() =
        testDictionary()

