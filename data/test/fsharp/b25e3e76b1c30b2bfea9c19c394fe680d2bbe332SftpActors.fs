[<AutoOpen>]
module SftpActors
    open System
    open System.IO
    open Akka
    open Akka.FSharp
    open SftpClient
    open Utils

    type SftpCommand =
        | ListDirectory of Url
        | UploadFile of UncPath * Url
        | DownloadFile of UncPath * Url
        | Cancel of string

    type SftpCommandResult =
        | Completed
        | Cancelled
        | Error of string

    // Tip: even though this step is probably the most complex one, you can quickly manage it with following technique:
    // Use ISftpClient.BeginUploadFile and ISftpClient.BeginDownloadFile instead of UploadFile and DownloadFile.

    // Tip: Write asyncCallback function that will take IAsyncResult, invoke EndUploadFile or EndDownloadFile 
    // and send Completed, Cancelled or Error message to the sender's mailbox.

    // Tip: In addition to "connected" and "disconnected" functions you will need a function "tranfserring"
    // that will correspond to the state of the actor when file transfer is in progress

    let sftpActor (clientFactory : IClientFactory) (mailbox: Actor<_>) =
        let rec loop () =
            actor {
                let! msg = mailbox.Receive()
                return! loop ()
            }
        loop()
