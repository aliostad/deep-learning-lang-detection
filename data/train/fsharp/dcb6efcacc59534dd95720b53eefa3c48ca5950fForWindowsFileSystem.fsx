

#nowarn "40"

////////////////////////////////////////////////////////////
//以下IO操作可能问题, 正确的方法是先遍历当前目录的文件，再遍历子目录
////////////////////////////////////////////////////////////
//Delete the directory of bin and obj

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

System.AppDomain.CurrentDomain.BaseDirectory

(*
let rootDirectoryInfo=DirectoryInfo @"D:\Common Workspace\Send\SBIIMS"
System.IO.Directory.GetDirectories    @"D:\Common Workspace\Send\SBIIMS"
*)
System.Environment.GetEnvironmentVariable("PATH")
//System.IO.File.co
//=========================================================


let sourPath= @"D:\Common Workspace\For Research\WX.Data.BusinessModuleTemplate"
let sourDirectory=DirectoryInfo sourPath
sourDirectory.Attributes<-FileAttributes.Normal  //Right
sourDirectory.Attributes<-FileAttributes.ReadOnly //Right

//---------------------------------------------------------------------------------------------
//Windwos文件系统的名称修改拷贝-*********包括目录名称和文件名称的修改
let RenameCopy (sourPath:string) (targetPath:string) (renameStr:string) (renamedStr:string)=
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory=new DirectoryInfo(targetPath) 
  let rec RenameCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,renameStr:string,renamedStr:string)=       
    for b in sourDirectory.GetFiles() do
      match b.IsReadOnly with 
      | x ->
          b.IsReadOnly<-false //It's needed
          b.CopyTo(Path.Combine(targetDirectory.FullName,b.Name.Replace(renameStr,renamedStr)),true) |>ignore
          b.IsReadOnly<-x
    for a in sourDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name.Replace(renameStr,renamedStr))  with
      | x ->  RenameCopy(a,x,renameStr,renamedStr)
  RenameCopy(sourDirectory,targetDirectory,renameStr,renamedStr) 
        
let sourPath= @"D:\Workspace\SBIIMS"
let targetPath= @"D:\Workspace\SBIIMS10100902"
RenameCopy sourPath targetPath  "Advance.JXC" "Advance.JXC"  

//---------------------------------------------------------------------------------------------
//Windwos文件系统 --拷贝并修改文件名, ********只修改文件名
let RenameFileCopy (sourPath:string) (targetPath:string) (renameStr:string) (renamedStr:string)=
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory= 
    match new DirectoryInfo(targetPath) with
    | x ->
        if x.Exists |>not then x.Create()
        x
  let rec RenameFileCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,renameStr:string,renamedStr:string)=       
    for b in sourDirectory.GetFiles() do
      match b.IsReadOnly with 
      | x ->
          b.IsReadOnly<-false //It's needed
          b.CopyTo(Path.Combine(targetDirectory.FullName,b.Name.Replace(renameStr,renamedStr)),true) |>ignore
          b.IsReadOnly<-x
    for a in sourDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name)  with
      | x ->  RenameFileCopy(a,x,renameStr,renamedStr)
  RenameFileCopy(sourDirectory,targetDirectory,renameStr,renamedStr) 

let sourPath= @"D:\Common Workspace\CopyWorkspace\ShangPin_Edit"
let targetPath= @"D:\Common Workspace\CopyWorkspace\BSBY_ShangPin_Edit"
RenameFileCopy sourPath targetPath  "UC_JH_CGJH_SPXZ_BJ" "UC_KC_BSBY_SP_Modify"  



//---------------------------------------------------------------------------------------------
//Windwos文件系统 --拷贝并修改文件名及内容, ********修改文件名和文件内容, ***只对平面文件
let FileModifyCopy (sourPath:string) (targetPath:string) (modifyStr:string) (modifiedStr:string)=
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory= 
    match new DirectoryInfo(targetPath) with
    | x ->
        if x.Exists |>not then x.Create()
        x
  let rec FileModifyCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,modifyStr:string,modifiedStr:string)=       
    for b in sourDirectory.GetFiles() do
      match File.ReadFile b.FullName with
      | x ->
          Path.Combine(targetDirectory.FullName,b.Name.Replace(modifyStr,modifiedStr))
          |>File.WriteFileCreateOnly (x.Replace(modifyStr,modifiedStr)) 
    for a in sourDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name)  with
      | x ->  FileModifyCopy(a,x,modifyStr,modifiedStr)
  FileModifyCopy(sourDirectory,targetDirectory,modifyStr,modifiedStr) 

