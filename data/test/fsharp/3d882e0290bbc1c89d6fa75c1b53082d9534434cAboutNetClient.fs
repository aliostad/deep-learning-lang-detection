module AboutNetClient
    open System
    open System.Net
    open Newtonsoft.Json

    type Client(apiKey : string) =
        member this.ApiKey = apiKey

        member this.View(username : string) =
            username
            
        member internal this.AsyncGetResult(uri : string) =
            async {                             
                let req = WebRequest.CreateHttp(uri) 
                use! resp = req.AsyncGetResponse()  
                use stream = resp.GetResponseStream() 
                use reader = new IO.StreamReader(stream) 
                let html = reader.ReadToEnd()
                
                return html
            }
        member internal this.GetResult(uri : string) =
            Async.RunSynchronously(this.AsyncGetResult(uri))

        member this.AsyncGetData<'T>(uri : string) =
            Async.StartAsTask(async {
                let! result =  this.AsyncGetResult(uri)
                return JsonConvert.DeserializeObject<'T>(result)
            })
