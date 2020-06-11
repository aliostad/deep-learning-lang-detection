namespace FSharp.Data
  open System.Data
  open System.Data.SqlClient
  
  type Param =
    { Name: string
      Value: System.Object }
  
  type CommandData =
    { sql: string
      parameters: Param array
      cmdType: CommandType
      connectionString: string }
      
module public Fetcher =
  open System.Data
  open System.Data.SqlClient
  open System.Configuration
  open System.Xml
  
  // Extension methods to execute the commands asynchronously
  type internal System.Data.SqlClient.SqlCommand with
    member x.AsyncExecuteReader () =
      Async.BuildPrimitive(x.BeginExecuteReader, x.EndExecuteReader)
    member x.AsyncExecuteNonQuery () =
      Async.BuildPrimitive(x.BeginExecuteNonQuery, x.EndExecuteNonQuery)
    member x.AsyncExecuteXmlReader () =
      Async.BuildPrimitive(x.BeginExecuteXmlReader, x.EndExecuteXmlReader)
  
  let internal buildCommand connection (data:CommandData) =
    let result = new SqlCommand(data.sql, connection)
    let parameters =
      data.parameters
      |> Seq.map (fun p -> new SqlParameter(p.Name, p.Value))
      |> Seq.to_array
    result.CommandType <- data.cmdType
    result.Parameters.AddRange(parameters)
    result
  
  let internal asyncExecuteReader data (premap:IDataReader -> unit) (mapper:IDataRecord -> 'a) =
    let mapReader (rdr:IDataReader) =
      seq { while rdr.Read() do yield mapper rdr }  // seq workflow
    async { // async workflow
      use connection = new SqlConnection (data.connectionString)
      connection.Open()
      use command = buildCommand connection data
      let! rdr = command.AsyncExecuteReader ()
      premap rdr
      let result = mapReader rdr
      return result |> Seq.to_array // do this to avoid lazy calculation, which would prematurely close the reader.
    }
    
  let internal asyncGetXml data =
    async {
      use connection = new SqlConnection (data.connectionString)
      use command = buildCommand connection data
      use! rdr = command.AsyncExecuteXmlReader ()
      return rdr.ReadOuterXml ()
    }
  
  let internal asyncExecuteNonQuery data =
    async {
      use connection = new SqlConnection (data.connectionString)
      use command = buildCommand connection data
      let! result = command.AsyncExecuteNonQuery ()
      return result
    }
  
  // Synchronous methods
  let ExecuteDataReader data premap mapper =
    Async.RunSynchronously(asyncExecuteReader data premap mapper)
  let GetXml data =
    Async.RunSynchronously(asyncGetXml data)
  let ExecuteNonQuery data =
    Async.RunSynchronously(asyncExecuteNonQuery data)
  
  // Async methods with continuations
  let exceptionHandler = fun (exn: System.Exception) -> printfn "%A" exn.Message
  let cancellationHandler = fun (cancel: System.OperationCanceledException) -> ()
  
  let AsyncExecuteDataReaderWithContinuation data premap mapper continuation =
    Async.RunWithContinuations(continuation, exceptionHandler, cancellationHandler, asyncExecuteReader data premap mapper)
  let AsyncGetXmlWithContinuation data continuation =
    Async.RunWithContinuations(continuation, exceptionHandler, cancellationHandler, asyncGetXml data)
  let AsyncExecuteNonQueryWithContinuation data continuation =
    Async.RunWithContinuations(continuation, exceptionHandler, cancellationHandler, asyncExecuteNonQuery data)
