module Umov.Csxcad.CsxReader

open System
open System.IO

open Umov.Csxcad.Base
open Umov.Csxcad.Geometry
open Umov.Csxcad.Primitives
open Umov.Csxcad.Properties

let private processP1 (p1 : Xml.P) : Point =
    { X = double p1.X
      Y = double p1.Y
      Z = double p1.Z }

let private processP2 (p2 : Xml.P2) : Point =
    { X = double p2.X
      Y = double p2.Y
      Z = double p2.Z }

let private processBox (box : Xml.Box) =
    Box (int box.Priority, processP1 box.P, processP2 box.P2)

let private processPrimitives (primitives : Xml.Primitives) : Primitive array =
    Array.map (fun b -> upcast processBox b) primitives.Boxes

let private processPrimitivesOpt (primitives : Xml.Primitives option) =
    primitives
    |> Option.toArray
    |> Array.collect processPrimitives

let private processDumpType (dumpBox : Xml.DumpBox) =
    DumpType.EFieldTimeDomain // TODO: Parse dump type.

let private processDumpMode (dumpBox : Xml.DumpBox) =
    Utils.parseEnum dumpBox.DumpMode

let private processDumpBox (dumpBox : Xml.DumpBox) : Property =
    upcast DumpBox (dumpBox.Name,
                    processPrimitives dumpBox.Primitives,
                    processDumpType dumpBox,
                    processDumpMode dumpBox)

let private processExcitationType = Utils.parseEnum

let private processExcite (excite : string) =
    let components = excite.Split ','
    { X = double components.[0]
      Y = double components.[1]
      Z = double components.[2] }

let private processExcitation (excitation : Xml.Excitation) : Property =
    let name = defaultArg excitation.Name ""
    let excite = defaultArg excitation.Excite "0,0,0"
    upcast Excitation (name,
                       processPrimitivesOpt excitation.Primitives,
                       processExcitationType excitation.Type,
                       processExcite excite)

let private processMetal (metal : Xml.Metal) : Property =
    upcast Metal (metal.Name, processPrimitives metal.Primitives)

let private processMaterial (material : Xml.Material) : Property =
    upcast Material (material.Name, processPrimitives material.Primitives)

let private processProperties (properties : Xml.Properties) =
    [ Seq.map processDumpBox (Option.toList properties.DumpBox)
      Seq.map processExcitation properties.Excitations
      Seq.map processMetal properties.Metals
      Seq.map processMaterial properties.Materials ]
    |> Seq.concat
    |> Seq.toArray

let private processGridLines (lines : string) =
    lines.Split ([| ',' |], StringSplitOptions.RemoveEmptyEntries)
    |> Array.map double

let private processRectilinearGrid (grid : Xml.RectilinearGrid) =
    { Delta = double grid.DeltaUnit
      CoordinateSystem = defaultArg (Option.bind Utils.parseEnumOpt grid.CoordSystem) CoordinateSystem.Cartesian
      XLines = processGridLines grid.XLines.Value
      YLines = processGridLines grid.YLines.Value
      ZLines = processGridLines grid.ZLines.Value }

let internal processContinuousStructure (structure : Xml.ContinuousStructure)
                                        : ContinuousStructure =
    { CoordinateSystem = Utils.parseEnum structure.CoordSystem
      Properties = processProperties structure.Properties
      Grid = processRectilinearGrid structure.RectilinearGrid }

let Parse (stream : Stream) : ContinuousStructure =
    let data = Xml.Load stream
    match data.ContinuousStructure with
    | Some cs -> processContinuousStructure cs
    | None -> failwithf "Incompatible XML data"
