// Learn more about F# at http://fsharp.org. See the 'F# Tutorial' project
// for more guidance on F# programming.

#load "../.paket/packages/FsLab/FsLab.fsx"

open System
open System.IO
open XPlot.GoogleCharts
open FSharp.Data
open MathNet.Numerics
open System.Globalization

// git log --pretty=format:'[%H],%aN,%ad,%s' --date=local --numstat > sfa-log.log

// --------------------------
// 1.- PARSE GIT LOG FILE
// --------------------------

[<Literal>]
let LineBreak = "\r\n"

type CommitInfo = {Hash : string; Author : string; TimeStamp : DateTime; Message : string}
type CommittedFile = {LinesAdded: int option; LinesDeleted: int option; FileName: string}
type Commit = {CommitInfo: CommitInfo; Files: CommittedFile[]}

let filePath = Path.Combine(__SOURCE_DIRECTORY__, "..\..\Data\sfa-log.log")
let file = File.ReadAllText(filePath)

type CommitInfoCsv = CsvProvider<"Hash,Author,Date,Message", HasHeaders = false, 
                                    Schema = "Hash,Author,Date(string),Message">
type CommitLineCsv = CsvProvider<"LinesAdded\tLinesDeleted\tFile", HasHeaders = false, 
                                    Schema = "LinesAdded(int option),LinesDeleted(int option),FileName">

let commits = file.Split([|LineBreak + LineBreak|], StringSplitOptions.RemoveEmptyEntries)

let extractCommitInfo (commit:string) =
    let isCommitInfoLine (line: string) =
        line.StartsWith("[")

    let extractCommitedFilesInfo c = 
        let commitFileLine = CommitLineCsv.Parse(c).Rows |> Seq.head
        {LinesAdded = commitFileLine.LinesAdded; 
        LinesDeleted = commitFileLine.LinesDeleted; FileName = commitFileLine.FileName}

    let commitLines = commit.Split([|LineBreak|], StringSplitOptions.RemoveEmptyEntries)    
    let commitInfoLine = commitLines |> Array.takeWhile(isCommitInfoLine) |> Array.last
    let fileLines = commitLines |> Array.skipWhile(isCommitInfoLine)
    
    let infoRow = CommitInfoCsv.Parse(commitInfoLine).Rows |> Seq.head
    let commitInfo = {Hash = infoRow.Hash; Author = infoRow.Author; 
        TimeStamp = DateTime.ParseExact(infoRow.Date,"ddd MMM d HH:mm:ss yyyy", 
                                        CultureInfo.InvariantCulture); 
    Message = infoRow.Message}
        
    let fileRows = fileLines |> Array.map extractCommitedFilesInfo
    
    {CommitInfo = commitInfo; Files = fileRows}

// --------------------------
// 2.- BASIC STATISTICS
// --------------------------

// 2.1 - TOTAL COMMITS
let totalCommits = 
    commits
    |> Array.map extractCommitInfo

let extensionBlacklist = [|".css"; ".feature.cs"; ".generated.cs"; ".config"; ".scss"; ".csproj"; ".cshtml"; ".min.js"; ".sln"|]

let filteredCommits =
    totalCommits
    |> Array.map(fun c -> {CommitInfo = c.CommitInfo; 
                           Files = c.Files 
                           |> Array.filter(fun f -> extensionBlacklist 
                                                    |> Array.forall(fun e -> not (f.FileName.EndsWith(e))))})

// 2.2 - NUMBER OF FILES CHANGED ()
let numberOfFilesChanged =
    totalCommits
    |> Array.collect(fun c -> c.Files)
    |> Array.length


// 2.3 - NUMBER OF FILE
let numberOfFiles = 
    totalCommits
    |> Array.collect(fun c -> c.Files)
    |> Array.distinctBy(fun f -> f.FileName)
    |> Array.length
    

// 2.4 - FILE BY TYPE
let filesByType =
    totalCommits
    |> Array.collect(fun c -> c.Files)
    |> Array.distinctBy(fun f -> f.FileName)
    |> Array.groupBy(fun f -> Path.GetExtension f.FileName)
    |> Array.map(fun f -> fst f, (snd f) |> Array.length)
    |> Array.sortByDescending snd


// 2.5 - CHART OF FYLE BY TYPE
let chartFileByType =
    filesByType
    |> Chart.Pie
    |> Chart.WithLegend true
    |> Chart.WithSize(640, 480)


// 2.6 - GET AUTHORS
let authors =
    totalCommits
    |> Array.groupBy(fun c -> c.CommitInfo.Author)
    |> Array.map(fun (a, _) -> a)
    |> Array.distinct

let numberOfAuthors =
    authors
    |> Array.length


// --------------------------
// 2.- HOTSPOTS
// --------------------------