let sourPath= @"D:\TempWorkspace\a1"
let targetPath= @"D:\TempWorkspace\a2"
FileModifyCopy sourPath targetPath  "BD_V_DJ_KH_XFSPHZ_AGHS" "BD_V_DJ_KH_XFSPHZ_AGHS_Advance"  

//已经可用新的方法实现
[
"_T_DJ_","_DJ_"
"_FT_DJ","_FDJ"
]
|>Seq.iteri (fun i (a,b)->
    FileModifyCopy (sourPath+string (i+1)) (sourPath+string (i+2))  a b
    System.Threading.Thread.Sleep(40000)
    )
//已经可用新的方法实现
[
"BJ_GHS","BJ_JHGL"
"BJ_WF","BJ_XSGL"
"BJJL_GHS","BJJL_JHGL"
"BJJL_WF","BJJL_XSGL"
"DJ_GHS","T_DJ_JHGL"
"DJ_KH","DJ_XSGL"
"DJ_WF","DJ_KCGL"
"DJSP_GHS","DJSP_JHGL"
"DJSP_KH","DJSP_XSGL"
"DJSP_WF","DJSP_KCGL"
"FKD_GHS","FKD_JHGL"
"FKD_JYJYF","FKD_JYGL"
"FKD_KH","FKD_XSGL"
"FKD_WF","FKD_KCGL"
"FKDKX_GHS","FKDKX_JHGL"
"FKDKX_JYJYF","FKDKX_JYGL"
"FKDKX_KH","FKDKX_XSGL"
"FKDKX_WF","FKDKX_KCGL"
"FYLB_GHS","FYLB_JHGL"
"FYLB_JYJYF","FYLB_JYGL"
"FYLB_KH","FYLB_XSGL"
"FYLB_WF","FYLB_KCGL"
"HTJL_GHS","HTJL_JHGL"
"HTJL_KH","HTJL_XSGL"
"JYFS_GHS","JYFS_JHGL"
"JYFS_JYJYF","JYFS_JYGL"
"JYFS_KH","JYFS_XSGL"
"JYFS_WF","JYFS_KCGL"
"JYLB_GHS","JYLB_JHGL"
"JYLB_JYJYF","JYLB_JYGL"
"JYLB_KH","JYLB_XSGL"
"JYLB_WF","JYLB_KCGL"
"JYLSH_JYTZ_GHS","JYLSH_JYTZ_JHGL"
"JYLSH_JYTZ_JYJYF","JYLSH_JYTZ_JYGL"
"JYLSH_JYTZ_KH","JYLSH_JYTZ_XSGL"
"JYLSH_JYTZ_WF","JYLSH_JYTZ_KCGL"
"JYTZ_GHS","JYTZ_JHGL"
"JYTZ_JYJYF","JYTZ_JYGL"
"JYTZ_KH","JYTZ_XSGL"
"JYTZ_WF","JYTZ_KCGL"
"LXJL_GHS","LXJL_JHGL"
"LXJL_KH","LXJL_XSGL"
"QFMX_GHS","QFMX_JHGL"
"QFMX_JYJYF","QFMX_JYGL"
"QFMX_KH","QFMX_XSGL"
"QFMX_WF","QFMX_KCGL"
"ZFLB_GHS","ZFLB_JHGL"
"YF_GHS","YF_JHGL"
"YF_KH","YF_XSGL"
]
|>Seq.iteri (fun i (a,b)->
    FileModifyCopy (sourPath+string (i+1)) (sourPath+string (i+2))  a b
    System.Threading.Thread.Sleep(1000)
    )

