module SevenDigital 
open System.Net
open System.IO
open System
open System.Xml
open System.Xml.Linq

type Api() = 

 let loadEndpoint endPoint = 
  let url = "http://api.7digital.com/1.2/"+endPoint+"?artistId=1&oauth_consumer_key=test-api"
  let client = new WebClient()
  client.DownloadString(new Uri(url)) 
 let doc = XDocument.Parse(loadEndpoint "artist/releases")
 let xname sname = XName.Get sname
 let xattr (elem: XElement) sname = elem.Attribute(xname sname).Value

 member x.GetArtistReleasesXml() =
  loadEndpoint "artist/releases"

 member x.GetArtistReleases() = 
  doc.Descendants(xname "release")
  |>  Seq.map (fun x -> Int32.Parse(xattr x "id"), x.Descendants(xname "title") |> Seq.nth 0 ) // NOTE: returns tuple of int and XElement


