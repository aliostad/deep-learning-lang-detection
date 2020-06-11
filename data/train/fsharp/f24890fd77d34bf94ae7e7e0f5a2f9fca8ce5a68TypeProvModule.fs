module TypeProvModule

open FSharp.Data

    type saxSysRepo = JsonProvider<"https://api.github.com/users/saxsys/repos">

    type contributorDoc = JsonProvider<"https://api.github.com/repos/saxsys/CinemaKata/contributors">
    
    let Get() =
        saxSysRepo.Load "https://api.github.com/users/saxsys/repos"
        |> Seq.map (fun repo -> repo.ContributorsUrl)
        |> Seq.collect (fun url -> contributorDoc.Load url)
        |> Seq.map (fun contributor -> contributor.Login)
        |> Seq.distinct
        |> Seq.iter (fun c -> printfn "%s" c)