module Umov.Csxcad.OpenEmsReader

open System.IO
open System.Text.RegularExpressions

open Umov.Csxcad.Base

let private processExcitation (excitation : Xml.Excitation) =
    { Type = Utils.parseEnum excitation.Type
      MainFrequency = Option.map double excitation.F0
      // TODO: generate XML with Gauss excitation and extract cutoff frequency
      // from it.
      CutoffFrequency = None
      // TODO: generate XML with custom excitation and extract function string
      // from it.
      ExcitationFunction = None }

let processBoundaryConditionType name =
    match name with
    | "PEC" -> BoundaryConditionType.Pec
    | "PMC" -> BoundaryConditionType.Pmc
    | "MUR" -> BoundaryConditionType.MurAbc
    | pml when Regex.IsMatch (pml, "PML_\d{1,2}") ->
        let size = pml.Split('_').[1]
        BoundaryConditionType.PmlAbc (uint32 size)
    | _ -> failwithf "Invalid boundary condition type: %s" name


let processBoundaryConditions (conditions : Xml.BoundaryCond) =
    { XMin = processBoundaryConditionType conditions.Xmin
      XMax = processBoundaryConditionType conditions.Xmax
      YMin = processBoundaryConditionType conditions.Ymin
      YMax = processBoundaryConditionType conditions.Ymax
      ZMin = processBoundaryConditionType conditions.Zmin
      ZMax = processBoundaryConditionType conditions.Zmax }

let private processFdtd (fdtd : Xml.Fdtd) =
    { NumberOfTimesteps = uint32 fdtd.NumberOfTimesteps
      EndEnergyCriteria = double fdtd.EndCriteria
      MaxFrequency = double fdtd.FMax
      Excitation = processExcitation fdtd.Excitation
      BoundaryConditions = processBoundaryConditions fdtd.BoundaryCond }

let private processOpenEms (openEms : Xml.OpenEms) =
    let fdtd = processFdtd openEms.Fdtd
    let cs = CsxReader.processContinuousStructure openEms.ContinuousStructure
    { Fdtd = fdtd
      ContinuousStructure = cs }

let Parse (stream : Stream) : OpenEms =
    let data = Xml.Load stream
    match data.OpenEms with
    | Some openEms -> processOpenEms openEms
    | None -> failwithf "Incompatible XML data"
