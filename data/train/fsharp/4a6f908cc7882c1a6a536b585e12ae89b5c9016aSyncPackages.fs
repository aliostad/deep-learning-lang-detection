module SyncPackages

open System.IO

let SourcePackages packageSourceDirectory  = 
    Directory.EnumerateFiles(packageSourceDirectory, "*.nupkg") |> Seq.map(fun s -> new FileInfo(s))

let TargetPackages packageTargetDirectory  = 
    Directory.EnumerateFiles(packageTargetDirectory, "*.nupkg") |> Seq.map(fun s -> new FileInfo(s))

let NotIn (packagesInTarget : seq<FileInfo>) packagesInSource : seq<FileInfo>  =       
    seq { for (s : FileInfo) in packagesInSource do 
                if not(Seq.exists(fun (x : FileInfo) -> x.Name=s.Name) packagesInTarget) then yield s }
      

let CopyTo (targetDirectory : string) (logger: string -> unit) (packages : seq<FileInfo>) = 
    let fullPackageName targetDirectory  packageName  =
       targetDirectory + "\\" + packageName

    packages |> Seq.iter (fun x -> 
                                try
                                    let newFile = fullPackageName targetDirectory x.Name                                
                                    logger ("Copying package " + x.FullName + " to " + newFile)                                
                                    File.Copy(x.FullName, newFile, true)
                                with
                                 | :? System.Exception as ex -> logger ("Failed copying package " + x.FullName + " to " + targetDirectory))

let DeletePackages (logger : string -> unit) (packages : seq<FileInfo>) =
    packages |> Seq.iter (fun x -> 
                            try
                                logger ("Deleting package " + x.FullName)
                                x.Delete()
                            with
                             | :? System.Exception as ex -> logger ("Failed deleting package " + x.FullName))

let SyncSourceAndTarget sourceDirectory targetDirectory logger =
    let packagesInTarget = TargetPackages(targetDirectory)
    let packagesInSource = SourcePackages(sourceDirectory)

    packagesInSource |> NotIn packagesInTarget |> CopyTo targetDirectory logger |> ignore
    packagesInTarget |> NotIn packagesInSource |> DeletePackages logger |> ignore

