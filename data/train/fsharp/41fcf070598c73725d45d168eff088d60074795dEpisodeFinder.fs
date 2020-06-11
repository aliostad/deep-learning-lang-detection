module EpisodeFinder

open EpisodeWebMvc
open System
open System.Text.RegularExpressions

let beforeDatePattern = @".+?(?=_\d\d.\d\d.\d\d)"
let datePattern = @"(\d\d.\d\d.\d\d)"
    
let canonizeEpisodeName (name:string) =
    name.ToLower()
    |> String.filter(fun c -> Char.IsLetter c || Char.IsDigit c)

let parseEpisodeName (file:string) =
    let fileParts = file.Split([|"__"|], StringSplitOptions.RemoveEmptyEntries)
    let episodePart = fileParts.[1]
    let episodeNameMatch = Regex.Match(episodePart, beforeDatePattern)
    match episodeNameMatch.Value with
    |"" -> episodePart |> canonizeEpisodeName
    |_ -> episodeNameMatch.Value |> canonizeEpisodeName

let parseEpisodeDate (file:string) = 
    match Regex.Match(file, datePattern).Value.Split('.') with
    |[|yy;mm;dd|] -> sprintf "20%s-%s-%s" yy mm dd
    |_ -> ""

let findEpisodeByName name (show:Show) (api:TvDbApi) : Async<Episode option> = async {
    let! showEpisodes = api.GetEpisodes show.id 
    let foundEpisode = showEpisodes
                       |> Seq.tryFind(fun ep -> (ep.episodeName |> canonizeEpisodeName) = name)
    return foundEpisode
}

let findEpisodeByDate aired (show:Show) (api:TvDbApi) : Async<Episode option>= async {
    if aired = "" then
        return None
    else
        let! showEpisodes = api.GetEpisodes show.id
        let foundEpisode = showEpisodes
                           |> Seq.tryFind(fun ep -> ep.firstAired = aired)
        return foundEpisode
}

let getEpisodeInfo (file:string) episodeShow (api:TvDbApi) = 
        let getEpisode = async{
            match episodeShow with
            | None -> return None
            | Some show -> 
                if file.Contains("__") then
                    let! episode = api |> findEpisodeByName (parseEpisodeName file) show
                    return episode
                else
                    let! episode = api |> findEpisodeByDate (parseEpisodeDate file) show
                    return episode
        }
        (getEpisode |> Async.RunSynchronously)