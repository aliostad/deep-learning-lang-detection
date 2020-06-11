open FSharp.Data
open FSharp.Data.HttpRequestHeaders
open FSharp.Data.HttpContentTypes
open System.IO
open System.Media

type VisionApi = JsonProvider< @"C:\EdgarProjects\FSharp\DescribePicture\DescribePicture\visionApiResult.json" >
type AuthToken = JsonProvider< @"C:\EdgarProjects\FSharp\VisionApi00\VisionApi00\translateTokenResult.json" >
type TranslationXml = XmlProvider< """<string xmlns="http://schemas.microsoft.com/2003/10/Serialization/">¡Hola mundo!</string>""" >

let getPictureDescription filepath = 
    let bytes = File.ReadAllBytes filepath
    let res = 
        Http.RequestString("https://api.projectoxford.ai/vision/v1.0/analyze?visualFeatures=Description,Tags", 
                           headers = [ "ocp-apim-subscription-key", "PUT-HERE-YOUR-VISION-API-KEY"
                                       ContentType Binary ],
                           body = HttpRequestBody.BinaryUpload bytes)
    let jsonObject = VisionApi.Parse res
    jsonObject.Description.Captions.[0].Text

let getTranslatorToken id secret = 
    let res = 
        Http.RequestString("https://datamarket.accesscontrol.windows.net/v2/OAuth2-13", 
                           body = HttpRequestBody.FormValues [ "client_id", id
                                                               "client_secret", secret
                                                               "scope", "http://api.microsofttranslator.com"
                                                               "grant_type", "client_credentials" ])
    let jsonToken = AuthToken.Parse res
    jsonToken.AccessToken

let translate token text =
    let translatedXml = 
        Http.RequestString("http://api.microsofttranslator.com/v2/Http.svc/Translate", 
                           query = [ "text", text
                                     "from", "en"
                                     "to", "es" ],
                           headers = [ "Authorization", "Bearer " + token ])
    TranslationXml.Parse translatedXml

let speak token text =
    let res = 
        Http.Request("http://api.microsofttranslator.com/V2/Http.svc/Speak", 
                     query = [ "text", text
                               "language", "es" ],
                     headers = [ "Authorization", "Bearer " + token ])
    match res.Body with
    | HttpResponseBody.Text text -> printfn "Algo anda mal"
    | HttpResponseBody.Binary bytes -> 
        use stream = new MemoryStream(bytes)
        use player = new SoundPlayer(stream)
        player.PlaySync()

[<EntryPoint>]
let main argv = 
    if Array.length argv < 1 then
        printfn "You must give a valid file path."
        -1
    else
        let token = getTranslatorToken "PUT-HERE-YOUR-DATAMARKET-APPNAME" "PUT-HERE-YOUR-TRANSLATOR-API-KEY"
        argv.[0] |> getPictureDescription |> translate token |> speak token
        0
