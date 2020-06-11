#r "System.dll"
#r "FSharp.PowerPack.dll"
open System
open System.IO
open System.Text
open Microsoft.FSharp.Control
open System.Text.RegularExpressions
#I  @"D:\Workspace\SBIIMS\SBIIMS_Assemblies\ClientDebug"
#r "WX.Data.Helper.dll"
open WX.Data.Helper
#r "WX.Data.dll"
open WX.Data

//-------------------------------------------------------------------------------
//CopyFilesByCondition
let CopyFilesByCondition (sourceDirectoryPath:string,tartgetDirectoryPath:string,fileNameConditions:string seq, fileExtensionConditions:string seq) =
  let sourceDirectory=DirectoryInfo sourceDirectoryPath
  let targetDirectory=DirectoryInfo tartgetDirectoryPath
  let rec CopyFilesByCondition (sourceDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,fileNameConditions:string seq,fileExtensionConditions:string seq)=       
    for b in sourceDirectory.GetFiles() do
      match b.Name,b.Extension, b.IsReadOnly with 
      | StartsWithIn fileNameConditions _, EqualsIn fileExtensionConditions _,  x ->
          b.IsReadOnly<-false //It's needed
          b.CopyTo(Path.Combine(targetDirectory.FullName,b.Name),true) |>ignore
          b.IsReadOnly<-x
      | _ ->()
    for a in sourceDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name)  with
      | x ->  CopyFilesByCondition(a,x,fileNameConditions,fileExtensionConditions)
  CopyFilesByCondition(sourceDirectory,targetDirectory,fileNameConditions,fileExtensionConditions) 

//Client
(
@"D:\Workspace\SBIIMS\SBIIMS_Assemblies\ClientDebug",  //sourceDirectoryPath
@"E:\Workspace\SBIIMSClient",  //tartgetDirectoryPath
[
"WX.Data.WinMain"
"WX.Data.ServiceContracts"
"WX.Data.BusinessBase"
"WX.Data.BusinessData"
"WX.Data.BusinessEntities"
"WX.Data.BusinessQuery"
"WX.Data.Caching"
"WX.Data.FViewModel"
"WX.Data.View"
//---------------------------
"WX.Data.dll"  //特殊
"WX.Data.Helper"
"WX.Data.CClient"
"WX.Data.Security"
"WX.Data.Policy"
"WX.Data.CModule"
"WX.Data.Client"
//---------------------------
"MSDN.FSharp.Charting"
"FSharp.Charting"
"Microsoft.Windows.Shell"
"Microsoft.Practices"
"FSharp.PowerPack"
//-------------------------------
"RibbonControlsLibrary"
"WPF"
"Xceed"
],
[
".exe"
".Config"
".manifest"
".dll"
]
)
|>CopyFilesByCondition

//Server
(
@"D:\Workspace\SBIIMS\SBIIMS_Assemblies\ClientDebug",  //sourceDirectoryPath
@"E:\Workspace\SBIIMSServer",  //tartgetDirectoryPath
[
"WX.Data.WcfService"
"WX.Data.FaultContracts"
"WX.Data.MessageContracts"
"WX.Data.ServiceContracts"
"WX.Data.DataContracts"
"WX.Data.Business"
"WX.Data.IDataAccess"
"WX.Data.DataAccess"
"WX.Data.DatabaseDictionary"
"WX.Data.DataModel"
"SBIIMS"
//---------------------------
"WX.Data.DatabaseHelper"
"WX.Data.CloudHelper"
"WX.Data.ClientServerHelper"
"WX.Data.dll"  //特殊
"WX.Data.Server"
"WX.Data.Helper"
"WX.Data.Security"
"WX.Data.Policy"
"WX.Data.CModule"
//---------------------------
"Microsoft.Practices"
"FSharp.PowerPack"
],
[
".exe"
".Config"
".manifest"
".dll"
".ssdl"
".msl"
".csdl"
]
)
|>CopyFilesByCondition

//-------------------------------------------------------------------------------
//CopyFilesByExtensionCondition
let CopyFilesByExtensionCondition (sourceDirectoryPath:string,tartgetDirectoryPath:string, fileExtensionConditions:string seq) =
  let sourceDirectory=DirectoryInfo sourceDirectoryPath
  let targetDirectory=DirectoryInfo tartgetDirectoryPath
  let rec CopyFilesByExtensionCondition (sourceDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,fileExtensionConditions:string seq)=       
    for b in sourceDirectory.GetFiles() do
      match b.Extension, b.IsReadOnly with 
      | EqualsIn fileExtensionConditions _,  x ->
          b.IsReadOnly<-false //It's needed
          b.CopyTo(Path.Combine(targetDirectory.FullName,b.Name),true) |>ignore
          b.IsReadOnly<-x
      | _ ->()
    for a in sourceDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name)  with
      | x ->  CopyFilesByExtensionCondition(a,x,fileExtensionConditions)
  CopyFilesByExtensionCondition(sourceDirectory,targetDirectory,fileExtensionConditions) 

(
@"D:\Workspace\SBIIMS\SBIIMS_Assemblies\ClientDebug",  //sourceDirectoryPath
@"E:\Workspace\SBIIMSSingle",  //tartgetDirectoryPath
[
".exe"
".Config"
".manifest"
".dll"
".ssdl"
".msl"
".csdl"
]
)
|>CopyFilesByExtensionCondition