module DevRT.RefactorLine

open System
open DataTypes
open StringWrapper

let isMostOuterLet line =
    startsWith "let " line || startsWith "l " line

let isTopMostAttribute prev curr =
    prev |> startsWith "[<" |> not && startsWith "[<" curr

let isLet prev curr =
    prev |> startsWith "[<" |> not && isMostOuterLet curr

let isEmptyLineRequired prev curr =
    prev |> isNullOrWhiteSpace |> not
    && (isLet prev curr || isTopMostAttribute prev curr)

let removeTrailingWhiteSpaces = trimEnd ' '

let notNewLine = (<>) Environment.NewLine

let notEmptyLine line =
    (line |> notNewLine) && (line |> isNullOrWhiteSpace |> not)

let mapRule line =
    match (line |> split ',') with
    | [|key; replacement|] -> ( key, replacement )
    | _ -> failwith "wrong rule format"

let getRules read csvPath =
    IOWrapper.combine csvPath "lineRefactor.csv"
    |> read
    |> Array.map mapRule
    |> Array.toList

let chopLine = splitRegex "([^a-zA-Z])"

let replaceAbrev rules line =
    let rules = rules |> Map.ofList
    line
    |> chopLine
    |> Array.toList
    |> List.fold ( fun acc next ->
        let newNext =
            defaultArg (rules |> Map.tryFind next) next
        newNext::acc ) []
    |> List.rev
    |> List.fold (+) String.Empty

let replaceLine replaceAbrev = function
    | line when isRegexMatch ".*\"|\'.*\"|\'.*" line -> line
    | line -> replaceAbrev line

let processLineCsFile = removeTrailingWhiteSpaces

let processLineFsFile rules =
    removeTrailingWhiteSpaces
    >> replaceLine (replaceAbrev rules)

let processLine rules = function
    | file when file |> contains ".fs" ->
        processLineFsFile rules
    | _ -> processLineCsFile
