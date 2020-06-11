module TimeSlisceTests

open System
open Xunit
open FsUnit.Xunit
open PiwikApiParameter


let dateFormat = "yyyy-MM-dd"
let startDate =DateTime.Now.AddDays(-30.0)
let endDate = DateTime.Now
let contains (testFor:string) (result:string)=
    printfn "%s" result
    result.Contains(testFor)

[<Fact>]
let ``Date(DateTime.Now, Day) shuld have date and period=day`` () =
    let d = (Date(DateTime.Now, Day):>ApiParameter).Command 
    d |> contains ("&date=" + DateTime.Now.ToString(dateFormat)) |> should be True
    d |> contains "&period=day" |> should be True

[<Fact>]
let ``Date(DateTime.Now, Month) shuld have date and period=month`` () =
    let d = (Date(DateTime.Now, Month):>ApiParameter).Command 
    d |> contains ("&date=" + DateTime.Now.ToString(dateFormat)) |> should be True
    d |> contains "&period=month" |> should be True

[<Fact>]
let ``Date(DateTime.Now, Year) shuld have date and period=year`` () =
    let d = (Date(DateTime.Now, Year):>ApiParameter).Command 
    d |> contains ("&date=" + DateTime.Now.ToString(dateFormat)) |> should be True
    d |> contains "&period=year" |> should be True

[<Fact>]
let ``Date(DateTime.Now, Week) shuld have date and period=week`` () =
    let d = (Date(DateTime.Now, Week):>ApiParameter).Command
    d |> contains ("&date=" + DateTime.Now.ToString(dateFormat)) |> should be True
    d |> contains "&period=week" |> should be True

[<Fact>]
let ``Today shuld have date=today and period=day`` () =
    let d =(Today:>ApiParameter).Command
    d |> contains ("&period=day&date=today") |> should be True

[<Fact>]
let ``Yeaterday shuld have date=today and period=day`` () =
    let d =(Yesterday:>ApiParameter).Command
    d |> contains ("&period=day&date=yesterday") |> should be True

[<Fact>]
let ``Last(5, Day) shuld have date and period=day`` () =
    let d = (Last(5, Day):>ApiParameter).Command
    d |> contains ("&date=last5") |> should be True
    d |> contains "&period=day" |> should be True

[<Fact>]
let ``Last(5, Week) shuld have date and period=week`` () =
    let d = (Last(5, Week):>ApiParameter).Command
    d |> contains ("&date=last5") |> should be True
    d |> contains "&period=week" |> should be True

[<Fact>]
let ``Last(5, Month) shuld have date and period=month`` () =
    let d = (Last(5, Month):>ApiParameter).Command
    d |> contains ("&date=last5") |> should be True
    d |> contains "&period=month" |> should be True

[<Fact>]
let ``Last(5,Year) shuld have date and period=year`` () =
    let d = (Last(5, Year):>ApiParameter).Command
    d |> contains ("&date=last5") |> should be True
    d |> contains "&period=year" |> should be True

[<Fact>]
let ``Previous(5, Day) shuld have date and period=day`` () =
    let d = (Previous(5, Day):>ApiParameter).Command
    d |> contains ("&date=previous5") |> should be True
    d |> contains "&period=day" |> should be True

[<Fact>]
let ``Previous(5, Week) shuld have date and period=week`` () =
    let d = (Previous(5, Week):>ApiParameter).Command
    d |> contains ("&date=previous5") |> should be True
    d |> contains "&period=week" |> should be True

[<Fact>]
let ``Previous(5, Month) shuld have date and period=month`` () =
    let d = (Previous(5,Month):>ApiParameter).Command
    d |> contains ("&date=previous5") |> should be True
    d |> contains "&period=month" |> should be True

[<Fact>]
let ``Previous(5,Year) shuld have date and period=year`` () =
    let d = (Previous(5, Year):>ApiParameter).Command
    d |> contains ("&date=previous5") |> should be True
    d |> contains "&period=year" |> should be True

[<Fact>]
let ``Period(startDate,endDate,Day) shuld have date and period=day`` () =
    let d = (Period(startDate,endDate,Day):>ApiParameter).Command
    d |> contains (String.Format("&date={0},{1}",startDate.ToString(dateFormat),endDate.ToString(dateFormat))) |> should be True
    d |> contains "&period=day" |> should be True

[<Fact>]
let ``Range(startDate,endDate) shuld have date and period=range`` () =
    let d = (Range(startDate,endDate):>ApiParameter).Command
    d |> contains (String.Format("&date={0},{1}",startDate.ToString(dateFormat),endDate.ToString(dateFormat))) |> should be True
    d |> contains "&period=range" |> should be True

