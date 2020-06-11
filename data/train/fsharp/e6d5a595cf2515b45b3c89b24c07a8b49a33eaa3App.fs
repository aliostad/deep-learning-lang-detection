open SuaveRestApi.Rest
open SuaveRestApi.Db
open SuaveRestApi.Data
open Suave.Web
open Suave.Successful

[<EntryPoint>]
let main argv = 
    let personWebPart = rest "people" {
        GetAll  = PersonRepository.getPeople
        Create  = PersonRepository.createPerson
        // GetById = PersonRepository.getPersonById
        // Update  = PersonRepository.updatePerson
        // // Delete  = PersonRepository.deletePerson
        // UpdateById = PersonRepository.updatePersonById
    }

    startWebServer defaultConfig personWebPart 
    0
