#load "load-project-release.fsx"

#time

open System

Environment.CurrentDirectory <- __SOURCE_DIRECTORY__



module GenUnits =
    
    module Api =

        open Informedica.GenUnits.Lib
    
        let fromString = Api.fromString
        
        let toString = Api.toString
        
        let eval = Api.eval
        
        let convert = Api.convert
        
        let getUnits grp = 
            Unit.Units.units
            |> List.collect id
            |> List.filter (fun u -> 
                (u 
                |> Unit.getGroupName 
                |> Unit.Name.toString = grp) || (grp |> String.isEmpty))
            |> List.map (fun u -> 
                let abbr = u.Abbreviation |> fst |> Unit.Name.toString
                let grp = u.Group |> Unit.Name.toString
                sprintf "%s[%s]" abbr grp)