//---------------------------------------------------------------------------------------------
//Windwos文件系统 --拷贝并修改文件名及内容, ********修改目录名,文件名和文件内容, ***只对平面文件, 实现一个目录或一个文件多次替换
let ModifyCopy (sourPath:string,targetPath:string,directoryModifyStrOldNewGroups:(string*string) list,fileModifyStrOldNewGroups:(string*string) list) =
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory= 
    match new DirectoryInfo(targetPath) with
    | x ->
        if x.Exists |>not then x.Create()
        x
  let rec ModifyCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,directoryModifyStrOldNewGroups:(string*string) list,fileModifyStrOldNewGroups:(string*string) list)=       
    for b in sourDirectory.GetFiles() do
      match File.ReadFile b.FullName with
      | x ->
          match 
            fileModifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->r.Replace(u,v)) b.Name,
            fileModifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->r.Replace(u,v)) x with
          | y,z ->
              Path.Combine(targetDirectory.FullName,y)
              |>File.WriteFileCreateOnly z     
    for a in sourDirectory.GetDirectories() do
      match directoryModifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->r.Replace(u,v)) a.Name with
      | x ->
          match targetDirectory.CreateSubdirectory(x)  with
          | x ->  ModifyCopy(a,x,directoryModifyStrOldNewGroups,fileModifyStrOldNewGroups)
  ModifyCopy(sourDirectory,targetDirectory,directoryModifyStrOldNewGroups,fileModifyStrOldNewGroups) 

(
@"D:\TempWorkspace\FunctionNodeTemplate",  //sourDirectory
@"D:\TempWorkspace\FunctionNodeTemplate1",  //targetDirectory
[ //directoryModifyStrOldNewGroups
".JXC.KCGL.SPCF", ".JXC.KCGL.SPKB"
], 
[  //fileModifyStrOldNewGroups
"KCGL_SPCF","KCGL_SPKB"     
".JXC.KCGL.SPCF",".JXC.KCGL.SPKB"
]
)
|>ModifyCopy

//---------------------------------------------------------------------------------------------
//Windwos文件系统 --拷贝并修改文件名及内容, ********修改目录名,文件名和文件内容, ***只对平面文件, 实现一个目录或一个文件多次替换
//使用正则表达式
let ModifyCopyWithRegex (sourPath:string,targetPath:string,directoryModifyStrOldNewGroups:(string*string) list,fileModifyStrOldNewGroups:(string*string) list) =
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory= 
    match new DirectoryInfo(targetPath) with
    | x ->
        if x.Exists |>not then x.Create()
        x
  let rec ModifyCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,directoryModifyStrOldNewGroups:(string*string) list,fileModifyStrOldNewGroups:(string*string) list)=       
    for b in sourDirectory.GetFiles() do
      match File.ReadFile b.FullName with
      | x ->
          match 
            fileModifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->Regex.Replace(r,u,v)) b.Name,
            fileModifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->Regex.Replace(r,u,v)) x with
          | y,z ->
              Path.Combine(targetDirectory.FullName,y)
              |>File.WriteFileCreateOnly z     
    for a in sourDirectory.GetDirectories() do
      match directoryModifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->Regex.Replace(r,u,v)) a.Name with
      | x ->
          match targetDirectory.CreateSubdirectory(x)  with
          | x ->  ModifyCopy(a,x,directoryModifyStrOldNewGroups,fileModifyStrOldNewGroups)
  ModifyCopy(sourDirectory,targetDirectory,directoryModifyStrOldNewGroups,fileModifyStrOldNewGroups) 

(
@"D:\TempWorkspace\FunctionNodeTemplate",  //sourDirectory
@"D:\TempWorkspace\FunctionNodeTemplate1",  //targetDirectory
[ //directoryModifyStrOldNewGroups
"\s*(\w)\s*", ".JXC.KCGL.SPKB"
], 
[  //fileModifyStrOldNewGroups
"\s*(\w)\s*","KCGL_SPKB"     
"\s*(\w\W)\s*",".JXC.KCGL.SPKB"
]
)
|>ModifyCopyWithRegex

//---------------------------------------------------------------------------------------------
//Windwos文件系统 --拷贝并修改文件名及内容, ********修改文件名和文件内容, ***只对平面文件, 实现一个文件多次替换
let FileModifyCopy (sourPath:string,targetPath:string,modifyStrOldNewGroups:(string*string) list)=
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory= 
    match new DirectoryInfo(targetPath) with
    | x ->
        if x.Exists |>not then x.Create()
        x
  let rec FileModifyCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,modifyStrOldNewGroups:(string*string) list)=       
    for b in sourDirectory.GetFiles() do
      match File.ReadFile b.FullName with
      | x ->
          match 
            modifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->r.Replace(u,v)) b.Name,
            modifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->r.Replace(u,v)) x with
          | y,z ->
              Path.Combine(targetDirectory.FullName,y)
              |>File.WriteFileCreateOnly z 
    for a in sourDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name)  with
      | x ->  FileModifyCopy(a,x,modifyStrOldNewGroups)
  FileModifyCopy(sourDirectory,targetDirectory,modifyStrOldNewGroups) 

