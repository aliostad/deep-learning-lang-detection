namespace MyFSharpLibrary.Utils
open System
open System.IO
module ch4 = 
    //Parsing function to read a single row from CSV, and return the data as a tuple
    let convertDataRow(csvLine:string) = 
        let cells = List.ofSeq(csvLine.Split(','))
        match cells with
        | title::number::_->
            let parsedNumber = Int32.Parse(number)
            (title, parsedNumber)
        | _-> failwith "Invalid data format"

    //Process a List of strings , converting each to a tuple
    let rec processLines(lines) = 
        match lines with
        | []->[]  //Empty list
        | currentLine::remaining ->
            let parsedLines = convertDataRow(currentLine)
            let parsedRest = processLines(remaining)
            parsedLines::parsedRest

    //Helper function to calculate the total population for all countries in the list
    let rec calcTotalPopulation records =
        match records with
        | []->0
        | (_, value)::tail->
            let total = value + calcTotalPopulation(tail)
            total
        
    //Main program funtion to read from the csv and call the appropriate functions/calculations
    let lines = List.ofSeq(File.ReadAllLines(@"C:\Projects\Playpen\MyFSharpLibrary\MyFSharpLibrary\countries.csv"))
    let data = processLines lines
    let sum = float(calcTotalPopulation data)

    for(title, value) in data do
        let percentage = int((float(value)) / sum * 100.0)
        Console.WriteLine("{0, -18} - {1, 8} ({2}%)", title, value, percentage)

    //*********Test Data************
    let testCsvData = "Asia, 1604"::"Africa, 2248"::"America, 5568"::[]
    let testListData = processLines testCsvData

