namespace AyinExcelAddIn

open System
open FSharp.Data.Sql

module Db =
    let [<Literal>] dbConStr = 
        @"Host=10.101.42.13; Database=nyabs; Username=intex; Password=intex"
    let [<Literal>] resPath = __SOURCE_DIRECTORY__ + @"..\..\packages\Npgsql.3.1.7\lib\net45\"
    let [<Literal>] dbVendor = Common.DatabaseProviderTypes.POSTGRESQL
    let [<Literal>] optTypes = true

    type nyabsDbCon = 
        SqlDataProvider<DatabaseVendor = dbVendor,
                        ConnectionString = dbConStr,
                        ResolutionPath = resPath>

    Common.QueryEvents.SqlQueryEvent |> Event.add (printfn "Executing SQL: %s")

[<AutoOpen>]
module public Utils =
    type Either<'a, 'b> =
    | Right of 'b
    | Left of 'a

    let either (e: Either<'a, 'b>) (fa: 'a -> _) (fb: 'b -> 'c) =
        match e with
        | Right b -> fb b
        | Left a -> fa a

//    type Nullable<'T when 'T : (new : unit -> 'T) and 'T : struct and 'T :> ValueType > with
//        member this.Print() =
//            if (this.HasValue) then this.Value.ToString()
//            else "NULL"

    let inline isNull o = System.Object.ReferenceEquals(o, null)

    let inline (|Null|Value|) (x: _ Nullable) = if x.HasValue then Value x.Value else Null

    // Transforms a Nullable to an Option type
    let inline fromNullable (x: _ Nullable) = if x.HasValue then Some x.Value else None

    /// Converts a DateTime value to an integer yyyymm value.
    let inline toYYYYMM (d: DateTime) = (d.Year * 100) + d.Month

    /// Converts an integer yyyymm value to a DateTime value.
    let inline toDate yyyymm = new DateTime(yyyymm / 100, int (string yyyymm).[4..], 1)

    // Returns the date that corresponds do the last day month of the specified date.
    let inline monthEnd (d: DateTime) = (new DateTime(d.Year, d.Month, 1)).AddMonths(1).AddDays(-1.)

    // Returns the date that corresponds do the first day month of the specified date.
    let inline monthStart (d: DateTime) = new DateTime(d.Year, d.Month, 1)

    // Returns the date that corresponds do the last day year of the specified date.
    let inline yearEnd (d: DateTime) = (new DateTime(d.Year, 1, 1)).AddYears(1).AddDays(-1.)

    /// Transposes a 2-dimensional array
    let inline transpose (array: 'T[,]) =
        Array2D.init (Array2D.length2 array) (Array2D.length1 array) (fun x y -> array.[y, x])

    let inline throw msg = raise <| Exception(msg)
    let inline ensure cond msg = if not cond then throw msg

[<AutoOpen>]
module public UdfError =
    let InvalidBond = "#N/A Invalid bond"
    let InvalidDeal = "#N/A Invalid deal"
    let InvalidDealBond = "#N/A Invalid deal/bond"
    let InvalidBroker = "#N/A Invalid broker"
    let NoQuote = "#N/A No quote"
    let InvalidTag = "#N/A Invalid tag"
    let NoData = "#N/A No data"


