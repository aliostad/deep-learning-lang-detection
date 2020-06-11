module Guit.Git.RepositoryService

open System
open FParsec

module internal CommitLogParser =
    let private spaceAndTab = " \t"

    let str = pstring

    let hexStr = manySatisfy isHex

    let betweenAngleBrackets parser =
        between (str "<") (str ">") parser
    
    let revision = skipString "commit " >>. (manySatisfy isHex)

    let merge = str "Merge:" >>. spaces1 >>. (pipe3 hexStr spaces1 hexStr (fun rev1 sp rev2 -> (rev1, rev2)))

    // this parser should be replaced with more exact one.
    let authorName = manyCharsTill (noneOf "\r\n<>") (lookAhead (str " <"))

    // this parser should be replaced with more exact one.
    let mailAddress = manyChars (noneOf " \t<>")

    let author =
        pipe2 (skipString "Author: " >>. authorName .>> spaces) (betweenAngleBrackets mailAddress)
            (fun authorName mailAddress -> { Name = authorName; MailAddress = { Value = mailAddress } })

    let date =
        (skipString "Date:" >>. spaces >>. manyChars (noneOf "\r\n"))
        |>> fun date -> DateTime.ParseExact(date, "ddd MMM d HH:mm:ss yyyy zzz", Globalization.DateTimeFormatInfo.InvariantInfo)

    let emptyDescriptionLine = manyChars (anyOf spaceAndTab)

    let nonEmptyDescriptionLine = str "    " >>. restOfLine false

    let descriptionLine = attempt nonEmptyDescriptionLine <|> emptyDescriptionLine

    let description =
        // description is between empty lines, so skip first and last empty line.
        emptyDescriptionLine .>> skipNewline
        >>. manyTill (descriptionLine .>> (skipNewline <|> eof)) (lookAhead ((skipNewline >>. revision) <|> (eof >>% "")))
        .>> (skipNewline <|> eof)
        |>> fun lines -> String.Join(Environment.NewLine, lines)

    let oneCommit =
        pipe5
            (revision .>> skipNewline)
            (opt (merge .>> skipNewline))
            (author .>> skipNewline)
            (date .>> skipNewline)
            description 
            (fun revision merge author date description ->
                { Revision = { Value = revision };
                  MergeInfo = match merge with
                              | Some(x) -> Some({ To = { Value = fst x }; From = { Value = snd x }})
                              | None -> None
                  Author = author;
                  Date = date;
                  Description = description })

    let commits = many oneCommit

    let parse = run commits

let loadCommitLogs (repository : Repository) =
    let processInfo = new System.Diagnostics.ProcessStartInfo();
    processInfo.FileName <- @"C:\Program Files (x86)\Git\bin\git.exe"
    processInfo.CreateNoWindow <- true
    processInfo.UseShellExecute <- false
    processInfo.RedirectStandardOutput <- true
    processInfo.WorkingDirectory <- repository.Path
    processInfo.Arguments <- "log"

    let p = System.Diagnostics.Process.Start(processInfo);
    let log = p.StandardOutput.ReadToEnd()

    match CommitLogParser.parse log with
    | Success(commits, _, _) -> { Commits = commits }
    | Failure(errorMessage, _, _) -> failwith errorMessage
