

#r "WindowsBase.dll"
#r "PresentationCore.dll"
//#r "System.Configuration.dll"
#r "FSharp.PowerPack.Parallel.Seq.dll"
#r "System.ServiceModel.dll"
#r "System.Data.Entity.dll"
#r "System.Windows.Forms.dll"

//open System.Configuration
//open System.Collections.Generic
//open Microsoft.FSharp.Collections

//#r "Microsoft.Practices.EnterpriseLibrary.Validation.dll"
//open Microsoft.Practices.EnterpriseLibrary.Validation.Validators

open System.Windows
open System
open System.Net.NetworkInformation
open System.IO
open System.Runtime.Serialization.Formatters
open System.Runtime.Serialization.Formatters.Binary
open System.Runtime.Serialization
open System.Text
open System.Collections.Generic
open System.Collections
open System.Text.RegularExpressions
open System.Reflection
open System.Globalization
open System.Collections.Generic
open Microsoft.FSharp.Collections
open System.Collections.ObjectModel
open System.ServiceModel
open System.Windows.Forms
//open System.Data.Objects.DataClasses

//open Microsoft.Build.Execution.BuildManager.DefaultBuildManager.BeginBuild


#I  @"D:\Workspace\SBIIMS\SBIIMS_Assemblies\ClientDebug"
#r "WX.Data.Helper.dll"
open WX.Data.Helper
#r "WX.Data.dll"
open WX.Data

type Stream=string


(*
#r "WX.Data.DataModel.JXC.dll"
open WX.Data.DataModel
*)

//#r "WX.Data.ServiceContractsAdvance.AC.CZYJSGL.dll"
//open WX.Data.ServiceContracts

//open WX.Data.TypeExtensions
let watch=new System.Diagnostics.Stopwatch()
//==========================================================
watch.Reset()
watch.Start()
watch.Elapsed

[1]
|>Seq.sum

open Microsoft.FSharp

open Microsoft.FSharp.Collections
open Microsoft.FSharp.Control

[<AutoOpen>]
module TypeExtension=
    type System.Collections.Generic.Dictionary<'K,'V> with
      member this.AddKeyValue (keyValuePair:System.Collections.Generic.KeyValuePair<'K,'V>)=
        this.Add (keyValuePair.Key,keyValuePair.Value) 

    type seq<'T> with
        member xs.RepeatElements(n: int) =
            seq { for x in xs do for i in 1 .. n do yield x }