// 3.1 - NUMBER OF REVISIONS BY FILE
let numberOfRevisionsByFile =
    totalCommits
    //filteredCommits
    |> Array.collect(fun c -> c.Files)
    |> Array.groupBy(fun f -> f.FileName)
    |> Array.map ( fun c -> fst c, snd c |> Array.length)
    |> Array.sortByDescending snd
    |> Array.take 10

// 3.2 - BAR CHART OF NUMBER OF REVISIONS
numberOfRevisionsByFile
|> Chart.Bar
|> Chart.WithLabels ["Number of revisions"]

// 3.3 - GET A FILE FROM GITHUB
// https://github.com/SkillsFundingAgency/FindApprenticeship/blob/251074332a2165fa3b9ccbd67b85b183fd4b1d1c/src/SFA.Apprenticeships.Domain.Entities/Vacancies/ProviderVacancies/Apprenticeship/ApprenticeshipVacancy.cs
// https://raw.githubusercontent.com/SkillsFundingAgency/FindApprenticeship/master/src/SFA.Apprenticeships.sln
let gitHubRawContentBaseAddress = "https://raw.githubusercontent.com/SkillsFundingAgency/FindApprenticeship/master/"
let getFileFromGitHub fileUrl =
    let request = Http.Request(fileUrl, silentHttpErrors = true)
    if ( request.StatusCode = 200 ) then
        match request.Body with
        | Text(t) -> Some(t)
        | Binary(_) -> None             
    else None
    
// 3.4 - CALCULATE COMPLEXITY 
// 3.4.1 - VIA NUMBER OF LINES
let listOfFiles =
    totalCommits
    |> Array.collect(fun c -> c.Files)
    |> Array.map(fun c -> c.FileName )
    |> Array.distinct

let numberOfLinesOf file =
    let gitHubPath = Path.Combine ( gitHubRawContentBaseAddress, file)
    let fileContent = getFileFromGitHub gitHubPath
    match fileContent with
    | Some(content) -> Some (file, content.Split([|'\n'|]) |> Array.length)
    | None -> None

let filesToStudy = [|
    "src/SFA.Apprenticeships.Web.Raa.Common/Providers/VacancyProvider.cs";
    "src/SFA.Apprenticeships.Web.Recruit/Controllers/VacancyPostingController.cs";
    "src/SFA.Apprenticeships.Web.Recruit/Mediators/VacancyPosting/VacancyPostingMediator.cs";
    "src/SFA.WebProxy/IO/EchoStream.cs";
    "src/SFA.Apprenticeships.Web.Manage.EndToEndTests/VacancyControllerIntegrationTests.cs";
    "src/SFA.Apprenticeships.Web.Candidate.UnitTests/Views/ApprenticeshipSearch/DetailsTests.cs";
    "src/SFA.Apprenticeships.Web.Candidate/Providers/CandidateServiceProvider.cs";
    "src/SFA.Apprenticeships.Web.Candidate/Providers/ApprenticeshipApplicationProvider.cs";
    "src/SFA.Apprenticeships.Web.Candidate.UnitTests/Mediators/ApprenticeshipSearch/ResultsTests.cs";
    "src/SFA.Apprenticeships.Infrastructure.UnitTests/LegacyWebServices/GatewayApprenticeshipVacancyDetailMapperTests.cs";
    "src/SFA.Apprenticeships.Web.Candidate/Mediators/Search/ApprenticeshipSearchMediator.cs";
    "src/SFA.Apprenticeships.Web.Candidate/Controllers/AccountController.cs";
    "src/SFA.Apprenticeships.Web.Candidate/Controllers/VacancySearchController.cs";
    "src/SFA.Apprenticeships.Web.Manage/Controllers/VacancyController.cs";
    "src/Prototypes/Areas/Recruit/Controllers/VacancyPostingController.cs";
    "src/SFA.Apprenticeships.Application.Candidate/CandidateService.cs";
    "src/SFA.Apprenticeships.Web.Candidate/Controllers/LoginController.cs"|]
    
let numberOfLinesByFile =
    listOfFiles
    |> Array.filter(fun f -> filesToStudy |> Array.contains f)
    |> Array.choose numberOfLinesOf
    |> Array.sortByDescending snd

let getFileNameFromPath (p:string) =
    p.Split('/') |> Array.rev |> Array.head

numberOfLinesByFile
|> Array.map(fun f -> (getFileNameFromPath(fst f), snd f))
|> Chart.Bar
|> Chart.WithLabels ["Number of lines"]

// 3.4.2 - VIA NUMBER OF TABS

// 3.5 - NUMBER OF REVISIONS AND AUTHORS

