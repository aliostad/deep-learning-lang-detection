namespace Muffin.Pictures.Archiver

open Muffin.Pictures.Archiver.Domain
open Muffin.Pictures.Archiver.Rop

module FileMover =
    let move moveWithFs compareFiles cleanUp =
        moveWithFs
        >=> compareFiles
        >=> cleanUp

    let moveFile copyToDestination moveRequest =
        try
            copyToDestination moveRequest
            Success moveRequest
        with
        | ex -> CouldNotCopyFile { Request = moveRequest; Message = ex.Message } |> Failure

    let cleanUp deleteSource moveRequest =
        try
            deleteSource moveRequest
            Success moveRequest
        with
        | ex -> CouldNotDeleteSource { Request = moveRequest; Message = ex.Message } |> Failure

    let compareFiles compare moveRequest =
        let areEqual = compare moveRequest.Source moveRequest.Destination
        if areEqual then
            Success moveRequest
        else
            BytesDidNotMatch moveRequest |> Failure

    let copyToDestination ensureDirectoryExists copy moveRequest =
        ensureDirectoryExists moveRequest.Destination
        copy moveRequest.Source moveRequest.Destination true

    let ensureDirectoryExists directoryExists createDirectory path =
        if not (directoryExists path) then
            createDirectory path
