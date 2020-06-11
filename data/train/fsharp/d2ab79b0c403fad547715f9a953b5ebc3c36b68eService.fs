namespace TrackerTools
open System.Net

[<AbstractClass>]
type Service() =
    abstract BaseUrl : string
    abstract PrepareRequest : HttpWebRequest -> unit

    member this.CreateRequest relativeUrl =
        let request = WebRequest.Create(this.BaseUrl + relativeUrl) :?> HttpWebRequest
        this.PrepareRequest(request)
        request

    member this.Get (url:string) responseHandler =
        let request = this.CreateRequest url
        use response = request.GetResponse()
        responseHandler(response.GetResponseStream())

    member this.Post (url:string) (requestHandler:#IRequestHandler) (responseHandler:#IResponseHandler) =
        let request = this.CreateRequest url
        request.Method <- "POST"
        requestHandler.HandleRequest(request)
        use response = request.GetResponse()
        responseHandler.HandleResponse(response :?> HttpWebResponse)
