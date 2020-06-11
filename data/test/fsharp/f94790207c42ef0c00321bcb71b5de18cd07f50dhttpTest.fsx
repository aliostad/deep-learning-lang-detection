open System.Net
open System
open System.IO

let fetchUrl callback url =
    let req = HttpWebRequest.Create(Uri(url))
    ServicePointManager.ServerCertificateValidationCallback <- (fun _ _ _ _ -> true)
    req.Headers.Add("X-Octopus-ApiKey", "API-INIPPSZPDRR63DYXCIRKX0E0ZS")
    use resp = req.GetResponse()
    use stream = resp.GetResponseStream()
    use reader = new IO.StreamReader(stream)
    callback reader url

let myCallback (reader:IO.StreamReader) url =
    let html = reader.ReadToEnd()
    let html1000 = html.Substring(0,1000)
    printfn "Downloaded %s. First 1000 is %s" url html1000
    html      // return all the html

let url = "https://fakeocto.northeurope.cloudapp.azure.com/api/dashboard"
let result = url |> fetchUrl myCallback
