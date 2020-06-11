namespace Muffin.Pictures.Archiver

open System

open Muffin.Pictures.Archiver.Pictures
open Muffin.Pictures.Archiver.FileMover
open Muffin.Pictures.Archiver.MoveRequests
open Muffin.Pictures.Archiver.Files
open Muffin.Pictures.Archiver.TimeTakenRetriever
open Muffin.Pictures.Archiver.Domain
open Muffin.Pictures.Archiver.FileSystem
open Muffin.Pictures.Archiver.TagRetriever

module CompositionRoot =

    let fsOperations = FileSystemOperations

    let composeCleanUp =
        let deleteSource moveRequest = fsOperations.Delete moveRequest.Source
        cleanUp deleteSource

    let composeMoveWithFs =
        let ensureDirectoryExists = ensureDirectoryExists fsOperations.DirectoryExists fsOperations.CreateDirectory
        let copy source destination overwrite = fsOperations.Copy(source, destination, overwrite)
        let copyToDestination moveRequest = copyToDestination ensureDirectoryExists copy moveRequest

        moveFile copyToDestination

    let composeGetPictures arguments exifTool time =
        let timeProvider = time
        let timeTakenProvider = timeTaken arguments.Mode
        let toOldPicture = toOldPicture timeTakenProvider timeProvider
        getPictures toOldPicture allFilesInPath exifTool

    let composeMove =
        let moveWithFs = composeMoveWithFs
        let cleanUp = composeCleanUp
        let composeCompareFiles = compareFiles fsOperations.Compare
        move moveWithFs composeCompareFiles cleanUp

    let composeGetMoveRequests arguments exifTool time =
        let getPictures = composeGetPictures arguments exifTool time
        getMoveRequests getPictures
