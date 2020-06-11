open System
open Newtonsoft.Json
open Newtonsoft.Json.Linq
open System.Text.RegularExpressions
open System.Net.Http
open SixLabors.ImageSharp

type PhotoInfo = 
    {
        Id: int64
        Secret: string
        OriginalSecret: string
        Server: string
        Farm: string
        OwnerFullName: string
        OwnerUsername: string
        OriginalFormat: string
        Title: string
        PublicUrl: string option
    }

[<EntryPoint>]
let main argv =
    let apiKey = ""
    

    let getPhoto (apiKey: string) (photoInfo: PhotoInfo) =
        let url = 
            "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo" + 
            "&api_key=" + apiKey + 
            "&photo_id=" + photoInfo.Id.ToString() +
            "&secret=" + photoInfo.Secret +
            "&format=json"
        use client = new HttpClient()
        client.GetByteArrayAsync(url)
        |> Async.AwaitTask
        |> Async.RunSynchronously
        |> Image.Load        

    let getJson (url:string) = 
        let fixFlickrJson (s:string) = s.Substring(14,s.Length-15)

        use client = new HttpClient()
        use response = 
            client.GetAsync(url)
            |> Async.AwaitTask
            |> Async.RunSynchronously
        
        response.Content.ReadAsStringAsync()
        |> Async.AwaitTask
        |> Async.RunSynchronously
        |> fixFlickrJson
    
    let getPhotoSize (apiKey) (id:int64) = 
        let url = 
            "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes" + 
            "&api_key=" + apiKey + 
            "&photo_id=" + id.ToString() +
            "&format=json"
        let j = JObject.Parse (getJson(url))
        j.["sizes"].["size"]
        |> Seq.tryFind (fun s -> string s.["label"] = "Original")
        |> Option.map (fun s -> (int s.["width"], int s.["height"]))

    let getPhotoInfo (apiKey) (id:int64) (secret:string) = 
        let url = 
            "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo" + 
            "&api_key=" + apiKey + 
            "&photo_id=" + id.ToString() +
            "&secret=" + secret +
            "&format=json"
        let j = JObject.Parse (getJson(url))
        {
            Id = id
            Secret = secret
            Server = string j.["photo"].["server"]
            Farm = string j.["photo"].["farm"]
            OriginalSecret = string j.["photo"].["originalsecret"]
            OriginalFormat = string j.["photo"].["originalformat"]
            OwnerUsername = string j.["photo"].["owner"].["username"]
            OwnerFullName = string j.["photo"].["owner"].["realname"]
            Title = string j.["photo"].["title"].["_content"]
            PublicUrl = 
                j.["photo"].["urls"].["url"]
                |> Seq.tryFind (fun u -> (string u.["type"]) = "photopage")
                |> Option.map (fun u -> string u.["_content"])
        }

    let getPhotos (apiKey) (tags: string list) =
        let url = 
            "https://api.flickr.com/services/rest/?method=flickr.photos.search" +
            "&api_key=" + apiKey + 
            "&tags=" + (List.reduce (fun x y -> x + "," + y) tags) +  
            "&sort=relevance&content_type=1&license=2&format=json&per_page=10"
        getJson(url)
        |> JObject.Parse
        |> (fun j -> j.["photos"].["photo"])
        |> Seq.map (fun p -> (p.["id"].ToObject<int64>(),p.["secret"].ToObject<string>()))
        |> List.ofSeq

        
    let isGoodSizePhoto (width:int) (height:int) = 
        width >= 1875 &&
        height >= 1275 &&
        ((float width)/(float height) > 1.4) && 
        ((float width)/(float height) < 1.6)

    let photo =
        getPhotos apiKey (List.singleton "flowers")
        |> Array.ofList
        |> Array.Parallel.choose (fun (i, s) -> 
              let size = getPhotoSize apiKey i
              match size with
              | Some (w,h) when isGoodSizePhoto w h -> Some (i,s)
              | _ -> None)
        |> List.ofArray
        |> (fun l -> List.item (System.Random().Next l.Length) l)
        |> (fun (i,s) -> getPhotoInfo apiKey i s)
        |> (fun p -> getPhoto apiKey p)
    photo.

        
    0 // return an integer exit code
