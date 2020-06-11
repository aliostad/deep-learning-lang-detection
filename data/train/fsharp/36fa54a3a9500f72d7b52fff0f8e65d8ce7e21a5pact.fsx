#r "../packages/FAKE/tools/FakeLib.dll" // include Fake lib
#r "System.Runtime.Serialization"

open Fake
open System.Runtime.Serialization
open System.Runtime.Serialization.Json
open System
open System.IO
open System.Text
open System.Web
open System.Net
open System.IO

let pactBroker = "http://10.100.144.179"

[<DataContract>]
type Provider = {
        [<field: DataMember(Name = "name")>]
        name:string
    }

[<DataContract>]
type Consumer = {
        [<field: DataMember(Name = "name")>]
        name:string
    }

[<DataContract>]
type Pact = {
        [<field: DataMember(Name = "consumer")>]
        consumer:Consumer
        [<field: DataMember(Name = "provider")>]
        provider:Provider
    }

let private deserialisePact (s:string) =
    let json = new DataContractJsonSerializer(typeof<Pact>)
    let byteArray = Encoding.UTF8.GetBytes(s)
    let stream = new MemoryStream(byteArray)
    json.ReadObject(stream) :?> Pact

let private pactVersionFromVersion (version:string[]) =
    version.[1..4] |> String.concat "."

let private changeCharsToDash text (chars:string) =
    Array.fold (
        fun (s:string) c -> s.Replace(c.ToString(),"-")
    ) text (chars.ToCharArray())

let PublishPact (version:string[], branchName:string) pactfiles =
    let pactVersionText = pactVersionFromVersion version
    let pactBranchTag = changeCharsToDash branchName "/"

    pactfiles |>
        Seq.iter(fun file ->
            let pactContent = File.ReadAllText(file)
            let pact = deserialisePact(pactContent)
            let url = sprintf "%s/pacts/provider/%s/consumer/%s/version/%s" pactBroker (Uri.EscapeDataString pact.provider.name) (Uri.EscapeDataString pact.consumer.name) pactVersionText
            let tagUrl = sprintf "%s/pacticipants/%s/versions/%s/tags/%s" pactBroker (Uri.EscapeDataString pact.consumer.name) pactVersionText (Uri.EscapeDataString pactBranchTag)

            trace (sprintf "##teamcity[message text='Publishing PACT %s <==> %s version %s with tag %s']" pact.provider.name pact.consumer.name pactVersionText pactBranchTag)

            let request = WebRequest.Create url
            request.ContentType <- "application/json"
            request.Method <- "PUT"

            let bytes = Encoding.UTF8.GetBytes pactContent
            request.ContentLength <- int64 bytes.Length
            use requestStream = request.GetRequestStream()
            requestStream.Write(bytes, 0, bytes.Length)

            try
                use response = request.GetResponse() :?> HttpWebResponse
                trace ("Uploaded pact: " + url)
            with
                | a -> traceError ("Error uploading pact file " + url); reraise()


            let tagRequest = WebRequest.Create tagUrl :?> HttpWebRequest
            tagRequest.ContentType <- "application/json"
            tagRequest.Accept <- "application/hal+json"
            tagRequest.Method <- "PUT"

            try
                use response = tagRequest.GetResponse() :?> HttpWebResponse
                trace ("Tagged pact: " + tagUrl)
            with
                | a -> traceError ("Error tagging pact file " + tagUrl); reraise()

            0 |> ignore
        )

    0 |> ignore
