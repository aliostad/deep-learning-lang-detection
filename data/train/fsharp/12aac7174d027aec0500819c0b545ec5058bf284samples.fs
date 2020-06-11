#light
open System
open System.IO
open System.Net
open System.Windows.Forms
open System.Xml

let getWebService (url : string) (methodName : string) (requestBody : string) =
    let webRequest =
        WebRequest.Create(url, Method = "POST", ContentType = "text/xml")
    webRequest.Headers.Add("Web-Method", methodName)
    using (new StreamWriter(webRequest.GetRequestStream()))
        (fun s -> s.Write(requestBody))
    let webResponse = webRequest.GetResponse()
    let stream = webResponse.GetResponseStream()
    let xml = new XmlDocument()
    xml.Load(new XmlTextReader(stream))
    xml
        
let (requestTemplate : Printf.StringFormat<_>) =
    @"<soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/""
xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""
xmlns:xsd=""http://www.w3.org/2001/XMLSchema"">
<soap:Body>
<getContentRequest xmlns=""urn:msdn-com:public-content-syndication"">
<contentIdentifier>%s</contentIdentifier>
<locale xmlns=""urn:mtpg-com:mtps/2004/1/key"">en-us</locale>
<version xmlns=""urn:mtpg-com:mtps/2004/1/key"">VS.80</version>
<requestedDocuments>
<requestedDocument type=""common"" selector=""Mtps.Search"" />
<requestedDocument type=""primary"" selector=""Mtps.Xhtml"" />
</requestedDocuments>
</getContentRequest>
</soap:Body>
</soap:Envelope>"

let url = "http://services.msdn.microsoft.com" +
            "/ContentServices/ContentService.asmx"
let xpath = "/soap:Envelope/soap:Body/c:getContentResponse/" +
                "mtps:primaryDocuments/p:primary"
                
let queryMsdn item =
    let request = Printf.sprintf requestTemplate item
    let xml = getWebService url "GetContent" request
    let namespaceManage =
        let temp = new XmlNamespaceManager(xml.NameTable)
        temp.AddNamespace("soap", "http://schemas.xmlsoap.org/soap/envelope/")
        temp.AddNamespace("mtps", "urn:msdn-com:public-content-syndication")
        temp.AddNamespace("c", "urn:msdn-com:public-content-syndication")
        temp.AddNamespace("p", "urn:mtpg-com:mtps/2004/1/primary")
        temp
    match xml.SelectSingleNode(xpath, namespaceManage) with
    | null -> print_endline "Not found"
    | html -> print_endline html.InnerText
    
queryMsdn "System.IO.StreamWriter"
