#nowarn "40"

//=========================================================

#r "System.dll"
#r "System.Windows.Forms.dll"
open System
open System.IO
open System.Text
open System.Text.RegularExpressions
open System.Windows.Forms
#I  @"D:\Workspace\SBIIMS\SBIIMS_Assemblies\ClientDebug"
#r "WX.Data.Helper.dll"
open WX.Data.Helper
#r "WX.Data.CodeAutomation.dll"
open WX.Data.CodeAutomation
#r "WX.Data.dll"
open WX.Data.ActiveModule


System.AppDomain.CurrentDomain.BaseDirectory

//===============================================================

//获取当前目录下的所有文件  Key, directoryInfo.DirectoryName, directoryInfo.Parent
//rootDirectoryInfo<-DirectoryInfo (rootDirectoryInfo.Parent.FullName+ @"\"+rootDirectoryInfo.Name)
//rootDirectoryInfo.Parent.FullName 无"\"后缀
//rootDirectoryInfo.GetDirectories().[0].FullName 无"\"后缀
let GetFileInfos =
  let mutable directoryPath= @"D:\Workspace\SBIIMS\WX.Data.FViewModel.JBXX/"
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

//---------------------------------------------------------------------------------------------

//Windwos文件系统的名称修改拷贝
let RenameCopy (sourPath:string) (targetPath:string) (renameStr:string) (renamedStr:string)=
  let sourDirectory=DirectoryInfo sourPath
  let targetDirectory=new DirectoryInfo(targetPath) 
  let rec RenameCopy (sourDirectory:DirectoryInfo,targetDirectory:DirectoryInfo,renameStr:string,renamedStr:string)=       
    for b in sourDirectory.GetFiles() do
      match b.IsReadOnly with 
      | x ->
          b.IsReadOnly<-false //It's needed
          b.CopyTo(Path.Combine(targetDirectory.FullName,b.Name.Replace(renameStr,renamedStr))) |>ignore
          b.IsReadOnly<-x
    for a in sourDirectory.GetDirectories() do
      match targetDirectory.CreateSubdirectory(a.Name.Replace(renameStr,renamedStr))  with
      | x ->  RenameCopy(a,x,renameStr,renamedStr)
  RenameCopy(sourDirectory,targetDirectory,renameStr,renamedStr) 
        
let sourPath= @"D:\Common Workspace\For Research\WX.Data.BusinessModuleTemplate"
let targetPath= @"D:\Common Workspace\For Research\WX.Data.BusinessModuleTemplateNiew"
RenameCopy sourPath targetPath  "System" "Link"  

//---------------------------------------------------------------------------------------------


//===============================================================