(
@"D:\TempWorkspace\a",    //sourDirectory
@"D:\TempWorkspace\a1",   //targetDirectory
[ //modifyStrOldNewGroups
"KCGL","JHGL"
])
|>FileModifyCopy

//---------------------------------------------------------------------------------------------
//使用正则表达式
//Windwos文件系统 --拷贝并修改文件名及内容, ********修改文件名和文件内容, ***只对平面文件, 实现一个文件多次替换
let FileModifyCopyWithRegex (sourPath:string,targetPath:string,modifyStrOldNewGroups:(string*string) list)=
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory= 
    match new DirectoryInfo(targetPath) with
    | x ->
        if x.Exists |>not then x.Create()
        x
  let rec FileModifyCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,modifyStrOldNewGroups:(string*string) list)=       
    for b in sourDirectory.GetFiles() do
      match File.ReadFile b.FullName with
      | x ->
          match 
            modifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->Regex.Replace(r,u,v)) b.Name,
            modifyStrOldNewGroups|>Seq.fold (fun (r:string) (u,v) ->Regex.Replace(r,u,v)) x with
          | y,z ->
              Path.Combine(targetDirectory.FullName,y)
              |>File.WriteFileCreateOnly z 
    for a in sourDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name)  with
      | x ->  FileModifyCopy(a,x,modifyStrOldNewGroups)
  FileModifyCopy(sourDirectory,targetDirectory,modifyStrOldNewGroups) 

(
@"D:\TempWorkspace\a",    //sourDirectory
@"D:\TempWorkspace\a1",   //targetDirectory
[ //modifyStrOldNewGroups
"\s*(\w+)\s*","\1"
])
|>FileModifyCopyWithRegex

//---------------------------------------------------------------------------------------------
//Windwos文件系统 --拷贝并修改文件名及内容, ********修改目录名,文件名和文件内容, ***只对平面文件
let ModifyCopy (sourPath:string) (targetPath:string) (fileModifyStr:string,fileModifiedStr:string) (directoryModifyStr,directoryModifiedStr)=
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory= 
    match new DirectoryInfo(targetPath) with
    | x ->
        if x.Exists |>not then x.Create()
        x
  let rec ModifyCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,fileModifyStr:string,fileModifiedStr:string,directoryModifyStr:string,directoryModifiedStr:string)=       
    for b in sourDirectory.GetFiles() do
      match File.ReadFile b.FullName with
      | x ->
          Path.Combine(targetDirectory.FullName,b.Name.Replace(fileModifyStr,fileModifiedStr))
          |>File.WriteFileCreateOnly (x.Replace(fileModifyStr,fileModifiedStr)) 
    for a in sourDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name.Replace(directoryModifyStr,directoryModifiedStr))  with
      | x ->  ModifyCopy(a,x,fileModifyStr,fileModifiedStr,directoryModifyStr,directoryModifiedStr)
  ModifyCopy(sourDirectory,targetDirectory,fileModifyStr,fileModifiedStr,directoryModifyStr,directoryModifiedStr) 

let sourPath= @"D:\TempWorkspace\a"
let targetPath= @"D:\TempWorkspace\a1"
ModifyCopy sourPath targetPath  ("_FZR","_YWY") ("FZR","YWY")  


//===================================================================

//Windwos文件系统--拷贝源目录下指定目录的所有文件 ----第二方案---Good
let CopyFiles (sourPath:string) (targetPath:string) (containsStr:string)=
  let sourDirectory=
    match DirectoryInfo sourPath with
    | x ->x.GetDirectories()|>Seq.filter (fun a->a.Name.Contains containsStr)
  let targetDirectory=new DirectoryInfo(targetPath) 
  let rec CopyFiles (sourDirectories:DirectoryInfo seq,targetDirectory:DirectoryInfo)= 
    for a in sourDirectories do 
      match targetDirectory.CreateSubdirectory(a.Name)  with
      | x ->
        for b in a.GetFiles() do
          b.CopyTo(Path.Combine(x.FullName,b.Name),true) |>ignore
        CopyFiles(a.GetDirectories(),x)
  CopyFiles(sourDirectory,targetDirectory) 