let numberOfRevisionsPerFile =
    filteredCommits
    |> Array.map(fun c -> c.Files |> Array.filter(fun f -> filesToStudy 
                                                            |> Array.contains f.FileName) 
                                                            |> Array.map(fun f -> (c.CommitInfo.Author, f)))
    |> Array.collect id
    |> Array.groupBy(fun (_,f) -> f.FileName)
    |> Array.map(fun(f, af) -> getFileNameFromPath f, af |> Array.length)
    |> Array.sortByDescending snd

let numberOfAuthorsPerFile =
    filteredCommits
    |> Array.map(fun c -> c.Files |> Array.filter(fun f -> filesToStudy 
                                                            |> Array.contains f.FileName) 
                                                            |> Array.map(fun f -> (c.CommitInfo.Author, f)))
    |> Array.collect(fun x -> x)
    |> Array.groupBy(fun (_,f) -> f.FileName)
    |> Array.map(fun(f, af) -> getFileNameFromPath f, af |> Array.groupBy(fun (a,_) -> a) |> Array.length)
    |> Array.sortByDescending snd

// Combined chart
[|numberOfRevisionsPerFile;numberOfAuthorsPerFile|]
|> Chart.Bar
|> Chart.WithLabels ["Number of revisions"; "Number of authors"]




// 4.- COUPLING
let combinator (seq:string[]) = 
    [|
        for i in 0 .. seq.Length - 1 do
            for j in i+1 .. seq.Length - 1  do
                if i <> j then 
                    if seq.[i] < seq.[j] then
                        yield (seq.[i], seq.[j])
                    else yield (seq.[j], seq.[i])
    |]

type CommitedPair = {File1 : string; File2: string; TimesCommitedTogether: int}

let committedTogether =
    //totalCommits
    filteredCommits
    |> Array.map(fun c -> c.Files |> Array.map (fun f -> f.FileName) |> combinator)
    |> Array.collect id
    |> Array.groupBy id
    |> Array.sortByDescending ( snd >> Array.length )
    |> Array.map(fun (k, a) -> {File1 = fst k; 
                                File2 = snd k; 
                                TimesCommitedTogether = (a |> Array.length)})    


committedTogether
|> Array.take 20
|> Array.map(fun c -> getFileNameFromPath c.File1, getFileNameFromPath c.File2, c.TimesCommitedTogether)
|> Chart.Sankey
|> Chart.WithLabels["File1"; "File2"; "Number of times committed together"]

let NumberOfCommitsThreshold = 50

type CommitedFile = { FileName : string; NumberOfCommits : int }

let commitsPerFile =
    filteredCommits
    |> Array.collect (fun c -> c.Files)
    |> Array.groupBy (fun c-> c.FileName)
    |> Array.map(fun c -> {FileName = fst c; NumberOfCommits = (snd c |> Array.length)})
    |> Array.sortByDescending (fun cf -> cf.NumberOfCommits)
    |> Array.takeWhile ( fun cf -> cf.NumberOfCommits > NumberOfCommitsThreshold)

type CouplingInformation = {File1: string; File2: string; TimesCommitedTogether: int; CouplingDegree: float}
    
let commitsPerPair = 
    let calculateCoupling (c:CommitedPair) =
        let total = commitsPerFile |> Array.find (fun cf -> cf.FileName = c.File1 )                                       
        {File1 = c.File1; 
        File2 = c.File2; 
        TimesCommitedTogether = c.TimesCommitedTogether; 
        CouplingDegree = float c.TimesCommitedTogether / float total.NumberOfCommits}

    let round (x: float) = int (Math.Round (x * 100.0))

    let sortByCouplingDegree a b =
        let couplingDegree = b.CouplingDegree - a.CouplingDegree
        let numberRevisions = b.TimesCommitedTogether - a.TimesCommitedTogether
        if couplingDegree <> 0.0 then round couplingDegree else numberRevisions
        
    committedTogether
    |> Array.filter ( fun c -> commitsPerFile|> Array.exists (fun cf -> cf.FileName = c.File1 ))                                                 //Map.containsKey (fst (fst c)) )
    |> Array.map calculateCoupling
    |> Array.sortWith sortByCouplingDegree

commitsPerPair
    |> Array.iter (fun r -> printf "File1: %s\nFile2: %s\nNumber of commits: %d\nCoupling: %f\n\n" r.File1 r.File2 r.TimesCommitedTogether r.CouplingDegree)

commitsPerPair
|> Array.take 20
|> Array.map(fun c -> getFileNameFromPath c.File1, getFileNameFromPath c.File2, c.CouplingDegree)
|> Chart.Sankey
|> Chart.WithLabels["File1"; "File2"; "Coupling degree"]

// 5.- COMPLEXITY OVER TIME

