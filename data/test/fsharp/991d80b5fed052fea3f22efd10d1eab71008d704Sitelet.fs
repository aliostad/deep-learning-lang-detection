namespace London.Web

open WebSharper
open WebSharper.Sitelets
open WebSharper.UI.Next
open WebSharper.UI.Next.Html
open WebSharper.UI.Next.Server
open London.Core

module Sitelet =
    
    type EndPoint =
    | [<EndPoint "/">]          Home
    | [<EndPoint "/refresh">]   Refresh
    | [<EndPoint "/api">]       Api of ApiEndPoint

    and ApiEndPoint =
        | [<EndPoint "/expenses">]             Expenses
        | [<EndPoint "/supermarket">]          Supermarket
        | [<EndPoint "/smoothsupermarket">]    SmoothSupermarket
        | [<EndPoint "/levelcounts">]          LevelCounts
        | [<EndPoint "/dayspan">]              DaySpan
        | [<EndPoint "/binaryexpenses">]       Binary
        | [<EndPoint "/expanding">]            Expanding
        | [<EndPoint "/ratio">]                Ratio
        | [<EndPoint "/labels">]               Labels
        | [<EndPoint "/transactions">]         Transactions
        | [<EndPoint "/dailyexpandingsummonthcategory">]  DailyExpandingSumPerMonthPerCategory

    let sitelet =
        
        Sitelet.Infer (fun ctx endpoint->
            
            let expenses =
                Dataframe.agent.Get()

            match endpoint with
            | Home ->
                Templates.Index.Doc(
                    Title = "London expenses",
                    Nav = [ client <@ App.Client.nav @> ],
                    Main = [ client <@ App.Client.main @> ])
                |> Content.Page

            | Refresh ->
                // Refresh the dataframe - Useful when new CSV's are added
                Dataframe.agent.Refresh None
                Content.Text "Refresh dataframe"
                |> Content.SetStatus Http.Status.Ok
            
            | Api Expenses                             -> expenses |> Api.allExpenses ctx
            | Api Supermarket                          -> expenses |> Api.expensesForCategory Category.Supermarket ctx
            | Api SmoothSupermarket                    -> expenses |> Api.smoothExpensesForCategory Category.Supermarket ctx
            | Api LevelCounts                          -> expenses |> Api.expenseLevelsCount ctx
            | Api DaySpan                              -> expenses |> Api.daySpanExpenses ctx
            | Api Binary                               -> expenses |> Api.binaryExpenses ctx
            | Api Expanding                            -> expenses |> Api.expandingExpenses ctx
            | Api DailyExpandingSumPerMonthPerCategory -> expenses |> Api.dailyExpandingSumPerMonthPerCategory ctx
            | Api Ratio                                -> expenses |> Api.categoryRatioPerMonth ctx
            | Api Labels                               -> expenses |> Api.labelsPerMonth ctx
            | Api Transactions                         -> expenses |> Api.transactionsAndSumPerMonth ctx)