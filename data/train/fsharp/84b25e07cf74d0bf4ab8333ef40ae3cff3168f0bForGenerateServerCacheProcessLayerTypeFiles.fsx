//#I  @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\v3.0"

#r "System.dll"
#r "System.Windows.Forms.dll"
open System
open System.Text
open System.Text.RegularExpressions
open System.IO
open Microsoft.FSharp.Collections
open System.Windows.Forms
open System.Text.RegularExpressions

//It must load on sequence
#I  @"D:\Workspace\SBIIMS\SBIIMS_Assemblies\ClientDebug"
#I  @"D:\Workspace\SBIIMS\SBIIMS_Assemblies\UtilityDebug"
#r "WX.Data.Helper.dll"
#r "WX.Data.FHelper.dll"
#r "WX.Data.dll"
#r "WX.Data.CodeAutomation.dll"
#r "System.Windows.Forms.dll"

open WX.Data.Helper
open WX.Data.FHelper
open WX.Data.DataOperate
open WX.Data
open WX.Data.CodeAutomation
//=================================================================================

//#load @"D:\Workspace\SBIIMS\SBIIMS_Utility\WX.Data.CodeAutomation\AdvanceServerCacheProcessLayerTypeGenerator.fs"
//open WX.Data.CodeAutomation

//==============================================================
//为所有接口组件生成代码文件
(
"SBIIMS_JXC", //系统简称
@"D:\Workspace\SBIIMS\SBIIMS_JXC",  //接口文件目录名称
ThreePhaseGroup  //注意！！!！！！， JXC_GGXZ须单独处理
)
|>AdvanceServerCacheProcessLayerCoding.GenerateCodingFilesFromComponents
|>Seq.map (fun a->ObjectDumper.Write a; (Directory.GetParent a).FullName)
|>Seq.toArray
|>MSBuild.INS.BuildForServerCacheProcessLayers

[
@"D:\Workspace\SBIIMS\SBIIMS_JXC"
]
|>MSBuild.INS.BuildForServerCacheProcessLayers

(
"SBIIMS_JXC", //系统简称
@"D:\Workspace\SBIIMS\SBIIMS_JXC\JXC_JBXX_SPWH\WX.Data.IDataAccessAdvanceX.JXC.JBXX.SPWH",  //接口文件目录名称
ThreePhaseGroup  //注意！！!！！！， JXC_GGXZ须单独处理
)
|>AdvanceServerCacheProcessLayerCoding.GenerateCodingFilesFromComponents
|>ObjectDumper.Write

(
"SBIIMS_JXC", //系统简称
@"D:\Workspace\SBIIMS\SBIIMS_JXC\JXC_GGHC\WX.Data.IDataAccessAdvanceX.JXC.GGHC",  //接口文件目录名称
ThreePhaseGroup  //注意！！!！！！， JXC_GGXZ须单独处理
)
|>AdvanceServerCacheProcessLayerCoding.GenerateCodingFilesFromComponents
|>Seq.map (fun a->ObjectDumper.Write a; (Directory.GetParent a).FullName)
|>Seq.toArray
|>MSBuild.INS.BuildForServerCacheProcessLayers


(
"SBIIMS_JXC", //系统简称
@"D:\Workspace\SBIIMS\SBIIMS_JXC\JXC_GGXZ\WX.Data.IDataAccessAdvanceX.JXC.GGXZ",  //接口文件目录名称
TwoPhaseGroup  //注意！！!！！！， JXC_GGXZ须单独处理
)
|>AdvanceServerCacheProcessLayerCoding.GenerateCodingFilesFromComponents
|>Seq.map (fun a->ObjectDumper.Write a; (Directory.GetParent a).FullName)
|>Seq.toArray
|>MSBuild.INS.BuildForServerCacheProcessLayers

//数据访问层的接口代码
(
"SBIIMS_JXC", //系统别名
@"
  abstract GetJBXX_FJPWH_FJPTableView:BQ_JBXX_FJPWH_Advance -> BD_TV_JBXX_FJPWH_FJP_Advance[]
  abstract GetJBXX_FJPWH_FJPLBTableView:BQ_JBXX_FJPWH_Advance -> BD_TV_JBXX_FJPWH_FJPLB_Advance[]
"
)
|>AdvanceServerCacheProcessLayerCoding.GetDataAccessCodeText
|>Clipboard.SetText

//-----------------------------------------

(
"SBIIMS_Frame", //系统简称
@"D:\Workspace\SBIIMS\SBIIMS_Frame",  //接口文件目录名称
TwoPhaseGroup  //注意！！！
)
|>AdvanceServerCacheProcessLayerCoding.GenerateCodingFilesFromComponents
|>ObjectDumper.Write

