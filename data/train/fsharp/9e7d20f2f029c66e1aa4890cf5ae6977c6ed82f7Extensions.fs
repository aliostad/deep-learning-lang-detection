namespace Xlnt.Data

open System
open System.Data
open System.Data.SqlClient
open System.Runtime.CompilerServices

[<AutoOpen;Extension>]
module Extensions =
    type System.Data.SqlClient.SqlConnection with
        member this.WithReader(setup, resultHandler) =
            use cmd = this.CreateCommand()
            setup(cmd)
            use reader = cmd.ExecuteReader()
            resultHandler(reader)

    type System.Data.IDbCommand with
        member this.AddParameter(name, value) =
            let parameter = this.CreateParameter()
            parameter.ParameterName <- name
            parameter.Value <- value
            this.Parameters.Add(parameter)

    //Play nice with the C# peeps
    [<Extension>]
    let WithReader(self:SqlConnection, setup:Action<SqlCommand>, resultHandler:Func<IDataReader,'a>) = self.WithReader(setup.Invoke, resultHandler.Invoke)