[<AutoOpen>]
module TypeExtensionX=
  [<System.Runtime.CompilerServices.Extension>]
  type ExtraCSharpStyleExtensionMethodsInFSharp () =
      [<System.Runtime.CompilerServices.Extension>]
      static member inline Sum(xs: seq<'T>) = Seq.sum xs



let listOfIntegers = [ 1 .. 100 ]
let listOfBigIntegers = [ 1I .. 100I ]
let sum1 = listOfIntegers.Sum()
let sum2 = listOfBigIntegers.Sum()


let x001=Array.zeroCreate<int> 1
x001.Length

type T00()=
  class end

type T01()=
  inherit T00()

type T02()=
  inherit T01()

type T03()=
  member val X:T02=Unchecked.defaultof<_> with get,set
  member val X1:int=0 with get,set

type T04()=
  member val X:T02[]=Unchecked.defaultof<_> with get,set

let t04=new T04()
t04.X<-[||]
t04.X<-[|new T02()|]

t04.X.GetType().IsArray

let x04=t04.X|>unbox<Array>
x04.Length

let t03=new T03()
t03.X<-new T02()
t03.X1<- 1
t03.GetType().GetProperty("X").PropertyType.IsAssignableFrom(typeof<T02>)
typeof<T00>.IsAssignableFrom(t03.GetType().GetProperty("X").PropertyType)
typeof<T01>.IsAssignableFrom(t03.GetType().GetProperty("X").PropertyType)
typeof<T02>.IsAssignableFrom(t03.GetType().GetProperty("X").PropertyType)
typeof<T03>.IsAssignableFrom(t03.GetType().GetProperty("X").PropertyType)

t03.GetType().GetProperty("X").PropertyType.IsSubclassOf(typeof<T00>)
t03.GetType().GetProperty("X").PropertyType.IsSubclassOf(typeof<T01>)
t03.GetType().GetProperty("X").PropertyType.IsSubclassOf(typeof<T02>)


let p01=t03.GetType().GetProperty("X")

t03.GetType().GetProperty("X").PropertyType.

p01.GetValue(t03):?>#T01
p01.GetValue(t03)|>unbox<#T01>

match p01.GetValue(t03) with
| :? T01 ->String.Empty
| _ ->"wx"

t03.X:>T01


let x=

let sb=new StringBuilder()
sb.AppendLine()|>ignore
String.IsNullOrWhiteSpace (string sb)

string "&lt;"

[false;true]|>Seq.sortBy (fun a->a|>not)


System.IO.Path.Combine (@"f:\WX\", "WX_Data\wx")

let x:string[]= null
for n in x do ()

seq{
  match 1 with
  | 2 ->yield 1
  | _ ->()
}
|>Seq.toArray

String.IsNullOrWhiteSpace "    d  "

type TA=
 {
 XA:int
 XB:string
 }

type TB=
 {
 YA:int
 YB:DateTime
 }

seq
  {
  yield 2, "a"
  yield 1, "b"
  yield 1, "b"
  yield 101, "c"
  yield 101, "c"
  yield 9, "c"
  yield 6, "d"
  yield 9, "c"
  yield 9, "c"
  yield 9, "c"
  yield 6, "d"
  }
|>Seq.sortBy (fun (a,_)->a)
|>Seq.groupBy (fun (a,_) ->a)

(
[
{XA=1;XB="1"}
{XA=2;XB="2"}
{XA=3;XB="3"}
]
,
[
{YA=3;YB=DateTime.Now}
{YA=4;YB=DateTime.Now}
]
)
|>fun (a,b)->
    PSeq.groupJoin a b (fun c->c.XA) (fun d->d.YA) (fun c d->c.XA,c.XB,match d|>PSeq.headOrDefault with Some x ->x.YB | _ ->new DateTime())
    |>Seq.append  (PSeq.groupJoin b a (fun c->c.YA) (fun d->d.XA) (fun c d->c.YA,(match d|>PSeq.headOrDefault with Some x ->x.XB | _ ->String.Empty), c.YB))
    |>Seq.length

let xa=Microsoft.FSharp.Linq.QueryBuilder()


  let rec GetNodes (nodes:int list) =
    seq{
      match nodes with
      | h::t ->yield h
      | _ ->()
    }
  GetNodes [1;2;3]

for (n1::n2) in [1;2;3] do
  ObjectDumper.Write n1


[1;2;3]
|>Seq.groupBy (fun a->match a with (1 | 3) ->1 | ( 2 |3) ->2)

let xc=String.Format ("{0} {1} {2}","aaa",null,"wx")
"aaa wx"

let xl:int [] =[||]
xl|>PSeq.min 

let sourceDirectoryPath= @"D:\Workspace\SBIIMS\SBIIMS_Assemblies\ClientDebug"

let b=FileInfo @"D:\Workspace\SBIIMS\SBIIMS_Assemblies\ClientDebug\Update\VersionDefinition.xml" 
b.FullName.Replace(sourceDirectoryPath,String.Empty).Replace(b.Name,String.Empty)
b.Directory.Parent

Path.Combine (sourceDirectoryPath, @"upate\xx\")

let xa=new Generic.Queue<Guid>(5)

for n in 0..10000 do
  //xa.TrimExcess()
  xa.Enqueue (Guid.NewGuid())

xa.Count
xa.Dequeue()
xa.TrimExcess()
xa.Peek()
xa

let x=new Generic.Stack<Guid>(5)
for n in 0..100 do
  x.Push (Guid.NewGuid())
x.Count
x.Peek()
match x|>Seq.tryFind (fun a->a=Guid.Parse("35268230-9235-4c87-b72b-8eb6a219cad9")) with
| Some y ->"wx"
| _ ->""

let xb=1,"wx"
match box xb with
| :? (int*string) as (z, x) ->()
| _ ->()

let xa=FileInfo @"H:\My Live\购物损坏照片\DSCN2257.JPG"
xa.Length

let xb=File.ReadAllBytes @"H:\My Live\购物损坏照片\DSCN2257.JPG"
xb.Length

let strA=null

let strB=""

strA=strB

let computerProperties = IPGlobalProperties.GetIPGlobalProperties()
let nics=NetworkInterface.GetAllNetworkInterfaces()
for n in  
  NetworkInterface.GetAllNetworkInterfaces()
  |>Seq.filter (fun a->a.NetworkInterfaceType=NetworkInterfaceType.Ethernet) do
  let address=n.GetPhysicalAddress()
  address.GetAddressBytes()
  |>Seq.fold (fun (acc:string) a ->match acc, a.ToString("X2") with x, y when x.Length>0 ->String.Format ("{0}-{1}",acc,y) | _ ,y ->y) String.Empty
  |>ObjectDumper.Write 

"""
""".Length

let strA= @"
 Query failed!
----------------------------------------------
Date Time:
2012/4/24 下午 5:31:30
----------------------------------------------
"
strA.Length

@"System Error".IndexOf("\n")

let myObj=""

let fm = new BinaryFormatter()
let ms  = new MemoryStream()
fm.Serialize(ms,myObj)
let bytes = ms.ToArray()
let str = Convert.ToBase64String(bytes,0,bytes.Length)
ms.Close()


let bytes=Convert.FromBase64String("AAEAAAD/////AQAAAAAAAAAGAQAAAAAL")
let msa=new MemoryStream(bytes)
let strOld=unbox<string> (fm.Deserialize msa)

let sb=new StringBuilder()
sb.Append("wx").Length
sb.ToString()="wx"
"wx".ToCharArray()

"wx wxsxxxx".ToCharArray()

let form=new Form()
form.Show()
form.TopMost<-true
form.TopMost<-false
form.Activate()

let now=System.DateTime.Now
string now
now.ToString("R")
let xa=now.ToString("MM/dd/yyyy HH:mm:ss.fff")

DateTime.Parse xa


"WX.Data.FViewModelAdvance.JXC.JBXX.ZCLBWH.dll"="WX.Data.FViewModelAdvance.JXC.JBXX.ZCLBWH.dll" && ""=""

"_xx_".Contains("_?_")

let y="wx"
Nullable y

let x =Nullable<Guid>()
x.GetValueOrDefault()


Nullable string

["1";"2";"3"]
|>Seq.fold (fun acc a->match acc with xa when xa<>String.Empty ->acc+"and"+a | _ -> acc+a) String.Empty

let x:int[]=[||]
x
|>PSeq.tryMaxBy (fun a->a)

let f (x:obj)=
  match x with
  | :? 1 -> "wx"
  | _ ->""

f 1


type XA()=
  member this.Load (a:int,?b:string,?c:byte)="---------"
  member this.LoadX (?para:obj)=
    match para with
    | Some (:? (int*byte) as x) ->
        match x with
        | xa, xb ->this.Load (xa,c=xb)
    | _ ->String.Empty
    
let x=new XA()
x.Load (1,c=1uy)
x.LoadX ((1,))




"wx".Replace ("d",String.Empty)

let xa:string= null
let x=box xa
match x with
| :? string  ->"wx"
| _ ->""

let Null()=Unchecked.defaultof<_>

string (Null())

null

let x=new Dictionary<string,string>()
x.Add ("a","wx1")
x.Add("b","wx2")
x.[0]


type X01()=
  member this.Child
    with get k=""
    and set k v=()

let xa=new X01()
let xb=xa

xa=xb

let x=new X01()
x.GetType().GetProperty("Child")

let x=XXX

string x


type x01()=
  member this.M01(?x)=()

  member this.Item 
    with get (key:string) ="wx"
  member this.Item
    with get (key:int)=1

let x=new x01()
x.["wx"]
x.[0]

let 

[for n in 1..40->"-"]|>Seq.fold (fun acc a->acc+a) String.Empty


open System.Diagnostics
match  new Process() with
| x ->
    x.StartInfo.UseShellExecute <- true;
    x.StartInfo.FileName <- @"C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
    x.StartInfo.CreateNoWindow <- true
    x.StartInfo.WindowStyle<-ProcessWindowStyle.Normal
    x.Start()

Process.Start(@"C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe",@"C:\Users\zhoutao\Documents\visual studio 2010\Projects\WpfApplication7\WpfApplication7\WpfApplication7.csproj"); 


type Type01()=
  abstract X01:string with get,set
  default this.X01
    with get()=""
    and set v=()
  abstract X02:string with get,set

let x01=new Dictionary<string,string>()

let x:string ref=ref null

let y="2x"
 
let x=[y;y+y]

let x=["1";"2"]

x@["3"]

x|>Seq.append ["3"]



let mutable x:string[]=[||]
x<-Null()
x|>Seq.toArray

Guid.NewGuid().ToString()
|>Clipboard.SetDataObject

new Guid()

String.IsNullOrWhiteSpace v

"string1JM".Substring(0,"string1JM".Length-"JM".Length)

let x =["1";"2";"3"]

let rec Test x=
  for n in x do
    if n="1" then ObjectDumper.Write n
    else 
      ObjectDumper.Write n

let rec Test x=
  match x with
  | h::t ->
      if h="3" then ObjectDumper.Write h
      else Test t
  //| h::[] ->() //if h="1" then ObjectDumper.Write h
  | [] ->()
  

Test x


match new T_DJ_JXCSH() with
| x ->
    match x.GetType().GetProperties(BindingFlags.Public ||| BindingFlags.Instance ||| BindingFlags.SetProperty) with
    | y ->
        //ObjectDumper.Write (y, 0)
        for a in y do
          if (a.PropertyType.IsValueType || a.PropertyType=typeof<string>)  then  ObjectDumper.Write a.PropertyType.Name
          //ObjectDumper.Write ((a.DeclaringType.Name,a.Name))

String.Empty.GetType().BaseType

Guid.NewGuid().GetType().IsValueType

Guid.NewGuid()

let x=DateTime.Now
x.AddDays (float 

type X=class end

let y:Type=null

Activator.CreateInstance(y):?>X

[
match new Guid() with
| x ->
    x
]

let x=new Dictionary<string,string>()
x.TryGetValue("wx")

Guid.NewGuid()
new Guid()

//主卧墙
let x1=4.5*3.15*2.0-2.0*0.9-3.6*2.0
let x2=3.3*3.15*2.0
let xm=x1+x2
let xj=xm/5.3|>decimal|>Decimal.Ceiling|>float
let xr=140.0*xj

8*140+6*90+6*48

//次卧墙
let y1=2.6*3.15*2.0-2.0*0.9
let y2=2.9*3.15*2.0-1.8*1.8
let ym=y1+y2
let yj=ym/5.3|>decimal|>Decimal.Ceiling|>float
let yr=90.0*yj

//顶
let xd=4.5*3.3+0.4*4.5*2.0
let yd=2.9*2.6
let zm=xd+yd
let zj=(zm/5.3|>decimal|>Decimal.Ceiling|>float)+1.0
let zr=48.0*zj+1.0

8.0*140.0+6.0*90.0+6.0*48.0


//施工费
//let wr=(xm+ym+zm)*8.0
let wr=(8.0+6.0+6.0)*40.0
 
//总面积
let vm=xm+ym+zm

//总费用
let v=xr+yr+zr+wr



20*2=40

let f x= 250.0*0.8*x**2.0

 250.0*0.8*0.8*0.8

 128.0/200.0

Guid.NewGuid()

let x=DateTime.Now.Ticks|>decimal

let x=new System.Windows.Forms.Form() 
x.TopMost<-true
x.Show()

let x:string=null
match x with
| NotNull y ->"wx"
| _ ->"xxxxxxxxxxx"



let x01=DefaultDateTimeValue
let x=1
let y=2
let r=x,y

let r1=[|x,y;x*3,y*4|]

let r2=[|x,y,x*y;x*2,y/2,y*3|]

r2.[0]

let r=[|1;2;3;8|]

r.[0],r.[1]

r.[2],r.[3]

r.[0]

let ``wx`` = "style"

let ``wx``=3

type ``T``()=
  member this.``X1``=0

let x01=new ``T``()
x01.X1


let sb=new StringBuilder()
sb.Length
let x=new DelegateEvent<EventHandler>()

x.Trigger

let x=new Event<EventHandler,EventArgs>(
let y=EventHandler.RemoveAll(x.Publish)

let y=new Event<EventHandler,EventArgs>()
x.Publish=y.Publish
Observable

let x:Event<EventHandler,EventArgs>=Null()

x=Null()


let  s1=
  [
  1;2;3
  ]

match "3" with
| NotEqualsInX ["1";"2"] _ ->"WX1"
| _ ->"WX2"


let  s2=
  [
  2
  ]


s1
|>Seq.append s2
|>Seq.groupBy
|>Seq.sum

PSeq.join s1 s2 (fun a->a) (fun b->b) (fun a b ->a,b)
|>Seq.length 



PSeq.groupJoin s1 s2 (fun a->a) (fun b->b) (fun a b ->a,b|>PSeq.headOrDefault)
|>Seq.length 

let x= 10
match x with
| EqualsInX [10;11] y ->"wx"
| _ ->""

type x01()=
  abstract Test:unit->unit
  default x.Test ()=ObjectDumper.Write "wx1"

type x02()=
  inherit x01()
  override x.Test()=
    base.Test()
    ObjectDumper.Write "wx2"

type x03()=
  inherit x02()
  override x.Test()=
    base.Test()
    ObjectDumper.Write "wx3"


match new x03() with
| x ->x.Test()



type BD_Paging()=
  static let DefaultPagingInfoIns= ObjectDumper.Write "wx"; new Guid()

  member this.Test()=BD_Paging.DefaultPagingInfoIns


BD_Paging.DefaultPagingInfoIns

match new BD_Paging() with
| x ->x.Test()

[2;3;4]
|>Seq.append [1;2;3]


3M/2M|>Decimal.Ceiling|>int

let DateTimeDefaultValue=new DateTime()

let DefaultDateTimeValue=DateTime.Parse("2011-05-22 00:00:00")
[
for a in 0..109 do
  yield a.ToString()
]

let xc=10
let x =
  ["0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "10"; "11"; "12"; "13";
   "14"; "15"; "16"; "17"; "18"; "19"; "20"; "21"; "22"; "23"; "24"; "25";
   "26"; "27"; "28"; "29"; "30"; "31"; "32"; "33"]
seq{
  let basePartSize=Seq.length x/xc
  let rePartSize=basePartSize+1 //第一次按整除分配之后，如有余数，则按加1进行补分
  let restPartSize=Seq.length x%xc
  for (entrySize,partIndex,partSize) in 
    seq{
        for partIndex in 0..restPartSize-1 do //(restPartSize-1)相当于能够多分到1的最大索引
          yield 0,partIndex, rePartSize    //分配起始数量，分配组索引，分配数量
        for partIndex in 0..(xc-restPartSize)-1 do
          yield rePartSize*restPartSize, partIndex, basePartSize 
    } do
    yield x|>Seq.skip (entrySize+partIndex*partSize) |>Seq.take partSize  
}
|>Seq.toArray



  let generateStamp =
    let count = ref 0
    (fun () -> count := !count + 1; !count)

generateStamp()

type ClosureTesting()=
  member this.generateStamp =
    let count = ref 0
    (fun () -> count := !count + 1; !count)

let ins=new ClosureTesting()
ins.generateStamp ()


type ClosureTesting=
  static member generateStamp =
    let count = ref 0
    (fun () -> count := !count + 1; !count)

ClosureTesting.generateStamp ()



let sourceDataMemory:string array ref=ref [||]
sourceDataMemory.Value

type Type01=
  static member GetColumnSchemal4Way=
    let sourceDataMemory:string array ref=ref [||]
    (fun () ->   
      let GetSourceData ()=
        ObjectDumper.Write "执行"
        sourceDataMemory:=[|"wx"|]
        sourceDataMemory.Value
      match sourceDataMemory.Value with
      | HasElement x-> x
      | _ ->GetSourceData ()
      )

Type01.GetColumnSchemal4Way "wsssss"


let GetColumnSchemal4Way=
    ObjectDumper.Write "执行"
    ["wx"]

GetColumnSchemal4Way

type Type01()=
  let GetColumnSchemal4Way01=
    ObjectDumper.Write "执行111111" 

  member this.GetColumnSchemal4Way=
    GetColumnSchemal4Way01|>ignore
    ObjectDumper.Write "执行"
    ["wx"]

  member this.GetColumnSchemal4Way111=
    let sourceDataMemory:string array ref=ref [||]
    (fun (tableName:string) ->      //Closures, 也可用静态字段来或属性来代替
      let GetSourceData ()=
        ObjectDumper.Write "执行"
        sourceDataMemory:=[|"wx"|]
        //ObjectDumper.Write sourceDataMemory.Value
        sourceDataMemory.Value
      ObjectDumper.Write sourceDataMemory.Value
      match sourceDataMemory.Value with
      | HasElement x-> x
      | _ ->GetSourceData ()
      )

let t01=new Type01()
t01.GetColumnSchemal4Way
t01.GetColumnSchemal4Way111 "wx"

Type01.GetColumnSchemal4Way



let GetColumnSchemal4Way=
  let sourceDataMemory:string array ref=ref [||]
  (fun (tableName:string) ->      //Closures, 也可用静态字段来或属性来代替
    let GetSourceData ()=
      ObjectDumper.Write "执行"
      sourceDataMemory:=[|"wx"|]
      sourceDataMemory.Value
    match sourceDataMemory.Value with
    | HasElement x-> x
    | _ ->GetSourceData ()
    )

GetColumnSchemal4Way "wsssss"


let memoize (f : 'a -> 'b) = 
  let dict = new Dictionary<'a, 'b>()
  let memoizedFunc (input : 'a) =
    match dict.TryGetValue(input) with
    | true, x -> x
    | false, _ ->
        // Evaluate and add to lookup table
        let answer = f input
        dict.Add(input, answer)
        answer
    // Return our memoized version of f dict is captured in the closure
  memoizedFunc

let sourceDataMemory:string list ref=Null()
sourceDataMemory.contents

let sourceDataMemory:string list ref=ref []

match sourceDataMemory.Value with
| HasNotElement x ->ObjectDumper.Write "x"
| _ ->() 

sourceDataMemory.Value
sourceDataMemory:= []
!sourceDataMemory

let generateStamp=
  let count = ref 0
  let f (wx:string)= count := !count + 1; !count
  f

generateStamp "wx"

let generateStamp (name:string)=
  let count = ref 0
  let f ()= count := !count + 1; !count
  f()
  count.Value


generateStamp ("name")

let generateStamp (para:string) =
  let count = ref 0
  (fun () -> count := !count + 1; !count)

generateStamp "wx"  





|>Seq.iter (fun a->ObjectDumper.Write a)




let sb=new StringBuilder()
let x=sb:>IDisposable

let dic =new Dictionary<_,_>()
dic.Add("string","System.String")
dic.Add("bool","System.Boolean")
dic.Add("byte","System.Byte")
dic.Add("int","System.Int32")
dic.Add("int16","System.Int16")
dic.Add("int32","System.Int32")
dic.Add("int64","System.Int64")
dic.Add("double","System.Double")
dic.Add("single","System.Single")
dic.Add("decimal","System.Decimal")
dic.Add("String","System.String")
dic.Add("Boolean","System.Boolean")
dic.Add("Byte","System.Byte")
dic.Add("Int16","System.Int16")
dic.Add("Int32","System.Int32")
dic.Add("Int64","System.Int64")
dic.Add("Double","System.Double")
dic.Add("Single","System.Single")
dic.Add("Decimal","System.Decimal")
dic.Add("DateTime","System.DateTime")
dic.Add("Guid","System.Guid")
dic.Add("string[]","System.String[]")
dic.Add("bool[]","System.Boolean[]")
dic.Add("byte[]","System.Byte[]")
dic.Add("int[]","System.Int32[]")
dic.Add("int16[]","System.Int16[]")
dic.Add("int32[]","System.Int32[]")
dic.Add("int64[]","System.Int64[]")
dic.Add("double[]","System.Double[]")
dic.Add("single[]","System.Single[]")
dic.Add("decimal[]","System.Decimal[]")
dic.Add("String[]","System.String[]")
dic.Add("Boolean[]","System.Boolean[]")
dic.Add("Byte[]","System.Byte[]")
dic.Add("Int16[]","System.Int16[]")
dic.Add("Int32[]","System.Int32[]")
dic.Add("Int64[]","System.Int64[]")
dic.Add("Double[]","System.Double[]")
dic.Add("Single[]","System.Single[]")
dic.Add("Decimal[]","System.Decimal[]")
dic.Add("DateTime[]","System.DateTime[]")
dic.Add("Guid[]","System.Guid[]")
dic
|>Seq.map (fun a->a.Value)
|>Seq.distinct
|>ObjectDumper.Write

[
"System.String"
"System.Boolean"
"System.Byte"
"System.Int32"
"System.Int16"
"System.Int64"
"System.Double"
"System.Single"
"System.Decimal"
"System.DateTime"
"System.Guid"
 ]

Decimal.MaxValue
Double.MaxValue.ToString() =Decimal.MaxValue.ToString()

box Double.MaxValue=box Double.MaxValue

Single.MaxValue


Int64.MaxValue=9223372036854775807L

Decimal.Parse(9223372036854775807L.ToString())


match (box 255uy) with
| :? Decimal ->ObjectDumper.Write "Decimal"
| _ ->()


@"VCS_GNZPQYZTID=2 | VC_ZPURI = /WX.Data.View.ViewModelTemplate.GGXZ;Component/VMT_GGXZ.xaml | VC_GJZPURI = /WX.Data.View.ViewModelTemplateAdvance.GGXZ;Component/VMT_GGXZ_Advance.xaml"
|>fun a->
    match Regex.Match(a,@"^\s*[a-zA-Z_]+\s*\=\s*([1-9]+)\s*\|\s*[a-zA-Z_]+\s*\=\s*([\w\W]+)\s*\|\s*[a-zA-Z_]+\s*\=\s*([\w\W]+)\s*$") with  // k1=a1|k2=a2|k3=a3
    | x when x.Groups.Count>3 ->
        match x.Groups.[1].Value.Trim(),x.Groups.[2].Value.Trim(),x.Groups.[3].Value.Trim() with
        | x1,x2,x3 -> x1,x2,x3
    | _ ->"","",""





let (|IsTrue|_|) (input:obj)=
  match input with
  | :? bool as x when x->Some ()
  | :? Nullable<bool> as x when x.HasValue && x.Value ->Some () 
  | _ ->None

match box true with
| _ ->ObjectDumper.Write "false"
| IsTrue ->ObjectDumper.Write "true"

(
@"  <PropertyGroup Condition=>
    <PlatformTarget>AnyCPU</PlatformTarget>
    <DebugType>pdbonly</DebugType>
    <Optimize>true</Optimize>
    <OutputPath>bin\Release\</OutputPath>
    <DefineConstants>TRACE</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <WarningLevel>4</WarningLevel>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include=""System"" />
    <Reference Include=""System.Data"" />
    <Reference Include=""System.Core"" />
    <Reference Include=""System.Xaml"" />
    <Reference Include=""WindowsBase"" />
    <Reference Include=""PresentationCore"" />
    <Reference Include=""PresentationFramework"" />
  </ItemGroup>"
,
@"^\s*\<Reference\s+Include\s*=\s*""(System)""\s*\/\>$"
,
@"$1"
)
|>fun (r,u,v)->
    Regex.Replace(r,u,v,RegexOptions.Multiline)

    Regex.IsMatch(a,b,RegexOptions.Multiline)  //RegexOptions.Multiline是必须的


let _EndpointName="Azure_WS_SBIIMS_AC_CZYJSGL_Advance" 
let serviceNamespaceDomain = ""
let serviceUri:Uri =Null()  // ServiceBusEnvironment.CreateServiceUri("sb", serviceNamespaceDomain, "WS_SBIIMS_AC_CZYJSGL_Advance")
let channelFactory:ChannelFactory<IWS_SBIIMS_AC_CZYJSGL_Advance> = Null()
let client:IWS_SBIIMS_AC_CZYJSGL_Advance = Null()


let sourceDirectory=DirectoryInfo @"D:\Workspace\SBIIMS\SBIIMS_AC1"
//sourceDirectory.Delete(

let x=Nullable<int>()
type y01()=
  member x.X01()=""

let x=Nullable<y01>()

let x:int []=[||]

x
|>PSeq.tryMaxBy(fun a->a) 

[
"wx"
"wx1"
"wx2"
]
|>Seq.fold (fun acc cx ->match acc with "" ->cx | _ ->String.Format("{0} {1}",acc,cx)) ""

[
"x1","x2"
"x3","x4"
"x5","x6"
]
|>Seq.fold (fun acc (cx,cy)->match acc with "" ->String.Format("{0}:{1}",cx,cy) | _ ->String.Format("{0},{1}:{2}",acc,cx,cy)) ""

type x01=
  abstract f:string*string*x:(string*(string*string))->string
  abstract f:(string*string)->string
  abstract fx: x:string* ?y:string ->string

@"abstract DeleteJSGNGL_JSGNForCurrentRole:BD_TV_JSGNGL_JSGN_Advance[]*BD_TV_JSGNGL_JSGN_Advance[]->BD_Result"
|>fun a->
   Regex.Match (a, @"^\s*abstract\s+([a-zA-Z_]+)\s*:\s*\(*\s*([a-zA-Z_\s\[\]\:\?\*\<\>]+)\s*\)*\s*\-\>\s*([a-zA-Z_\s\[\]]+)\s*.*$",RegexOptions.Singleline)       //1.数组[]前可以有空格, 2.已经考虑了可选参数 * ?Parameter,3已经考虑了泛型，4.参数不支持柯里化, 5,不支持多级元组参数类型，6. 已避免参数带括号的情况abstract f:(string*string)->string
| w when w.Groups.Count>3 ->

@"BD_TV_JSGNGL_JSGN_Advance[]*BD_TV_JSGNGL_JSGN_Advance[]"

|>fun a-> Regex.Split (a,@"\s*\*\s*",RegexOptions.Singleline) 

@"BD_TV_JSGNGL_JSGN_Advance[]"
|>fun a-> Regex.Split (a,@"\s*\:\s*",RegexOptions.Singleline) 

      seq{
        match Regex.Split (w.Groups.[2].Value,@"\s*\*\s*",RegexOptions.Singleline) with  //解析多个参数


  abstract AuditKCGL_SPBS:BD_T_DJ_KCGL* ?context:SBIIMS_JXCEntitiesAdvance* ?currentDateTime:DateTime* ?c_JYFS:byte ->BD_Result
@"abstract DeleteJSGNGL_JSGNForCurrentRole:BD_TV_JSGNGL_JSGN_Advance[] BD_TV_JSGNGL_JSGN_Advance[]BD_Result->"
|>fun a->
    Regex.Split(a,@"->")
    match Regex.Match (a, @"^\s*abstract\s+([a-zA-Z_]+)\s*:\s*\(*\s*([a-zA-Z_\s\[\]\:\?\*\<\>]+)\s*\)*\s*\-\>\s*([a-zA-Z_\s\[\]]+)\s*.*$",RegexOptions.Singleline) with 
    | x when x.Groups.Count>3->x.Groups.[6].Value
    | _ ->""
        
"  BD_TV_JSGNGL_JSGN_Advance[]  "
|>fun a->        
    Regex.Split (a,@"\s*\:\s*",RegexOptions.Singleline)

"             x  x       ".Replace(" ","")
"          x       x   ".Trim()

for i in 0..1 do
  ObjectDumper.Write i



let f:string array =[||]
let f ((x:string,y:string) seq)=10

let f (x:string)=x.ToUpper()

type X01()=
  [<DefaultValue>]
  val mutable _XY01:string
  member this.Y01
    with get ()= this._XY01
    and set v=this._XY01<-v


let Update (ins:X01)=
  ins.Y01<-"wx"

let xx01=new X01()
xx01|>Update
    


@"D:\Workspace\SBIIMS\WX.Data.FunctionAdvance.JXC.ZHGL.BJGL\WX.Data.View.JXC.ZHGL\View\CaiWuZongHe_Manage\XianJin_Bank\YinHangZhuanZhang\UC_ZH_CWGL_XJYH_ZZ_ButtonGroup.xaml"
|>String.length 

[|"string";"bool";"byte";"int";"int16";"int32";"int64";"double";"single";"decimal";
"String";"Boolean";"Byte";"Int16";"Int32";"Int64";"Double";"Single";"Decimal";"DateTime";"Guid";
"string[]";"bool[]";"byte[]";"int[]";"int16[]";"int32[]";"int64[]";"double[]";"single[]";"decimal[]";
"String[]";"Boolean[]";"Byte[]";"Int16[]";"Int32[]";"Int64[]";"Double[]";"Single[]";"Decimal[]";"DateTime[]";"Guid[]"|]
|>Seq.iter (fun a->
    match string (a.Chars 0) with //("wx"|>Seq.head).ToString()
    | x ->
        ObjectDumper.Write ( @"dic.Add("""+a+ @""",""System."+x.ToUpper()+a.Remove(0,1)+ @""")") 
    )
" ".ToUpper()


("wx"|>Seq.head).ToString()
string ("wx".Chars 0)+"wx"
let x01=Nullable<_> ()
x01.Value

let x01=new DateTime(2004,01,01)
x01.AddMonths(1).AddMilliseconds(-1.0)
x01.AddMonths(1).AddDays(-1.0)

type y02=
  {
  x01:int
  x02:int
  }

[
{x01=1,x02=3}
{x01=1,x02=0}
{x01=1,x02=0}
]
|>Seq.unfold (fun acc->a


|>fun a->
    for (am::_) in a do
      ObjectDumper.Write am 
      ObjectDumper.Write an

let x=new DateTime(2004,1,1)
x.AddMilliseconds(-1.0)

200101%100


seq{
  for b in 2001..2004 do
    for c in 1..12 do
      yield b*100+c
  }
|>ObjectDumper.Write

999998%100

[1;2].Length

[1;2]
|>Seq.nth 1

let x:int []=[||]
x|>Seq.toList

let x=[yield 1;yield 2;yield 3]
let x=[1;yield 2;3]
let x=[1; 2; 3]
let x=[|yield 1;yield 2;yield 3|]
let x=[|1;yield 2;3|]
let x=[|1; 2; 3|]
let x=seq{yield 1;yield 3}
let x=seq{1;3}

let x=1,2,3
let y=1,2,3
x+y

[x;y]
|>List.unzip
|>List.fold(fun (acc1,acc2,acc3) (a,b,c) ->acc1+a,acc2+b,acc3+c) (0,0,0)

let x="wx"
"_C_CJRQ_C_GXRQ".Split([|"_C_"|],StringSplitOptions.RemoveEmptyEntries)

let 周 涛=01
let 涛=02

周 涛

 

let x01=
   let x2=1
   let x3=1
   let x4=1
   if x2=x3=x4 then
     1
   else 0

let currentZWRQ=
  match DateTime.Now.ToString("yyyyMM") with
  | x ->decimal x

let currentZWRQ=
  match (DateTime.Parse ("2010-08-01")).ToString("yyyyMM") with
  | x ->decimal x

//Wrong
(
let fx ()=1,
let fy ()=1
)
|>fun (a,b) ->
  a()+b()

//Right
let fx ()=1
let fy ()=1
(
fx,
fy
)
|>fun (a,b) ->
  a()+b()


let x=1
match  x with
| 1 ->
  seq{
    for a in 0..1000 do
      yield a
  }
  
| _ ->seq[]


|>fun a ->
    ObjectDumper.Write a

let date=DateTime(2010,12,1)
date.AddMilliseconds(-1.0)

let a,b=2010,4
let date=DateTime(a,b,1)

DateTime.Now.Date

seq{
  //yield 12, DateTime.Parse("2010-10-27 12:47:10.000")
  yield 11, DateTime.Parse("2010-09-27 09:47:10.000")
  yield 12, DateTime.Parse("2010-10-21 09:47:10.000")
  yield 16, DateTime.Parse("2010-11-27 10:47:10.000")
  yield 18, DateTime.Parse("2010-12-27 11:47:10.000")
  yield 18, DateTime.Parse("2009-12-27 11:47:10.000")
}
|>Seq.groupBy (fun (_,a)->a.Year,a.Month)
//|>Seq.groupBy (fun (_,a)->a.Month)
|>Seq.length
//---------------------------------------------------------------
seq{
  //yield 12, DateTime.Parse("2010-10-27 12:47:10.000")
  yield 11, DateTime.Parse("2010-09-27 09:47:10.000")
  yield 12, DateTime.Parse("2010-09-21 09:47:10.000")
  yield 16, DateTime.Parse("2010-11-27 10:47:10.000")
  yield 18, DateTime.Parse("2010-12-27 11:47:10.000")
}
//|>Seq.groupBy (fun (a,_)->1)
//|>Seq.groupBy (fun (_,a)->DateTime.Parse("2010-10-27 12:47:10.000"))
|>Seq.groupBy (fun (_,a)->a.Date)
|>Seq.length
|>ObjectDumper.Write

|>Seq.iter (fun (_,a)->
   a
   |>ObjectDumper.Write 
   )


type type01=
  {
    x01:decimal
    x02:bool
    x03:bool
  }

watch.Reset()
watch.Start()
//c01
seq{
  for a in 0..1000000 do
    yield {x01=0.0M;x02=true;x03=true}
    yield {x01= -2356.0M;x02=false;x03=true}
    yield {x01=0.0M;x02=true;x03=true}
    yield {x01= 10000.0M;x02=false;x03=true}
}
|>Seq.sumBy (fun a-> a.x01)|>op_UnaryNegation   //5666
|>ObjectDumper.Write 
watch.ElapsedMilliseconds
|>ObjectDumper.Write

watch.Reset()
watch.Start()
//c01
seq{
  for a in 0..1000000 do
    yield {x01=10000.0M;x02=true;x03=true}
    yield {x01= -2356.0M;x02=false;x03=true}
}
|>Seq.filter (fun a->not a.x02 && a.x03) |>Seq.sumBy (fun a-> a.x01)|>op_UnaryNegation  //2541
|>ObjectDumper.Write 
watch.ElapsedMilliseconds
|>ObjectDumper.Write


watch.Reset()
watch.Start()
//c01
seq{
  for a in 0..1000000 do
    yield {x01=10000.0M;x02=true;x03=true}
    yield {x01= -2356.0M;x02=false;x03=true}
}
|>Seq.filter (fun a->a.x01>0M) |>Seq.sumBy (fun a-> a.x01)|>op_UnaryNegation  //3227
|>ObjectDumper.Write 
watch.ElapsedMilliseconds
|>ObjectDumper.Write


watch.Reset()
watch.Start()
//c01
seq{
  for a in 0..1000000 do
    yield {x01=0.0M;x02=true;x03=true}
    yield {x01= -2356.0M;x02=false;x03=true}
}
|>Seq.sumBy (fun a-> a.x01)|>op_UnaryNegation   //2668
|>ObjectDumper.Write 
watch.ElapsedMilliseconds
|>ObjectDumper.Write

watch.Reset()
watch.Start()
//c01
seq{
  for a in 0..1000000 do
    yield {x01=10000.0M;x02=false}
    yield {x01= -2356.0M;x02=true}
}
|>Seq.filter (fun a->a.x02) |>Seq.sumBy (fun a-> a.x01)|>op_UnaryNegation  //2595
|>ObjectDumper.Write 
watch.ElapsedMilliseconds
|>ObjectDumper.Write






watch.Reset()
watch.Start()
//c01
seq{
  for a in 0..1000000 do
    yield {x01= -2356.0M;x02=false}
    yield {x01= 10000.0M;x02=false}
}
//|>Seq.sumBy (fun a-> a.x01)|>op_UnaryNegation   //2280
//|>PSeq.sumBy (fun a->a.x01)   //2650
//|>PSeq.filter (fun a->not a.x02) |>PSeq.sumBy (fun a->a.x01)  //2630
//|>Seq.filter (fun a->not a.x02) |>Seq.sumBy (fun a-> a.x01)|>op_UnaryNegation  //2300
|>Seq.sumBy (fun a-> a.x01)|>op_UnaryNegation
//|>Seq.sumBy (fun (a,b)->a)  //1350
//|>Seq.filter (fun (_,a)->not a) |>Seq.sumBy (fun (a,_)->a)  //1300
//|>Seq.filter (fun a->a.x01<>0M) |>Seq.sumBy (fun a->a.x01)

|>ObjectDumper.Write 
watch.ElapsedMilliseconds
|>ObjectDumper.Write


//--------------------------------------------------------------

watch.Reset()
watch.Start()
seq{
  for a in 0..10000000 do
    yield 0.0M,true
}
//|>Seq.sumBy (fun (a,b)->a)  //1350
//|>Seq.filter (fun (_,a)->not a) |>Seq.sumBy (fun (a,_)->a)  //1300
|>Seq.filter (fun (a,_)->a=0M) |>Seq.sumBy (fun (a,_)->a)
|>ObjectDumper.Write 
watch.ElapsedMilliseconds
|>ObjectDumper.Write

let x01=1000|>op_UnaryNegation = -1000

let x01= -0M=0M

let x01= -11.009M

System.Globalization.NumberFormatInfo.InvariantInfo.NegativeSign
x01.ToString("{0:+0.0%;-0.0%}",CultureInfo.InvariantCulture)

let x01=237428.48+82253.07
319969.95-x01

318179.55-237428.48

319969.95-237428.48-82253.07

type T01=
  {
  x01:string
  x02:int
  }

watch.Reset()
watch.Start()
//let y01=
seq{
  for i in 0..100000 do 
    yield {x01=i.ToString() ;x02=100000-i}
}
//|>ObjectDumper.Write 
|>Seq.sortBy (fun a-> //(fun a->a.x01), 时间为3120,(fun a->a.x01,Null()) //时间为3700左右，10个"Null()"时为3950 
    match true with
    | true ->a.x01 
    | _ ->Null()
    ,
    match true with
    | true ->a.x02
    | _ ->Null()
    )
|>ObjectDumper.Write 
watch.ElapsedMilliseconds
|>ObjectDumper.Write


watch.Reset()
watch.Start()
//let y01=
seq{
  for i in 0..100000 do 
    yield {x01=i.ToString() ;x02=100000-i}
}
//|>ObjectDumper.Write 
|>Seq.sortBy (fun a->a.x01)
//|>Seq.sortBy (fun a->a.x02)
//|>Seq.sortBy (fun a->a.x01,Null()) //(fun a->a.x01), 时间为3120,(fun a->a.x01,Null()) //时间为3700左右，10个"Null()"时为3950 
|>ObjectDumper.Write 
watch.ElapsedMilliseconds
|>ObjectDumper.Write


watch.Reset()
watch.Start()
//let y01=
[
yield {x01="01";x02=5}
yield {x01="01";x02=4}
yield {x01="02";x02=4}
yield {x01="03";x02=3}
yield {x01="04";x02=2}
yield {x01="05";x02=1}
]
//|>ObjectDumper.Write 
|>Seq.sortBy (fun a->a.x01,Null())
|>ObjectDumper.Write 

String.replicate 0 " "

["wx";"wx1";"wx2"]
|>String.concat ";" 

let rec replicate (amount:int) (str:string) =
  match amount with
  | 0 ->str
  | _ ->replicate (amount-1) str+str

let x=replicate 1 " "



[
//for i=1 to 10 do
for i in 0..10 do
  yield " "
]
|>String.Concat

[
//for i=1 to 10 do
for i in 0..10 do
  yield " "
]
|>Seq.fold (fun acc a->acc+a) ""  //其中末尾""为入参acc的初始值，入参a为序列的遍历元素

}

let x=' '*2

let mutable x=10
let mutable y=10
(x,y)<-(20,30)

let date=DateTime.Parse ("2010-12-01 23:59:59")
date.Date

DateTime.Now.Date

let x005=new DateTime()

let x004=
  seq{
    for i=0M to 10000000M do
      yield i
  }


watch.Reset()
watch.Start()
x004|>PSeq.length
watch.Stop()
watch.ElapsedMilliseconds
|>ObjectDumper.Write


//-------------------------------------------------------------------------------------------------
let x001=
  seq{
    for i=0 to 1000000 do
      yield Guid.NewGuid()
      yield DefaultGuidValue
  }
//|>Seq.toArray

let x002=
  seq{
    for i=0 to 1000000 do
      yield new Nullable<Guid>(Guid.NewGuid())
      yield new Nullable<Guid>()
  }
//|>Seq.toArray

let x003=
  seq{
    for i=0 to 1000000 do
      yield true
      yield false
  }
//|>Seq.toArray

watch.Reset()
watch.Start()
x001
|>Seq.map (fun a->a=DefaultGuidValue)
|>Seq.toArray
watch.Stop()
watch.ElapsedMilliseconds
|>ObjectDumper.Write

watch.Reset()
watch.Start()
x002
|>Seq.map (fun a->a.HasValue)
|>Seq.toArray
watch.Stop()
watch.ElapsedMilliseconds
|>ObjectDumper.Write

watch.Reset()
watch.Start()
x003
|>Seq.map (fun a->a)
|>Seq.toArray
watch.Stop()
watch.ElapsedMilliseconds
|>ObjectDumper.Write


let s="1,2,3,4,5,6"
let [|r1;g1;b1;r2;g2;b2|] = s.Split[|','|] |> Array.map byte

let x=decimal  "10000000000000000000000000000"
int x
int x

int "10000000000"

byte x
byte 257000000000.0

int 233432423423423423423.000006

Guid.NewGuid()

let x01:string*Guid[]="sssss",null
match x01:>obj with
| :? (string*Guid[]) as x   ->"wx"
| _ ->"-00000"

let x01:string*Guid[]="sssss",null
match x01 with
| Null ->"wx"
| _ ->"-00000"

match 

null|>string|>String.IsNullOrWhiteSpace
[||]|>string|>String.IsNullOrWhiteSpace
Guid.NewGuid()

let name="wx"

match "wx" with
| name ->ObjectDumper.Write name
| _ ->()


let x=new Uri("/wx;Component/wx.xaml",System.UriKind.Relative)
Uri.TryCreate ("/wx;Component/wx.xaml",System.UriKind.Relative)
System.Windows.Application.


let x=[""]
for a b in x do
  ObjectDumper.Write a

  Int32.MaxValue
  Int32.MinValue

  Decimal.MaxValue
  Decimal.MinValue

  Int64.MaxValue
  Int64.MinValue


let x=
  1=2 && 2=3
  || 
  2=2  && 2=1


let x=9223372036854775808
let x=Int64.MaxValue
let x=Double.MaxValue
let x=Decimal.MaxValue
type System.Text.StringBuilder with
  member inline x.AppendIn (input:^a)=
    x.Append input|>ignore

  member inline x.AppendFormatIn (format:string,args:obj ref [])=
    x.AppendFormat(format,args)|>ignore

let x=StringBuilder()
x.AppendIn ("wx")
x.AppendIn(1)
x.ToString()
x.AppendFormatIn("{0}","wx")



match []  with
| HasNotElementIn [] _ ->true
| _ ->false

let x=Array.zeroCreate<string> 0
x
|>PSeq.map (fun a->a)
|>PSeq.find (fun a->a="")
["1"]

x
|>PSeq.exists (fun a->a="")
|>PSeq.find (fun a->a="")

let Get=
  let x=ref 0
  (fun ()->x:= !x+1; !x)
Get()


type Y =
  static member Get ()=
    let Get=
      let x=ref 0
      (fun ()->x:= !x+1; !x)
    Get()

 Y.Get()


let x:obj=null
let f (x:obj)=
  match x:?>DateTime with
  | x ->()
f null


let x:obj=null
let f (x:obj)=
  match x with
  | :? DateTime ->()
  | _ ->()

f null

x:?>DateTime

match DateTime.Now.Date with
| x ->
  x.AddDays(-1.0),x.AddDays(-1.0)

DateTime.Now.Date.AddMonths(-1)

match DateTime.Now with
| x -> 
  new DateTime(x.Year,x.AddMonths(-1).Month,1), (new DateTime(x.Year,x.Month,1)).AddDays(-1.0)
  //new DateTime(x.Year,x.Month,1)

new DateTime(DateTime.Now.Year
DateTime.Now.Date.Year

let x =new StringBuilder()
x.Insert(0,"wx")
x.ToString()

let x=new DateTime()
let y =new DateTime()
x=y

let z x=
  let y=new DateTime() 
  match x with
  | ""->()
  | _ ->()

let x =new Nullable<int>()
x=1

type y=
  member x.x z (c,?y)=()

System.Guid.NewGuid()

type IX=
  abstract y:int*int option->int

let f (wx:int,?wx2)=1

let x=Array.zeroCreate<string> 1
x.[0]

let mutable y=""
let x=Array.zeroCreate<string> 0
if x.Length=1 && x.[0]<>"" then y<-"wsss"   //Right
if x.[0]<>""  && x.Length=1 then y<-"wsss"  //Wrong

[ match new String('x') with x->x]

let x=new StringBuilder()
x.AppendLine("=====================================================================================================================================================================================================================================================================================================================")
x.ToString()

type DataAccessAction=
  | GetEntities 
  | GetEntitiesAdvance
  override this.ToString()=
    match this with
    | GetEntities ->"GetEntities"
    | GetEntitiesAdvance ->"GetEntitiesAdvance"

DataAccessAction.GetEntities.ToString()

String.Empty.Insert(0,"wx".ToString())

type t=
  {
    mutable r1:string
  }
[{r1="wx1"};{r1="wx2"}]
|>PSeq.map (fun a->a.r1<-"wx7";a)

let x =new Nullable<bool>()
match x with
| null ->()
| _ ->()

let x1,y1=Int32.TryParse "wx"

String.tr

let Option xth=match xth:>obj with :? int as x ->x | _ ->0
Option "3"

let ya ="1"
((1 :> obj) :? int)

match box ya with 
| :? int as x ->()
| _ ->()

[0]
[yield 0;match ya:>obj with :? int as x ->yield x | _ ->()]

[0;match ya:>obj with :? int as x ->yield x | _ ->()]

string (1-2)

let x=ref 1M
incr x


let x=DateTime.Parse("2010-05-02 17:27:50.557")
let y=DateTime.Parse("2010-05-02 18:27:50.557")
x.ToString("yyyyMMddhh")
y.ToString("yyyyMMddhh")
x.Date=y.Date

let x=1000000000
let x=1M
x.ToString("D2")
x.ToString("D8")

round 1.0001M

System.Math.Round(1.0001M,0)

let str:string =null
match str,str.Contains("x") with
| null,_ ->()
| _ ->()

Array.zeroCreate<int> 0
|>PSeq.sumBy (fun a->a)
|>PSeq.tryMinBy (fun a->a)

let y=10
let z=4
let maxValueString=
  match 10.0**float (y-z)-10.0**float -z with
  | x ->string x

Console.WriteLine("{0:C2}", 12.20000)

Console.WriteLine("{0:F0}", 12.20000)

(box "12.2").ToString("N")

let rec AppendString infix (input:string list)= 
  match input with
  | [] ->String.Empty
  | h::[] ->h
  | h::t ->h+infix+AppendString infix t 

AppendString "->" ["wx";"wx2";"wx3"]

//---------------------------------------------------------------------------------------------------

let splitToDecimal (separators:char []) (input:string) =
  match input with
  | x when String.IsNullOrWhiteSpace x ->seq []|>PSeq.ofSeq 
  | _ ->
      input.Split(separators,StringSplitOptions.RemoveEmptyEntries)
      |>PSeq.map (fun a->decimal a) 


let splitToNums<'a when 'a:>System.IConvertible > (separators:char []) (input:string) =
  match input with
  | x when String.IsNullOrWhiteSpace x ->seq []|>PSeq.ofSeq 
  | _ ->
      input.Split(separators,StringSplitOptions.RemoveEmptyEntries)
      |>PSeq.map (fun a->
          match 'a with
          | :? decimal ->decimal a
          | _ >0
      ) 



let inline splitToNums (separators:char []) (input:string):^T =
  

//Right Reference
let splitToNums (separators:char []) (input:string) =
  match input with
  | x when String.IsNullOrWhiteSpace x ->seq []|>PSeq.ofSeq 
  | _ ->
      input.Split(separators,StringSplitOptions.RemoveEmptyEntries)
      |>PSeq.map (fun a->decimal a) 

"1|2"|>splitToNums [|'|'|] //right

//Wrong Reference
let splitToNums (toTypeCode:TypeCode) (separators:char []) (input:string) =
  match input with
  | x when String.IsNullOrWhiteSpace x ->seq []|>PSeq.ofSeq 
  | _ ->
      input.Split(separators,StringSplitOptions.RemoveEmptyEntries)
      |>PSeq.map (fun a->System.Convert.ChangeType(a,toTypeCode) 

//Wrong Reference
let splitToNums<'a when 'a:>System.IComparable and 'a:>System.IConvertible > (separators:char []) (input:string) =
  match input with
  | x when String.IsNullOrWhiteSpace x ->seq []|>PSeq.ofSeq 
  | _ ->
      input.Split(separators,StringSplitOptions.RemoveEmptyEntries)
      |>PSeq.map (fun a->box a|>unbox<'a>) 
      //|>PSeq.map (fun a->System.Convert. a)

box "12"|>unbox<int>

System.Convert.ChangeType("12",TypeCode.Decimal)

null|>splitToNums<decimal> [|'|'|]
"1|2"|>splitToNums<decimal> [|'|'|]
let x=new System.Converter<string,'a>(fun b -> )
x.Invoke(




"WX"

//-------------------------------------------------------------------------------------------------
let c=new ObservableCollection<int>()
c.Clear()
c.Add(5)
c.Insert (1,2)
c.IndexOf 5


//-------------------------------------------------------------------------------------------------

let  dic=new Dictionary<string,string>()
("wx","wx")|>dic.Add

//-------------------------------------------------------------------------------------------------


let x01:string []=[||]
let x02:string []=null

 x01|>PSeq.iter (fun a->())



//-------------------------------------------------------------------------------------------------

//Seq List Array
[|"wx";"wx"|]|>PSeq.collect (fun a->[a;a])
[|"wx";"wx"|]|>PSeq.choose (fun a-> Some a)
[|1;2|]|>PSeq.fold (fun a b->a+b) 1       //1为基数，a 前一个元素，b 为后一个元素
[|1;2;0|]|>PSeq.sortBy (fun b->b) //Asc  //right
[|1;2;0|]|>PSeq.sortBy (fun b-> -b) //Desc //right
[|1;2;0|]|>PSeq.sortBy (~-) //Desc  Right
[|"wx1";"wx2"|]|>PSeq.sortBy (fun b-> (b+"1").CompareTo b)   //not right
["wx1";"wx2"]|>List.sortWith (fun a b->b.CompareTo a )  //Desc right

type r={x1:string;x2:string}

[
  {x1="wx1";x2="10"}
  {x1="wx3";x2="2"}
  {x1="wx4";x2="3"}
  {x1="wx2";x2="30"}
]
//|>PSeq.sortBy (fun a->(a.x1+"1").CompareTo a.x1)  //Desc, not right
//|>PSeq.sortBy (fun a->a.x1.CompareTo a.x1)    //Desc. Right,  ???
|>PSeq.sortBy (fun a->a.x1) //Asc

//-------------------------------------------------------------------------------------------------


byte "周涛"
int '涛'

int '周'

'涛'.CompareTo '周'


"wx1".CompareTo "wx2"

let x=Array.zeroCreate<string> 0
x.Length

5.0.ToString("C2", CultureInfo.CurrentCulture)

"中位".Length

let r=Regex.IsMatch("500Ml*",@"^[^\+\*\u4e00-\u9fa5]+$")
let r=Regex.IsMatch("w32243242",@"^([a-zA-Z]+[a-zA-Z0-9\.\/\-\b\\]*)|([a-zA-Z0-9\.\/\-\b\\]*[a-zA-Z]+)$")
let r=Regex.IsMatch("mjdlkf5",@"^([a-zA-Z]+[0-9\.\/\-\b\\]+[a-zA-Z]*)|([a-zA-Z]*[0-9\.\/\-\b\\]+[a-zA-Z]+)$")


DateTime.Now
|>fun a->
     //a.ToString("G")
     a.ToString("yyyy'-'MM'-'dd HH':'mm':'ss'Z")
     |>ObjectDumper.Write

"IsDefault"+"IsCheckedVC_FZR".Remove(0,9)
"wx".ToLowerInvariant().StartsWith

byte Visibility.Visible
byte Visibility.Hidden
byte Visibility.Collapsed
let mutable x=Visibility.Visible
x<- (box 1uy:?>Visibility)

"wx".StartsWith (null)

let d04=new Nullable<DateTime>()
let d03=new DateTime()
let d02=DateTime.Parse "2010-03-06"
d02.Hour
d02.Minute
d02.Second
d02.Millisecond

d02.AddDays(1.0).AddMilliseconds(-1.0)


let d01=DateTime.Parse "2010-03-06 22:55:16.630"
d01.ToString()
d01.ToLongDateString()
d01.ToLongTimeString()  
d01.ToUniversalTime()

|>fun a->
  a.AddDays(1.0).AddMilliseconds(-1.0) |>ignore
  a
  //a.ToString()


(*
"wx".Split [|','|]


let x02="wx"
x02.StartsWith(

null:?> Nullable<int>

type x()=
  member x.Y with get ()=new Nullable<int>()

x.GetType()

x.GetType().GetProperty("Y").GetValue(x,null)

DateTime.Now

let mutable x01=new System.Nullable<bool>()
x01 <-true

let x01=System.Nullable<decimal>(1M)
let x02=System.Nullable<decimal>()
x01.Equals(x02)

type BQ_BJJL_GHS()=
  let mutable _C_BJ=new System.Nullable<System.Decimal>()
  let mutable _C_BJSecond=new System.Nullable<System.Decimal>()
  member x.C_BJ
    with get ()=_C_BJ 
    and set (v:Nullable<decimal>)=
      if v.HasValue then
          if _C_BJSecond.HasValue|>not ||  _C_BJSecond.Value>=v.Value|>not then
            x.C_BJSecond<-v
          _C_BJ<-v
  member x.C_BJSecond 
    with get ()=_C_BJSecond 
    and set v=
      match v with
      | y when y.HasValue->
          if _C_BJ.HasValue |>not then
            x.C_BJ<-y
            _C_BJSecond<-y
          elif  y.Value>=_C_BJ.Value |>not  then 
            _C_BJSecond<-_C_BJ
          else _C_BJSecond<-y 
      | _ ->()

type BQ_BJJL_GHS()=
  [<DefaultValue>]
  val mutable _C_BJ:System.Nullable<System.Decimal>
  [<DefaultValue>]
  val mutable _C_BJSecond:System.Nullable<System.Decimal>
  member x.C_BJ
    with get ()=x._C_BJ 
    and set (v:Nullable<decimal>)=
      if v.HasValue then
          if x._C_BJSecond.HasValue|>not then
            x.C_BJSecond<-v
            x._C_BJ <-v 
          elif x._C_BJSecond.Value>=v.Value|>not then
            x._C_BJ <-v 
            x.C_BJSecond<-v
          else x._C_BJ<-v
  member x.C_BJSecond 
    with get ()=x._C_BJSecond 
    and set (v:Nullable<decimal>)=
      match v with
      | y when y.HasValue->
          if x._C_BJ.HasValue |>not then
            x.C_BJ<-y
            x._C_BJSecond<-y
          elif  y.Value>=x._C_BJ.Value |>not  then 
            x._C_BJSecond<-x.C_BJ
          else x._C_BJSecond<-y 
      | _ ->()


System.Guid.TryParse(null)
let x01=ref 5M
incr x01

acc
let x01=new System.Collections.Generic.List<string>()
x01|>PSeq.head 

let va=new NotNullValidator()
let result=va.Validate(null)
result.IsValid

let va2=new DateTimeRangeValidator(
va2
*)
//-------------------------------------------------------------------------------
(*

//#I @"D:\Workspace\SBIIMS\WX.Data.FHelper\bin\Debug"
//#r "WX.Data.FHelper.dll"

#I @"D:\Work for myself\F# Research\BusinessArchitecture\SBIIMS\WX.Data.FHelper\bin\Debug"
#r "WX.Data.FHelper.dll"

open WX.Data.FHelper
 
let configFilePath=ConfigHelper.INS.EntryConfig.AppSettings.Settings.["DataAccessConfigPath"].Value
let configFilePath001= ConfigHelper.INS.EntryConfig.AppSettings.Settings.["WcfServiceConfigPath"].Value
let x=ConfigHelper.INS.EntryConfig

ConfigHelper.INS.EntryConfig.AppSettings.Settings.Count

ConfigurationManager.AppSettings.["EntryConfigPath"]

byte 0




*)