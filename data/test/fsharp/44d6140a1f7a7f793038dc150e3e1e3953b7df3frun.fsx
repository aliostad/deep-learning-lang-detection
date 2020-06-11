#if !COMPILED
// Needed to resolve things automatically included by Azure Functions
#I "C:/Program Files (x86)/Azure/Functions/"
#r "Microsoft.Azure.WebJobs.Host"
#r "Microsoft.Azure.WebJobs.Extensions"
#endif

open System
open System.Data.SqlClient
open Microsoft.Azure.WebJobs
open Microsoft.Azure.WebJobs.Host

let Run(daily0300:TimerInfo, log:TraceWriter) =
  log.Info(sprintf "CopyProdToStaging executed at: %s" (DateTime.Now.ToString()))

  let databaseConnString = System.Environment.GetEnvironmentVariable("devspacedatabase")

  use sqlConn = new SqlConnection( databaseConnString )
  sqlConn.Open()

  use sqlComm = new SqlCommand( "DROP DATABASE DevSpaceStaging; CREATE DATABASE DevSpaceStaging AS COPY OF DevSpace;", sqlConn );
  sqlComm.ExecuteNonQuery() |> ignore
