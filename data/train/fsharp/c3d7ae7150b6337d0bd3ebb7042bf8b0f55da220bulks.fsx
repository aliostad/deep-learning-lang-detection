#r @"./FSharp.Data.2.3.2/lib/net40/FSharp.Data.dll"
#r @"./Newtonsoft.Json.6.0.5/lib/net40/Newtonsoft.Json.dll"

open FSharp.Data
open System.IO

type Suggestion = {input: string[]; output: string}
type Word = {name: string; link: string; suggest: Suggestion}

type Words = JsonProvider<"./data/file-1.json">

for i in 0..1440 do
    printfn "%d" i
    let words = Words.Load (sprintf "./data/file-%d.json" i)

    let processName (word:Words.Root) =
        let name = (word.Name.TrimStart().Split(' ').[0]) in
        { name = name;
          link = word.Link.Split('=').[1];
          suggest = {
                     input = [|name|];
                     output = name;
                     }
          }

    let format word = """{"index":{}}"""  + "\n" + Newtonsoft.Json.JsonConvert.SerializeObject word + "\n"

    let toInsert = Array.map (processName >> format) words

    use w = new System.IO.StreamWriter(sprintf "./bulks/bulk-%d.txt" i)
    w.Write (String.concat "" (Array.toSeq toInsert))
    w.Flush()
    w.Close()

// System.Diagnostics.Process.Start("/usr/bin/curl", "localhost:9200 -").StandardOutput