let sourPath= @"D:\Workspace\SBIIMS"
let targetPath= @"D:\Workspace\SBIIMS\WX.Data.BusinessModuleTemplate"
CopyFiles sourPath targetPath  "System"  

//---------------------------------------------------------------------------------------------

//Windwos文件系统--拷贝源目录下指定目录的所有文件--Not good
let CopyFilesTwoWay (sourPath:string) (targetPath:string) (containsStr:string)=
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory=new DirectoryInfo(targetPath) 
  let directoryLevel=ref 0
  let rec CopyFilesTwoWay (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,containsStr:string)= 
    if !directoryLevel<>0 then
      for b in sourDirectory.GetFiles() do
        b.CopyTo(Path.Combine(targetDirectory.FullName,b.Name),true) |>ignore
    if !directoryLevel=0 then 
      incr directoryLevel
      for a in sourDirectory.GetDirectories() do
        if a.Name.Contains containsStr then
          match targetDirectory.CreateSubdirectory(a.Name)  with
          | x ->CopyFilesTwoWay(a,x,containsStr)
    else
     for a in sourDirectory.GetDirectories() do
        match targetDirectory.CreateSubdirectory(a.Name)  with
        | x ->  CopyFilesTwoWay(a,x,containsStr)
  CopyFilesTwoWay(sourDirectory,targetDirectory,containsStr) 
        
let sourPath= @"D:\Workspace\SBIIMS"
let targetPath= @"D:\Workspace\SBIIMS\WX.Data.BusinessModuleTemplate"
CopyFilesTwoWay sourPath targetPath  "System"  


//===================================================================

//获取当前目录下的所有文件  Key, directoryInfo.DirectoryName, directoryInfo.Parent
//rootDirectoryInfo<-DirectoryInfo (rootDirectoryInfo.Parent.FullName+ @"\"+rootDirectoryInfo.Name)
//rootDirectoryInfo.Parent.FullName 无"\"后缀
//rootDirectoryInfo.GetDirectories().[0].FullName 无"\"后缀
let GetFileInfos =
  let mutable directoryPath= @"D:\Workspace\SBIIMS\WX.Data.DataAccessAdvance.JXC.ZHCX"
  match directoryPath with
  | EndsWithIn [@"\"; "/"]  x->directoryPath<-x.Remove(x.Length-1)
  | _ ->()
  let  rootDirectoryInfo=DirectoryInfo directoryPath
  let rec collectFileInfos (template:string) (directoryInfo:DirectoryInfo)=
    seq{
      for b in directoryInfo.GetFiles() do
        if b.Extension=".fs" then
          match rootDirectoryInfo,directoryInfo with
          | x,y when x.FullName<>y.FullName ->
              yield String.Format(template, y.FullName.Remove(0,x.FullName.Length+1) ,b.Name ) 
          | _ ->
              yield String.Format(template, String.Empty,b.Name ) 
      for a in directoryInfo.GetDirectories() do
        yield! collectFileInfos template a
      }
  rootDirectoryInfo
  |>collectFileInfos @"    <Compile Include=""{0}\{1}"" />"
  |>ObjectDumper.Write 


let GetFileNames =
  let mutable directoryPath= @"D:\TempWorkspace\a\WX.Data.BusinessDataEntitiesAdvance.JXC.ZHCX"
  match directoryPath with
  | EndsWithIn [@"\"; "/"]  x->directoryPath<-x.Remove(x.Length-1)
  | _ ->()
  let  rootDirectoryInfo=DirectoryInfo directoryPath
  let rec collectFileInfos (directoryInfo:DirectoryInfo)=
    seq{
      for b in directoryInfo.GetFiles() do
        if b.Extension=".fs" && b.Name.Remove(b.Name.Length-3).EndsWith("_Advance")|>not then
          yield String.Format( @"FileModifyCopy sourPath targetPath  ""{0}"" ""{0}_Advance""",b.Name)  
      for a in directoryInfo.GetDirectories() do
        yield! collectFileInfos a
      }
  rootDirectoryInfo
  |>collectFileInfos
  |>ObjectDumper.Write 

let x=new FileInfo( @"D:\TempWorkspace\a\WX.Data.BusinessDataEntitiesAdvance.JXC.ZHCX\BD_V_DJ_KH_XFSPHZ_AGHS.fs")
x.Name






//---------------------------------------------------------------------------------------------

let  DeleteBinObj (directoryPath:string)=
  let rootDirectoryInfo=DirectoryInfo directoryPath
  let rec DeleteDirectories (directoryInfo:DirectoryInfo)=
    for a in directoryInfo.GetDirectories() do
      match a with
      //| x when x.Name.Equals("WX.Data.CodeAutomation") || x.Name.Equals("WX.Data.Helper")->()
      | x when x.Name.Equals("bin") || x.Name.Equals("obj") ->x.Delete(true)
      | x -> DeleteDirectories x
  DeleteDirectories rootDirectoryInfo

let path= @"D:\Workspace\SBIIMS\WX.Data.BusinessModuleTemplate"
DeleteBinObj path   

//---------------------------------------------------------------------------------------------


//Windwos文件系统 --拷贝并修改指定代码文件的Encoding为UTF-8, 转换后代码出错？？应控制文件类型
let ModifyEncodingCopy (sourPath:string) (targetPath:string)=
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory= 
    match new DirectoryInfo(targetPath) with
    | x ->
        if x.Exists |>not then x.Create()
        x
  let rec ModifyEncodingCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo)=       
    for b in sourDirectory.GetFiles() do
      match b.Extension with
      | EqualsIn  [".xaml"] _ ->     //[".fs";".fsx";".fsi";".cs";".xml";".xaml";".txt";".fsproj";".csproj";".user"]  _ ->    //[".fs";".cs";".txt";".fsx";".fsi";".xml";".fsproj";".csproj";".user"]  
          match File.ReadFile b.FullName with
          | x ->
              Path.Combine(targetDirectory.FullName,b.Name)
              |>File.WriteFile x
      | _ ->
          b.CopyTo(Path.Combine(targetDirectory.FullName,b.Name),true) |>ignore
    for a in sourDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name)  with
      | x ->  ModifyEncodingCopy(a,x)
  ModifyEncodingCopy(sourDirectory,targetDirectory) 

