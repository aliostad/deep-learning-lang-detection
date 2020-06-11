open Suave                 
open Fate
open FateTypes
open RightHandOfFate
open HttpApi


let connString =
    System.Configuration.ConfigurationManager.ConnectionStrings.["TestConnection"].ConnectionString
    
let clear = (fun () -> Database.removeAllPeople connString) >> eitherToHttp

let pickPerson = 
    Person.create 
    >> assignPersonWith 
          (fun () -> Database.getAssignments connString)
          (fun asgn -> Database.setAssignment connString asgn)  
    >> eitherToHttp
    
let dbInit names = 
    names
    |> Seq.map Person.create
    |> Database.addPeople connString
    |> eitherToHttp

let httpApi = HttpApi.app pickPerson clear dbInit

startWebServer defaultConfig httpApi