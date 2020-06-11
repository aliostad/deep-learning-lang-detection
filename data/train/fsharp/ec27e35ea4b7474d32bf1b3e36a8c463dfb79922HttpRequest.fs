namespace ODataClient
open System
open System.Net
open System.Net.Http
open System.Web
open System.Text
module HttpRequest= 

  let private toBase64String (str:string)=
   let bytes=Encoding.ASCII.GetBytes(str)
   Convert.ToBase64String(bytes)

  let create httpMethod (url:Uri)= 
     let request=WebRequest.CreateHttp(url)
     request.Method<-httpMethod
     request

  let Get uri=create "GET" uri
  let Post uri =create "POST" uri
  let Put uri=create "PUT" uri
  let Delete uri=create "DELETE" uri

  let build  builders (request:HttpWebRequest)=
      builders|>Seq.fold(fun  r f->f r) request

  let addBasicAuth user password (request:HttpWebRequest)=
   request.Headers.Remove("Authorization")
   request.Headers.Add("Authorization",(user,password)||>sprintf "%s:%s" |>sprintf "Basic %s" ) 
   request

  let acceptXml (request:HttpWebRequest)=
     request.Accept<-"application/atom+xml,application/atomsvc+xml,application/xml"
     request
  
  let acceptJson (request:HttpWebRequest)=
    request.Accept<-"application/json"
    request

   let private fatalErrorHandler (ex:Exception)=
    printfn "Fatal exception occured: '%A'" ex.Message
    None

  let private serverErrorHandler (ex:WebException)=
    printfn "Server status code: %A , error '%A' " (ex.Response:?>HttpWebResponse).StatusCode ex.Message
    None

  let processRequest fatalHandler errorHandler successHandler:HttpWebResponse->'a) (request:HttpWebRequest)=
     try
      let response=request.GetResponse():?>HttpWebResponse
      Some (successHandler response)
     with
      | :? WebException as ex->errorHandler ex
      | :? Exception as ex->fatalHandler ex 
  let processRequestWithDefaultErrorHandlers successHandler request = processRequest fatalErrorHandler serverErrorHandler successHandler request

