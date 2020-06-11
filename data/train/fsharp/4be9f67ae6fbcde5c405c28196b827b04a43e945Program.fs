open Mario.HttpContext
open Mario.WebServer
open System.Web.Script.Serialization

let json t =
    let js = new JavaScriptSerializer()    
    js.Serialize(t)


let session_add_test sid= 
    Mario.Session.add sid "test_key" "test_value"
    "added"

let session_get_test sid = 
    Mario.Session.get sid "test_key" |> json



let myHandler (req:HttpRequest) : HttpResponse =
    match req.Method, req.Uri with
       | HttpMethod.GET, "/session_add.fs" -> { Json = session_add_test req.SessionId }
       | HttpMethod.GET, "/session_get.fs" -> { Json = session_get_test req.SessionId }
       | HttpMethod.POST, _ -> { Json = req.Body }
       | _ -> Mario.HttpUtility.badRequest

Mario.Start(myHandler, 80)