let sourPath= @"D:\Common Workspace\CopyWorkspace\WX.Data"
let targetPath= @"D:\Common Workspace\CopyWorkspace\WX.Data1"
ModifyEncodingCopy sourPath targetPath  

System.Text.Encoding.ASCII.EncodingName
System.Text.Encoding.ASCII.BodyName
System.Text.Encoding.Unicode.EncodingName
System.Text.Encoding.GetEncoding(936)
System.Text.Encoding.GetEncoding(65001)
//---------------------------------------------------------------------------------------------

//从GB2312转换到UTF8, 正确, 只能转换一次，不能重复转化
let ConvertFileEncodingToUTF8 (sourPath:string)=
  let sourDirectory=DirectoryInfo sourPath
  let rec ConvertFileEncodingToUTF8 (sourDirectory:DirectoryInfo)=       
    for b in sourDirectory.GetFiles() do
      match b.Extension with
      | EqualsIn [".fs";".fsx";".fsi";".cs";".xml";".xaml";".txt";".fsproj";".csproj";".user"]  _ ->    //[".fs";".cs";".txt";".fsx";".fsi";".xml";".fsproj";".csproj";".user"]  
          File.ConvertFileEncodingToUTF8 b.FullName
      | _ ->()
    for a in sourDirectory.GetDirectories() do
      ConvertFileEncodingToUTF8(a)
  ConvertFileEncodingToUTF8(sourDirectory) 

let sourPath= @"D:\Common Workspace\CopyWorkspace\Testing"
ConvertFileEncodingToUTF8 sourPath  

//---------------------------------------------------------------------------------------------

let  ModiyCodeFile (directoryPath:string)=
  //ObjectDumper.Write directoryPath
  let rootDirectoryInfo=DirectoryInfo directoryPath
  let newCodePartOne= @"namespace WX.Data.ViewModelData
open System.Collections.Generic
open System.Windows
open System.Windows.Input
open Microsoft.FSharp.Collections
open WX.Data
open WX.Data.TypeAlias
open WX.Data.ClientHelper
open WX.Data.ViewModel
open WX.Data.BusinessEntities
open WX.Data.ServiceProxy.WS_SBIIMS

