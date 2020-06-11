namespace Firm

open System.IO
open Files
open FSharp.Literate
open Firm.Models
open Data

module Transformation =
    let dirEnumerator id =
        Directory.EnumerateFiles(id, "*", SearchOption.AllDirectories)

    let fileExists file =
        File.Exists(file)

    let private getTagCloud (allPosts: PostModel list) =
        allPosts
        |> Seq.collect (fun pm -> pm.Tags)
        |> Seq.groupBy (fun t -> t)
        |> Seq.map (fun (t, ts) -> TagModel(t, Seq.length ts))

    let private processPosts config index archive (postFiles: PostFile list) =
        let postsData =
            postFiles
            |> List.map (fun pf ->
                let meta = pf.Meta
                let ld = 
                    match pf.Type with
                    | Md -> Literate.ParseMarkdownFile(pf.File.Input)
                    | Fsx -> Literate.ParseScriptFile(pf.File.Input)
                    |> Urls.Literate.withAbsUrls config.BaseUrl
                let doc = Literate.WriteHtml(ld) 
                pf, PostModel(pf.Name, meta.Title, meta.Date, meta.Tags, doc))
            |> List.sortBy (fun (_, pm) -> pm.Date)
            |> List.rev
        let _, postModels = postsData |> List.unzip
        let tagCloud = getTagCloud postModels
        postsData
        |> List.map (fun (pf, p) -> (pf, SinglePostModel(config.BaseUrl, config.DisqusShortname, p, postModels, tagCloud)))
        |> List.iter Output.Razor.writePost
        let allPostsModel = AllPostsModel(config.BaseUrl, config.DisqusShortname, postModels, tagCloud)
        Output.Razor.writeArchive allPostsModel archive 
        index |> List.iter (Output.Razor.writeIndex allPostsModel)
        (postModels, tagCloud)

    let private processPages config (pages: PageFile list) (allPosts, tagCloud) =
        pages
        |> List.map (fun p ->
            (p, PageModel(
                    config.BaseUrl,
                    config.DisqusShortname,
                    Literate.WriteHtml(Literate.ParseMarkdownFile(p.File.Input) |> Urls.Literate.withAbsUrls config.BaseUrl),
                    allPosts,
                    tagCloud)))
        |> List.iter Output.Razor.writePage

    let private processResources (resources: ResourceFile list) =
        resources |> List.iter Output.copyResource

    let private processInputs outputDir config index archive (posts, pages, resources) =
        let allPostsData = processPosts config index archive posts
        processPages config pages allPostsData
        processResources resources
        Output.Xml.generateRss outputDir config posts

    let generate root =
        let id = root @+ "data" @+ "input"
        let od = root @+ "output"
        Output.Razor.compileTemplates root
        Files.inputFiles dirEnumerator fileExists (id, od)
        |> processInputs
            od
            (ConfigData.fromFile(root @+ "config.json"))
            (Files.index od)
            (Files.archive od)
