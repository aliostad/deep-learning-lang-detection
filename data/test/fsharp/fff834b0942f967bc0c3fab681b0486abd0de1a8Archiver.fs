(*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Andrew B. Johnson
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *)

namespace MBT

open MBT.Console
open MBT.Core
open MBT.Core.IO
open System
open System.IO

type internal Archiver() =
   inherit BaseStatelessActor()

   (* Private methods *)
   let rerootPath newRoot (fileEntry : FileEntry) =
      let filePath = fileEntry.Path
      let pathRoot = Path.GetPathRoot(filePath)
      let derootedPath = filePath.Replace(pathRoot, String.Empty)
      Path.Combine(newRoot, derootedPath)

   let calculateArchiveFilePath archivePath (fileToArchive : FileEntry) =
      let calculatedArchiveFilePath = rerootPath archivePath fileToArchive
      if calculatedArchiveFilePath = Path.Combine(archivePath, Constants.FileManifestFileName) then
         let fileNameWithoutExt = Path.GetFileNameWithoutExtension(fileToArchive.Path)
         let ext = Path.GetExtension(fileToArchive.Path)
         Path.Combine(archivePath, fileNameWithoutExt, "_archive_file", ext)
      else
         calculatedArchiveFilePath

   let createIntermediateDirectoryStructure filePath =
      if not <| File.Exists filePath then
         let fileName = Path.GetFileName(filePath)
         let directoryOnly = filePath.Replace(fileName, String.Empty)
         if not <| Directory.Exists directoryOnly then Directory.CreateDirectory directoryOnly |> ignore
   
   let copyFileIfNewer source dest =
      if File.Exists dest then
         let sourceWriteTime = File.GetLastWriteTimeUtc source
         let destWriteTime = File.GetLastWriteTimeUtc dest

         if sourceWriteTime > destWriteTime then
            File.Copy(source, dest, true)
      else
         File.Copy(source, dest, true)

   let tryCopy source dest =
      try
         createIntermediateDirectoryStructure dest
         copyFileIfNewer source dest

         true
      with
         | _ -> false

   let tryArchiveFile rootArchivePath sourceFile =
      let targetFilePath = calculateArchiveFilePath rootArchivePath sourceFile
      let result = tryCopy sourceFile.Path targetFilePath

      if result then 
         Some targetFilePath 
      else 
         puts <| sprintf "Unable to archive file: %s" sourceFile.Path
         None

   let backupFiles rootArchivePath files =
      let foldFunc state file = 
          let result = tryArchiveFile rootArchivePath file
          match result with
          | Some(targetFilePath) -> Map.add file targetFilePath state
          | None -> state

      puts "Beginning archive process"

      Seq.fold foldFunc Map.empty files

   let processMessage (msg : ActorMessage<StandardRequest>) =
      match msg.Callback with
      | Some(callback) -> 
         let backedUpFiles = backupFiles msg.Payload.RootArchivePath msg.Payload.Files
         let remainingFiles = Seq.except msg.Payload.Files (Map.keys backedUpFiles)
         callback <| ResponseMessage.Archiver({ Archived = backedUpFiles; Failed = remainingFiles })
      | _ -> failwith "Unable to callback"

   (* Public methods *)
   override __.ProcessStatelessMessage msg = 
      match msg with
      | Archiver(actorMessage) -> processMessage actorMessage
      | _ -> failwith "Unknown message"