type"
  let newCodePartTwo= @"inherit WX.Data.ViewModel.{0}()"
  let rec foreachDirectories (directoryInfo:DirectoryInfo)=
    for a in directoryInfo.GetDirectories() do
      for b in a.GetFiles() do
        //ObjectDumper.Write b.Extension
        match b with
        | x when x.Extension.ToLower()=".fs" ->
            let  codeText=ref <| File.ReadFile x.FullName
            //ObjectDumper.Write x
            //ObjectDumper.Write !codeText
            codeText:=Regex.Replace(!codeText,@"[\W\w\s\n]*namespace[\w\s\.\/\n]*type\s",newCodePartOne.Trim()+" ",RegexOptions.Multiline)
            //ObjectDumper.Write !codeText
            match Regex.Matches(!codeText, "(?<=[\w\s\.\n]*type\s+)\w+((?=\s*\()|(?=\s*\=))",RegexOptions.Multiline)  with
            | y when y.Count>0 && y.[0].Groups.Count>0 ->
                let indent="  "
                String.Format(newCodePartTwo,y.[0].Groups.[0].Value)
                |>fun c ->codeText:=Regex.Replace(!codeText,@"^.*inherit\s[\w\W\s\n]*",indent+c,RegexOptions.Multiline)
                File.WriteFile !codeText x.FullName
            | _ ->()
        | x ->()
      foreachDirectories a
  foreachDirectories rootDirectoryInfo

let projectPath= @"D:\Workspace\SBIIMSClient\WX.Data.FViewModelData\FVM"
ModiyCodeFile projectPath


let testText= @"
//#I @""C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.0""
//open Systemopen System.Windowsopen System.Windows.Inputnamespace WX.Data.ViewModelData
open System.Collections.Generic
open System.Windows.Input
open Microsoft.FSharp.Collections
open WX.Data
open WX.Data.TypeAlias
open WX.Data.ClientHelper
open WX.Data.ViewModel
open WX.Data.BusinessEntities
open WX.Data.ServiceProxy.WS_SBIIMS

type FVM_KC_SPCB () = 
  inherit WorkspaceViewModel ()
  let getnull()=Unchecked.defaultof<_>
  let mutable _isUserControlEnable=true"
//let x=Regex.Matches(testText, "(?<=[.\n]*type\s+)\w+(?=\s*\()",RegexOptions.Multiline)
let x=Regex.Matches(testText, @"namespace[\w\s\n\.]*type\s",RegexOptions.None)
let x=Regex.Matches(testText, @"namespace[\w\s\n\.]*type\s",RegexOptions.None)
x.[0].Groups.[0].Value
////////////////////////////////////////////////////////////
 
let y=Regex.Replace(testText,@"[\W\w\s\n]*namespace[\w\s\.\/]*type\s"," ",RegexOptions.Multiline)




//Current
System.AppDomain.CurrentDomain.BaseDirectory



let directoryPath= @"D:\Workspace\SBIIMS\WX.Data.View.ViewModelTemplate\bin\Debug"
let assemblyDirectory=new DirectoryInfo(directoryPath)
assemblyDirectory.FullName
let file=assemblyDirectory.GetFiles()
file.[0].FullName
file.[0].Name
file.[0].Name.Remove(file.[0].Name.Length-file.[0].Extension.Length)

AppDomain.CurrentDomain.GetAssemblies().[0].FullName
AppDomain.CurrentDomain.GetAssemblies().[0].GetName().Name


//======================================================================
(*
DirectoryInfo.CopyTo Custom Extension in C# 3.0
Filed under: C# — Tags: C# 3.0 — stefanprodan @ 4:46 pm 
DirectoryInfo doesn’t have a method for recursive copying of files and subfoders from one root to another. The following code ads the CopyTo method to the DirectoryInfo class using the new C# 3.0 feature named code extensions.
    public static class Extensions
    {
        public static void CopyTo(this DirectoryInfo source, DirectoryInfo target)
        {
            if (!Directory.Exists(target.FullName))
            {
                Directory.CreateDirectory(target.FullName);
            }

            foreach (FileInfo fileInfo in source.GetFiles())
            {
                fileInfo.CopyTo(Path.Combine(target.ToString(), fileInfo.Name), true);
            }

            foreach (DirectoryInfo sourceSubDir in source.GetDirectories())
            {
                DirectoryInfo targetSubDir = target.CreateSubdirectory(sourceSubDir.Name);
                sourceSubDir.CopyTo(targetSubDir);
            }
        }
    }
*)
