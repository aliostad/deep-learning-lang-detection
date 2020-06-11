module Discourse.DumpSql.Parse

open Discourse.Config
open Discourse.DbModel.Common
open System.Text.RegularExpressions
open System.Linq


let copySectionEndLine = "\\."

let copySectionEndLinePattern = "^" + Regex.Escape(copySectionEndLine)

type CopySection =
    {
        tableName: string;
        startLineIndex : int;
        listLine : List<string>;
        listColumnName : List<string>;
        listRecord : List<List<string * string>>
    }

let listColumnValueFromRecordLine (recordLine : string) =
    recordLine.Split([recordValueSeparator] |> List.toArray, System.StringSplitOptions.None)
    |> Array.toList

let copySectionStartLinePattern tableName =
    "^COPY\s+" + tableName + "\s*\(([^\)]*)\)"

let indexOfFirstElementMatchingRegexPattern regexPattern list =
    list |> List.findIndex (fun elem -> Regex.IsMatch(elem, regexPattern, RegexOptions.IgnoreCase))

let indexOfLastElementMatchingRegexPattern regexPattern list =
    list |> List.findIndexBack (fun elem -> Regex.IsMatch(elem, regexPattern, RegexOptions.IgnoreCase))

let listCopySectionFromTableName tableName listLine =
    let startLinePattern = copySectionStartLinePattern tableName
    let listStartLineIndex =
        listLine
        |> List.mapi (fun index line -> (index, line))
        |> List.choose (fun (lineIndex, line) ->
            if Regex.IsMatch(line, startLinePattern, RegexOptions.IgnoreCase) then Some lineIndex else None)
    
    listStartLineIndex
        |> List.map (fun startLineIndex ->
            let copySectionListLine =
                listLine
                |> List.skip startLineIndex
                |> List.takeWhile (fun line -> not (Regex.IsMatch(line, copySectionEndLinePattern)))

            let listColumnNameText = Regex.Match(copySectionListLine.Head, startLinePattern).Groups.[1].Value
            let listColumnName =
                listColumnNameText.Split(List.toArray [columnNameSeparator], System.StringSplitOptions.RemoveEmptyEntries)
                |> Array.toList
                |> List.map (fun columnName -> columnName.Trim())

            let (_, listRecordLine) = copySectionListLine |> List.splitAt 1

            let listRecordListColumnValue =
                listRecordLine
                |> List.map listColumnValueFromRecordLine

            let listRecord =
                listRecordListColumnValue
                |> List.map (fun recordListColumnValue ->
                    recordListColumnValue
                    |> List.mapi (fun index columnValue ->
                        (listColumnName.ElementAt(index), columnValue)))

            {
                tableName = tableName;
                startLineIndex = startLineIndex;
                listLine = copySectionListLine;
                listColumnName = listColumnName;
                listRecord = listRecord
            })

let listCopySectionFromRecordType recordType listLine =
    listCopySectionFromTableName (tableNameFromRecordType recordType) listLine

let copySectionFromRecordType recordType listLine =
    listCopySectionFromRecordType recordType listLine
    |> List.head

let idFromRecord record =
    record
    |> List.pick (fun (columnName, value) -> if columnName = idColumnName then Some value else None)

let idMaxOrZero copySection =
    let setId =
        copySection.listRecord
        |> List.map idFromRecord
        |> List.map System.Int32.Parse
    if 0 < (setId |> List.length) then setId |> List.max else 0

let postActionTypeLikeId sqlDumpListLine =
    let postActionTypeCopySection = copySectionFromRecordType PostActionType sqlDumpListLine
    let typeLikeRecord =
        postActionTypeCopySection.listRecord
        |> List.tryFind (fun record ->
            ((record |> Common.listFindTupleSndWhereFstEquals "name_key") = postActionLikeNameKey))

    match typeLikeRecord with
    | None -> None
    | Some record -> Some (System.Int32.Parse (record |> idFromRecord))

let sequenceIdNameFromTableName tableName sqlDumpListLine =
    let regexPattern = findSequenceIdNameRegexPatternFromTableName tableName
    let regexMatchOption =
        sqlDumpListLine
        |> List.tryPick (fun line ->
            match Regex.Match(line, regexPattern, RegexOptions.IgnoreCase) with
            | null -> None
            | rmatch when rmatch.Success -> Some rmatch
            | _ -> None)

    match regexMatchOption with
    | Some m -> m.Groups.[findSequenceNameRegexGroupName].Value
    | _ -> null

let rec withListTransformApplied (listTransform : ('a -> 'a) list) (original : 'a) =
    let nextOption = listTransform |> List.tryHead
    match nextOption with
    | None -> original
    | Some next -> (withListTransformApplied (listTransform |> List.tail) (next original))
