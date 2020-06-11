namespace TwitterApi

open System.Net
open System.IO
open System.Xml
open System.Text

type Api( oauth:OAuthHandler ) =

    let TwitterApiUrl = "http://api.twitter.com/1/"

    member this.PublicTimeLine() =
        let path = "statuses/public_timeline.xml"
        let req = WebRequest.Create( TwitterApiUrl + path )
        let res = req.GetResponse()
        use st = res.GetResponseStream()
        use sr = new StreamReader( st )

        let xmlDoc = XmlDocument()
        xmlDoc.LoadXml( sr.ReadToEnd() )
    
        xmlDoc.SelectNodes( "/statuses/status" );

    member this.HomeTimeLine() =
        let path = "statuses/home_timeline.xml"
        let url = TwitterApiUrl + path

        let result = oauth.GetRequest url
        result.SelectNodes( "/statuses/status" )

    member this.UpdateStatus text =
        let path = "statuses/update.xml"
        let url = TwitterApiUrl + path

        let status = [("status", text)]

        let result = oauth.PostRequest url status
        ()