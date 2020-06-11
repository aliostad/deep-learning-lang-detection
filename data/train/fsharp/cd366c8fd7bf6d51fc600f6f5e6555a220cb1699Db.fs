namespace SuaveRestApi.Db

open System.Collections.Generic


[<AutoOpen>]
module PersonDb = 
    type Person = {
        Id: int
        Name: string
        Age: int
        Email: string
    }
    let private copyPerson { Id = id; Name = name; Age = age; Email = email } = 
        { Id = id; Name = name; Age = age; Email = email }

    let private peopleStorage = new Dictionary<int, Person>()
    
    let getPeople() = peopleStorage.Values |> Seq.map (fun p -> p) 
    
    let getPersonById id = 
        if peopleStorage.ContainsKey(id) then
            Some peopleStorage.[id]
        else
            None

    let createPerson person = 
        let id = peopleStorage.Values.Count + 1
        let newPerson = { copyPerson person with Id = id}
        peopleStorage.Add(id, newPerson)
        newPerson

    let updatePersonById personId personToBeUpdated =
        if(peopleStorage.ContainsKey personId) then
            let updatePerson = { copyPerson personToBeUpdated with Id = personId}
            peopleStorage.[personId] <- updatePerson
            Some updatePerson
        else
            None  
            
    let updatePerson personToBeUpdated = 
        updatePersonById personToBeUpdated.Id personToBeUpdated
  
    // let deletePerson personId =
    //     if peopleStorage.ContainsKey personId then
    //         peopleStorage.Remove personId |> ignore
    //         Success
    //     else 
    //         Failure 
