#r "../../packages/System.Reflection.Metadata.1.4.2/lib/portable-net45+win8/System.Reflection.Metadata.dll"
#r "../../packages/System.Collections.Immutable.1.3.1/lib/portable-net45+win8+wp8+wpa81/System.Collections.Immutable.dll"
#r "../../packages/System.IO.4.3.0/lib/net462/System.IO.dll"

open System
open System.IO
open System.Linq
open System.Linq.Expressions
open System.Reflection
open System.Reflection.Metadata
open System.Reflection.Metadata.Ecma335
open System.Reflection.PortableExecutable

let ibmInstallation = @"c:\Program Files\IBM\WebSphere MQ\bin\"
let ibmExclude = ["WCF"; "SOAP"; "WSDL"; "policy"]
let containsSubstring (name:string) = ibmExclude |> Seq.where (fun x-> name.ToUpperInvariant().Contains(x.ToUpperInvariant())) 
let isManaged (name:string) = 
  let stream = File.OpenRead(name)
  use reader = new System.Reflection.PortableExecutable.PEReader(stream)
  try
    let headersManaged = reader.PEHeaders
    (headersManaged.CorHeader <> null)
  with 
    | _ -> false

let ibmFiles = Directory.GetFiles(ibmInstallation, "*.dll") |> Seq.where (fun x-> containsSubstring(x).Any() = false && isManaged(x) && x.Contains(".dll"))

//// TODO: fix copying pdb and xml
let pdbs = ibmFiles |> Seq.map (fun x-> x.Replace(".dll",".pdb")) |> Seq.where (fun x-> File.Exists(x))
let xmls = ibmFiles |> Seq.map (fun x-> x.Replace(".dll",".xml")) |> Seq.where (fun x-> File.Exists(x))

let toCopy = ibmFiles.Concat(pdbs).Concat(xmls)
let dest = "D:/src/NNugets/WebSphereMqClient/packaging/lib/net20"

for f in toCopy do
  let name = Path.GetFileName f
  let destFile = Path.Combine(dest, name)
  Console.WriteLine("#r @\"" + destFile + "\"")
  File.Copy(f, destFile, true)