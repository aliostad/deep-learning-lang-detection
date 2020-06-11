module ShowFinder

open EpisodeWebMvc
open System
open System.IO
open System.Text.RegularExpressions

let beforeDatePattern = @".+?(?=_\d\d.\d\d.\d\d)"
let datePattern = @"(\d\d.\d\d.\d\d)"

let cacheShow parsed mapped id =
    let newCacheEntry = sprintf "%s%s *** %s *** %d" Environment.NewLine parsed mapped id
    let finfo = FileInfo("./shows.map")
    File.AppendAllText("./shows.map", newCacheEntry, System.Text.Encoding.UTF8)

let parseShowName file =
    let nameMatch = Regex.Match(file, beforeDatePattern)
    match nameMatch.Length with
    |0 -> None
    |_ -> Some (nameMatch.Value.Split([|"__"|], StringSplitOptions.RemoveEmptyEntries)
                |> Seq.head
                |> String.map(fun c -> match c with
                                       |'_' -> ' '
                                       |_ -> c))

let getShowInfoByName showName (api:TvDbApi) = 
    let dbResult = async {
        let! dbShows = api.SearchShow showName
        match dbShows |> Seq.length with
        |1 -> return Some (dbShows |> Seq.head)
        |_ -> match dbShows |> Seq.tryFind(fun s -> s.seriesName = showName) with
              |None -> return None
              |Some matched -> return Some matched
    }
    (dbResult |> Async.RunSynchronously)

let getShowInfo file (api:TvDbApi) =
    let getInfo = async{
        let parsedShow = parseShowName file
        let dbShow = match parsedShow with
                     |None -> None
                     |Some name -> api |> getShowInfoByName name
                            
        match dbShow with
        |None -> ()
        |Some show -> api.CacheShow parsedShow.Value show

        return (parsedShow, dbShow)
    }

    let result = (getInfo |> Async.RunSynchronously)
    result    