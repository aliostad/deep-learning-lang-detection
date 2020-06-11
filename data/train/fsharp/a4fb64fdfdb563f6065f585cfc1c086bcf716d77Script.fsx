#I @"C:\Projects\FSharp.IO.FileSystem\src\FSharp.IO.FileSystem"
#I @"C:\Projects\FSharp.IO.FileSystem\src\FSharp.IO.FileSystem\bin\debug"
#r "Chessie"

#load "InternalTypes.fs"
#load "Path.fs"
#load "File.fs"
#load "Directory.fs"
#load "Globbing.fs"

open FSharp.IO.FileSystem

System.IO.Directory.SetCurrentDirectory("C:\\Birddog\\paket")

let sourceDir = @".\packages\bdswweb\web"
let destDir = @"dest"
let pattern = "**\*.*"

//Globbing.search sourceDir pattern

Globbing.copyTo sourceDir destDir pattern File.Overwrite