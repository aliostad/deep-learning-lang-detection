// This is a simple .NET API for CouchDB loosely based on SharpCouch
// http://code.google.com/p/couchbrowse/source/browse/trunk/SharpCouch/SharpCouch.cs
module FSharpCouch
    open System
    open System.Net
    open System.Text
    open System.IO
    open Newtonsoft.Json
    open Newtonsoft.Json.Linq

    let WriteRequest url methodName contentType content =
        let request = WebRequest.Create(string url)
        request.Method <- methodName
        request.ContentType <- contentType 
        let bytes = UTF8Encoding.UTF8.GetBytes(string content)
        use requestStream = request.GetRequestStream()
        requestStream.Write(bytes, 0, bytes.Length) 
        request
    let AsyncReadResponse (request:WebRequest) =
        async { use! response = request.AsyncGetResponse()
                use stream = response.GetResponseStream()
                use reader = new StreamReader(stream)
                let contents = reader.ReadToEnd()
                return contents }
    let ProcessRequest url methodName contentType content =
        match methodName with
        | "POST" -> 
            WriteRequest url methodName contentType content
        | _ -> 
            let req = WebRequest.Create(string url)
            req.Method <- methodName
            req
        |> AsyncReadResponse 
        |> Async.RunSynchronously
    let ToJson content =
        JsonConvert.SerializeObject content
    let FromJson<'a> json =
        JsonConvert.DeserializeObject<'a> json
    let BuildUrl (server:string) (database:string) =
        server + "/" + database.ToLower()
    let CreateDatabase server database =
        ProcessRequest (BuildUrl server database) "PUT" "" ""
    let DeleteDatabase server database =
        ProcessRequest (BuildUrl server database) "DELETE" "" ""
    let CreateDocument server database content = 
        content |> ToJson
        |> ProcessRequest (BuildUrl server database) "POST" "application/json"
    let GetDocument<'a> server database documentId =
        ProcessRequest ((BuildUrl server database) + "/" + documentId) "GET" "" ""
        |> FromJson<'a>
    let GetAllDocuments<'a> server database =
        let jsonObject = ProcessRequest ((BuildUrl server database) + "/_all_docs") "GET" "" ""
                         |> JObject.Parse
        Async.Parallel [for row in jsonObject.["rows"] -> 
                            async {return FromJson<'a>(row.ToString())}]
        |> Async.RunSynchronously
    let DeleteDocument server database documentId revision =         
        ProcessRequest ((BuildUrl server database) + "/" + documentId + "?rev=" + revision) "DELETE" "" ""
