#r "tools/FAKE/tools/FakeLib.dll"

#load "settings.fsx"

open System 
open Fake
open Fake.Testing
open Settings


let localNugetRepo="E:/Libs/nuget"

//relative to script
let nugetExeDir="tools"

let outDir=combinePaths currentDirectory <|"artifacts" 

let dotnet="dotnet.exe"

let nugetServer= "https://www.nuget.org/api/v2/package"

let restore (proj:string)= 
        let result = ExecProcessAndReturnMessages(fun c -> 
                                        c.FileName<-dotnet
                                        c.Arguments<- String.Format("restore \"{0}\"",proj)
                                        )
                                        (TimeSpan.FromMinutes 5.0)  
      
        result.ExitCode

let compile proj= ExecProcess(fun c -> 
                                        c.FileName<-dotnet
                                        c.Arguments<-("build "+proj+ " -c release"))
                                        (TimeSpan.FromMinutes 5.0)

let runTests dir=                           
    let result = ExecProcess(fun c -> 
                                        c.FileName<- dotnet
                                        c.Arguments<-("test  \""+dir+"\\Tests.csproj\""))(TimeSpan.FromMinutes 5.0)
    if result <> 0 then failwith "Tests fail!"


let pack proj =ExecProcess(fun c -> 
                                        c.FileName<-dotnet
                                        let build= if additionalPack.Length=0 then "--no-build" else ""
                                        //trace ("to build:" + additionalPack.Length.ToString() + build)
                                        c.Arguments<-("pack "+proj+" --include-symbols --include-source "+build+" -c Release -o "+outDir))(TimeSpan.FromMinutes 5.0)
let push file = ExecProcess(fun c ->
                            c.FileName<- (currentDirectory @@ nugetExeDir @@ "nuget.exe")
                            c.Arguments <- ("push "+ file+" -Source "+nugetServer))(TimeSpan.FromMinutes 5.0)
                       
                                                        
