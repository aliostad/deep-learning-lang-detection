module xlsLoader

open System
open Microsoft.Office.Interop

open config

let xlsPath = xlsRtFolder + "\Car\\" + brandX + "\PC Test Plan - " + brandX + ".xlsx"
let savPath = xlsRtFolder + "\Car\\" + brandX + "\PC Test Plan - " + brandX + (System.DateTime.Today).ToString() + ".xlsx"

let xlApp = new Excel.ApplicationClass()
let xlWorkBookInput = xlApp.Workbooks.Open(xlsPath)
xlApp.Visible <- true

let getXLS(tab : string) =
    xlWorkBookInput.Worksheets.[tab] :?> Excel.Worksheet 

let dataExt = getXLS("Test Summary")

let cellValue (xlsFile : Excel.Worksheet, column : string, row : int) =
    xlsFile.Range(column + row.ToString()).Value2

let brand, brandCode =
  let brandFile = getXLS("Test Summary")
  cellValue(brandFile, "C", 2).ToString(), cellValue(brandFile, "I", 2).ToString()

// Brand group sequences
// ---------------------
let brandGroup(brand : string) =

    match brand with
    | "Hastings Direct" | "Hastings Essentials" | "igo4insurance" | "One Quote" | "Aquote"
    | "Elite" | "Hastings Premier" | "Virgin" | "Esure Broker" | "Sheilas' Wheels Broker" 
    | "People's Choice" | "Only Young Drivers" | "Saga Select" | "Hastings Direct SmartMiles"
    | "Castle Cover" | "Sure Thing!" | "Sure Thing! Max" | "John Lewis" | "Insure Wiser"        -> "CDL-FilterFree"
    | "AutoNet" | "Direct Choice"                                                               -> "AutoNet"
    | "A Choice" | "Express" | "Octagon" | "Debenhams"                                          -> "OpenGI"
    | "Drivology"                                                                               -> "SSP Multi Quote"
    | _ -> brand

// ---------------------

let codeLookup(description : string, codeType : string) =         
    let xlsFile, lowerBound, upperBound =
        match codeType with
        | "<occCode>"                               -> getXLS("occupation codes"), 2, 1962
        | "<empCode>"                               -> getXLS("business codes"), 2, 939
        | "<conCode>" | "<conCode1>" | "<conCode2>" -> getXLS("conviction codes"), 2, 88
        | _                                         -> getXLS("car codes"), 2, 3
           
    let result = ref None in
        let rec loop n =
            if n <= upperBound then
                let theCode =
                    if cellValue(xlsFile, "D", n) = null || codeType = "<carCode>" then
                        cellValue(xlsFile, "A", n).ToString()
                    elif codeType = "<styleCode>" then
                        cellValue(xlsFile, "F", n).ToString()
                    else
                        cellValue(xlsFile, "D", n).ToString()
                let theDesc = (cellValue(xlsFile, "B", n).ToString())
                if description <> theDesc then
                    loop (n + 1)
                else
                    if codeType = "<conCode1>" then
                        result := Some (theCode.Substring(0,2))
                    elif codeType = "<conCode2>" then
                        result := Some (theCode.Substring(2,(theCode.Length-2)))
                    else
                        result := Some theCode
        loop lowerBound
    !result

let carDetailLookup(registration : string) =
    let xlsFile = getXLS("car codes")
    let rec loop n =
        let reg = cellValue(xlsFile, "B", n).ToString()
        let resultList =
            if reg = registration then
                [cellValue(xlsFile, "A", n).ToString();
                cellValue(xlsFile, "C", n).ToString();
                cellValue(xlsFile, "D", n).ToString();
                cellValue(xlsFile, "E", n).ToString();
                cellValue(xlsFile, "F", n).ToString();
                cellValue(xlsFile, "G", n).ToString();
                cellValue(xlsFile, "H", n).ToString();
                cellValue(xlsFile, "I", n).ToString()]
            else
                if cellValue(xlsFile, "A", n+1) <> null then
                    loop (n + 1)
                else
                    ["";"";"";"";"";"";"";""]
        resultList
    loop 2