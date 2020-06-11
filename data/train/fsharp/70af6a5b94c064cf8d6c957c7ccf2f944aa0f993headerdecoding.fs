module http2.tests.hpack.``Decoding Header Key Value pairs``

open FsUnit
open NUnit.Framework
open http2.hpack

let emptyDynamicTable = { maxSize= 1024; entries = [] }

[<Test>]
let ``Accessing first static indexed header``() =
    let header = IndexedHeader 1
    let r, _ = processHeader header emptyDynamicTable

    r |> should equal {Name = ":authority"; Value = ""}

[<Test>]
let ``Accessing last static indexed header``() =
    let header = IndexedHeader 61
    let r, _ = processHeader header emptyDynamicTable

    r |> should equal {Name = "www-authenticate"; Value = ""}

[<Test>]
let ``Accessing static indexed header with indexed name returns new value``() =
    let header = 
        LiteralHeader (
            IndexedName (
                NonIndexing, 1, "NewValue"))
    let r, _ = processHeader header emptyDynamicTable

    r |> should equal {Name = ":authority"; Value = "NewValue"}

[<Test>]
let ``Processing non indexed header returns new name and value``() =
    let header = 
        LiteralHeader (
            NewName (
                NonIndexing, "NewName", "NewValue"))
    let r, _ = processHeader header emptyDynamicTable

    r |> should equal {Name = "NewName"; Value = "NewValue"}

[<Test>]
let ``Processing header with NonIndexing set does not change dynamic table``() =
    let header = 
        LiteralHeader (
            NewName (
                NonIndexing, "NewName", "NewValue"))
    let _, newTable = processHeader header emptyDynamicTable

    newTable |> should equal emptyDynamicTable

[<Test>]
let ``Processing header with Incremental indexing updates dynamic table``() =
    let header = 
        LiteralHeader (
            NewName (
                Incremental, "NewName", "NewValue"))
    
    let _, newTable = processHeader header emptyDynamicTable

    let expectedNewTable = {
        emptyDynamicTable 
        with entries = [{Name = "NewName"; Value = "NewValue"}]
    }

    newTable |> should equal expectedNewTable

[<Test>]
let ``Processing two header with Incremental indexing updates dynamic table to hold both headers``() =
    let header = 
        LiteralHeader (
            NewName (
                Incremental, "NewName", "NewValue"))
    
    let _, newTable1 = processHeader header emptyDynamicTable
    let _, newTable2 = processHeader header newTable1

    let expectedNewTable = 
        {
            emptyDynamicTable 
            with entries = [{Name = "NewName"; Value = "NewValue"}; {Name = "NewName"; Value = "NewValue"}]
        }

    newTable2 |> should equal expectedNewTable

[<Test>]
let ``Processing two headers with Incremental indexing on full dynamic table evicts oldest members``() =
    let h1 = 
        LiteralHeader (
            NewName (
                Incremental, "0987654321", "0987654321"))    
    let h2 = 
        LiteralHeader (
            NewName (
                Incremental, "1234567890", "1234567890"))

    let smallDynamicTable = { maxSize= 60; entries = [] }
    
    let _, newTable1 = processHeader h1 smallDynamicTable
    let _, newTable2 = processHeader h2 newTable1

    let expectedNewTable = 
        {
            maxSize = 60; 
            entries = [{Name = "1234567890"; Value = "1234567890"}]
        }

    newTable2 |> should equal expectedNewTable

[<Test>]
let ``Inserting too large a header empties the dynamic header table``() =
    let h1 = 
        LiteralHeader (
            NewName (
                Incremental, "098765432109876543210987654321", "098765432109876543210987654321")) 
                   
    let smallDynamicTable = { maxSize = 60; entries = [{Name = "1234567890"; Value = "1234567890"}] }
    
    let _, newTable = processHeader h1 smallDynamicTable

    let expectedNewTable = 
        {
            maxSize = 60; 
            entries = []
        }

    newTable |> should equal expectedNewTable
