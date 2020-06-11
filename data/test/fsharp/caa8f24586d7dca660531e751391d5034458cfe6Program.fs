// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.

module Main
    open System

    type Person = {
        name : string;
        age: int
    }

    let defaultPerson = { name = ""; age = 0 }

    let getPeopleInfo peopleNumber = 
        let personArray = Array.create peopleNumber defaultPerson

        for i in 0..peopleNumber - 1 do
            Console.WriteLine((string i) + "th person: name")
            let name = Console.ReadLine()
            Console.WriteLine((string i) + "th person: age")
            let age = Console.ReadLine()
            let age = int age
            let person = { name = name; age = age }
            Array.set personArray i person
        
        personArray
    
    let processPerson person = 
        let messageInfo = 
            if (person.age >= 20) then
                "The person " + (person.name) + " is no longer a teenager"
            elif (person.age < 20 && person.age > 13) then
                "The person " + (person.name) + " is a teenager"
            else
                "The person " + (person.name) + " is a kid or a child"

        messageInfo

    let processPeopleInfo peopleInfo = 
        for i in 0..(Array.length peopleInfo - 1) do
            let message = processPerson (Array.get peopleInfo i)
            Console.WriteLine(message)
        0

    [<EntryPoint>]
    let main argv = 
        Console.WriteLine("Please, enter the number of people to process")
        let peopleNumber = Console.ReadLine()
        let peopleNumber = int peopleNumber
        
        let peopleInfo = getPeopleInfo peopleNumber
        ignore (processPeopleInfo peopleInfo)

        ignore (Console.ReadLine())

        0 // return an integer exit code