let calculateFileStatistics (response: HttpResponseBody) =
    match response with
    | Text(t) -> 
        let srcLines = t.Split([|"\n"|], StringSplitOptions.RemoveEmptyEntries)

        let numLines = srcLines |> Array.length

        let spaces = srcLines |> Array.map ( fun l -> l.ToCharArray() |> Array.takeWhile(fun c -> c = ' '))
        let numTabs = spaces |> Array.map ( fun l -> float( l |> Array.length ) / 4.0)
        let maxTabs = numTabs|> Array.max
        let averageTabs = numTabs |> Array.average

        numLines, maxTabs, averageTabs
    | Binary(_) -> 0, 0., 0.  


let getHistoryOf file =
    totalCommits
    |> Array.filter(fun cf -> cf.Files |> Array.filter(fun f -> f.FileName.Contains file) |> Array.length > 0)
    |> Array.map(fun cf -> cf.CommitInfo.TimeStamp, cf.CommitInfo.Hash.Substring(1, cf.CommitInfo.Hash.Length - 2))

let getComplexityOf file =
    let githubPath = "https://raw.githubusercontent.com/SkillsFundingAgency/FindApprenticeship/"
   
    getHistoryOf file
    |> Array.map(fun f -> fst f, githubPath + snd f + "/" + file)
    |> Array.choose(fun f -> let request = Http.Request(snd f, silentHttpErrors = true)
                             if ( request.StatusCode = 200 ) then
                                Some (fst f, calculateFileStatistics request.Body)   
                             else None    
                            )
    |> Array.sortBy(fst)


let complexity = 
    getComplexityOf "src/SFA.Apprenticeships.Web.Candidate/Controllers/ApprenticeshipSearchController.cs"

let first (x, _, _) = x
let second (_,x,_) = x
let third (_,_,x) = x
complexity
    |> Array.map(fun f -> fst f, (first (snd f)))
    |> Chart.Line

complexity
    |> Array.map(fun f -> fst f, (second (snd f)))
    |> Chart.Line

complexity
    |> Array.map(fun f -> fst f, (third (snd f)))
    |> Chart.Line


// 6.- AUTHORS
//let commitsPerAuthor =
//    totalCommits
//    |> Array.groupBy ( fun c -> c.CommitInfo.Author)
//    |> Array.map(fun ca -> (fst ca, (snd ca) |> Array.length))
//    |> Array.sortByDescending snd

let calculateFileContributionByAuthor ((authorAndComitedFileArray: 
                                       (string * CommittedFile) [])) =
    let sumLinesModified (committedFile : CommittedFile) =
        let getLines lines =
            match lines with
            | Some(x) -> x
            | None -> 0

        ( getLines committedFile.LinesAdded ) + (getLines committedFile.LinesAdded)        

    let commitsGroupedByAuthor = authorAndComitedFileArray |> Array.groupBy fst

    commitsGroupedByAuthor 
        |> Array.map ( fun f -> fst f, (snd f) |> Array.sumBy ( sumLinesModified << snd ))  
        |> Array.sortByDescending snd
        
let commitsByFile fileName =
    totalCommits
    |> Array.collect ( fun c -> c.Files |> Array.map ( fun f -> c.CommitInfo.Author, f))
    |> Array.filter (fun f -> (snd f).FileName.Contains fileName)
    

let contributionsByAuthorOn = commitsByFile >> calculateFileContributionByAuthor     


let fileName = "src/SFA.Apprenticeships.Web.Candidate/Controllers/ApprenticeshipSearchController.cs"

let data =
    (fileName, "", 0)::
    (contributionsByAuthorOn fileName
    |> Array.map(fun u -> fst u, fileName, snd u)
    |> List.ofArray)
    
let options =
    Options(
        minColor = "#f00",
        midColor = "#ddd",
        maxColor = "#0d0",
        headerHeight = 15,
        fontColor = "black",
        showScale = true        
    )
 
let treemap =
    data
    |> Chart.Treemap
    |> Chart.WithLabels
        [
            "Location"
            "Parent"
            "Market trade volume (size)"
        ]
    |> Chart.WithOptions options

let filesOf userName =
    totalCommits
    |> Array.collect(fun c -> c.Files)
    |> Array.distinctBy(fun f -> f.FileName)
    |> Array.map(fun f -> contributionsByAuthorOn f.FileName, f.FileName)
    |> Array.filter(fun f -> fst (fst f |> Array.head)  = userName )
    |> Array.map snd
    

let filesOfVicenc = filesOf "Iron Man"
// Order the above information by contributions.
// Given an author, extract the files where he's the main contributor.

(**
let data =
    let rnd = Random()
    [
        for x in 1. .. 600. ->
            DateTime(2013, 1, 9).AddDays(x), rnd.Next(0, 5)
    ]

data
|> Chart.Calendar
**)


// 7 - COMMITS IN TIME
totalCommits
|> Array.groupBy(fun c -> c.CommitInfo.TimeStamp.Date)
|> Array.map(fun c -> fst c, (snd c) |> Array.length)
|> Chart.Calendar

