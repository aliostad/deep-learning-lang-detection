module Discourse.DumpSql.UpdateSequence

open Discourse.Config
open Discourse.DbModel.Common
open Discourse.DumpSql.Parse
open System.Text.RegularExpressions

let setRecordIdFromCopySection copySection =
    copySection.listRecord
    |> List.map idFromRecord

let withSequenceIdUpdatedForTableName
    tableName
    sqlDumpListLine
    =
    let sequenceName = sequenceIdNameFromTableName tableName sqlDumpListLine

    let setCopySection = Discourse.DumpSql.Parse.listCopySectionFromTableName tableName sqlDumpListLine

    let setRecordIdString =
        setCopySection
        |> List.map setRecordIdFromCopySection
        |> List.concat

    let setRecordId =
        setRecordIdString
        |> List.map System.Int32.Parse

    let nextId = (setRecordId |> List.max) + 1

    let nextIdString = nextId.ToString()

    let replaceRegexPattern =
        statementSetSequenceParamRegexPatternFromSequenceName sequenceName

    sqlDumpListLine
    |> List.map (fun line -> Regex.Replace(line, replaceRegexPattern, nextIdString))


let withSequenceIdUpdatedForListRecordType
    listRecordType
    sqlDumpListLine
    =
    withListTransformApplied
        (listRecordType |> List.map (fun recordType -> (fun listLine ->
            withSequenceIdUpdatedForTableName (tableNameFromRecordType recordType) listLine)))
        sqlDumpListLine

let withSequenceIdUpdatedForSupportedRecordTypes =
    withSequenceIdUpdatedForListRecordType
        [
            RecordType.Permalink
            RecordType.User
            RecordType.Category
            RecordType.Topic
            RecordType.Post
            RecordType.PostAction
            RecordType.Tag
            RecordType.TopicTag
        ]
