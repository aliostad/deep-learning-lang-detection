namespace HarmonyGenLastFm

open System
open System
open System.Net
open System.IO
open FSharp.Data

type ArtistInfo = XmlProvider< "http://bunnykingdom.org/media/sampleResponses/artistInfo.xml" >

type ArtistTopTags = XmlProvider< "http://bunnykingdom.org/media/sampleResponses/artistTopTags.xml" >

type ArtistTopAlbums = XmlProvider< "http://bunnykingdom.org/media/sampleResponses/artistTopAlbums.xml" >

type ArtistTopTracks = XmlProvider< "http://bunnykingdom.org/media/sampleResponses/artistTopTracks.xml" >

type ArtistSimilar = XmlProvider< "http://bunnykingdom.org/media/sampleResponses/artistSimilar.xml" >

type ArtistEvents = XmlProvider< "http://bunnykingdom.org/media/sampleResponses/artistEvents.xml" >

type TagTopArtists = XmlProvider< "http://bunnykingdom.org/media/sampleResponses/tagTopArtists.xml" >

module urlUtils = 
    let build_url baseUrl keyValue = 
        let qryStr = String.Join("&", keyValue |> List.map (fun (k, v) -> String.Format("{0}={1}", k, v)))
        String.Format("{0}?{1}", baseUrl, qryStr)
    
    let get_url url = 
        let req = WebRequest.Create(Uri(url))
        use resp = req.GetResponse()
        use stream = resp.GetResponseStream()
        use reader = new IO.StreamReader(stream)
        reader.ReadToEnd()
    
    let queryBase baseURL api_key fnc parser optional = 
        let keyValue = 
            [ ("api_key", api_key)
              ("method", fnc) ]
            @ optional
        
        let url = build_url baseURL keyValue
        printfn "%s" url
        let raw = 
            try 
                Some(parser (get_url url))
            with _ -> None
        raw

type Artist(apiKey : string, artist : string) = 
    member this.apiKey = apiKey
    member this.baseURL = "http://ws.audioscrobbler.com/2.0/"
    member this.artist = artist
    member this.getInfo = 
        urlUtils.queryBase this.baseURL this.apiKey "artist.getinfo" ArtistInfo.Parse [ ("artist", this.artist) ]
    member this.getTopTags optional = 
        urlUtils.queryBase this.baseURL this.apiKey "artist.getTopTags" ArtistTopTags.Parse [ ("artist", this.artist) ]
    member this.getTopAlbums optional = 
        urlUtils.queryBase this.baseURL this.apiKey "artist.getTopAlbums" ArtistTopAlbums.Parse 
            [ ("artist", this.artist) ]
    member this.getTopTracks = 
        urlUtils.queryBase this.baseURL this.apiKey "artist.getTopTracks" ArtistTopTracks.Parse 
            [ ("artist", this.artist) ]
    member this.getSimilar = 
        urlUtils.queryBase this.baseURL this.apiKey "artist.getSimilar" ArtistSimilar.Parse [ ("artist", this.artist) ]

type Tag(apiKey : string, tag : string) = 
    member this.apiKey = apiKey
    member this.baseURL = "http://ws.audioscrobbler.com/2.0/"
    member this.tag = tag
    member this.getTopArtists = 
        urlUtils.queryBase this.baseURL this.apiKey "tag.getTopArtists" TagTopArtists.Parse [ ("tag", this.tag) ]