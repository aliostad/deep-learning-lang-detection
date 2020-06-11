namespace SqlConnector.Tests

open FlexSearch.Api.Model;
open FlexSearch.Api.Client;
open FlexSearch.Api.Api;

module SampleIndexingRequest =
    // We assume we already have an index in FlexSearch named 'contact' with the following fields:
    // - firstname - text
    // - lastname - text
    // - createdon - date

    // I'll create a statement that will just bring the contacts that begin with 'V'.
    // You can omit any where clause and just bring everything if you want.
    let selectStatement = """
SELECT contactid, firstname, lastname, createdon
FROM contact
WHERE firstname like 'v*'
"""

    let request = new SqlIndexingRequest(IndexName = "contact",
                                         ConnectionString = "data source=localdb;initial catalog=contact;Integrated Security=True",
                                         Query = selectStatement,
                                         ForceCreate = true, // I am sure that all the documents that will be indexed are new ones
                                         CreateJob = true ) // I want to get a job ID back and check the status of the job myself

    // Create a client to send the SQL request
    let api = new CommonApi("http://localhost:9800")
    
    // Send the actual request
    let result = api.Sql(request, "contact")

    // Extract the job ID 
    let jobId = if result.Error |> isNull then result.Data |> Some
                else None

    // Check the status
    let status =
        match jobId with
        | Some(id) -> 
            let jobApi = new JobsApi("http://localhost:9800")
            printfn "Job Status: %A" <| jobApi.GetJob(id).Data.JobStatus
        | None -> printfn "Oops"
