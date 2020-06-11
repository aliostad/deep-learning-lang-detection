module DevRT.Refactor

open System.Collections.Generic
open System.Linq
open DataTypes
open RefactorLine
open StringWrapper

let notEmptyPairOfLines (line1, line2) =
    line1 |> notEmptyLine || line2 |> notEmptyLine

let rec emptyLineAbove (lines: string list) resultedLines =
    match lines with
    | prev::curr::tail when isEmptyLineRequired prev curr ->
        emptyLineAbove (curr::tail) (resultedLines@[prev;""])
    | prev::curr::tail ->
        emptyLineAbove (curr::tail) (resultedLines@[prev])
    | [last] -> emptyLineAbove [] (resultedLines@[last])
    | [] -> resultedLines

let processLines processLine lines =
    let last = lines |> Array.last
    let trimed =
        let lines = lines |> Array.toList
        let lines = emptyLineAbove lines []
        lines
        |> List.toSeq
        |> Seq.pairwise
        |> Seq.filter notEmptyPairOfLines
        |> Seq.map (fun (line1, _) -> line1 |> processLine )
    seq {
        yield! trimed
        if last |> notEmptyLine then
            yield last |> processLine }

let difference (original, processed) =
    let setDiff = (set processed) - (set original)
    let lineNumDiff =
        (original.Count()) <> (processed.Count())
    setDiff, lineNumDiff

let getChanged difference (original, processed) =
    match (original, processed) |> difference with
    | ((setDiff: Set<_>), false) when setDiff.IsEmpty -> None
    | setDiff -> Some processed

let processFile processLine read processLines file =
    let original = file |> read
    let processed =
        original
        |> processLines (file |> processLine)
        |> Seq.toArray
    (original, processed) |> getChanged difference

let fileFilter exists file =
    (exists file) &&
    (isRegexMatch ".fs$" file || isRegexMatch ".cs$" file)

let refactor processFile writeLines file outFile =
    file
    |> processFile
    |> Option.fold(fun _ lines ->
        lines |> writeLines outFile) ()

let handle refactor fileFilter isRefactorOn = function
    | _ when isRefactorOn |> not -> ()
    | file when fileFilter file -> refactor file file
    | _ -> ()
