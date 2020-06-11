#load "references.fsx"
#load "path.fsx"
#load "expense.fsx"
#load "api.fsx"
#load "views.fsx"
#load "authentication.fsx"
#load "content.fsx"
#load "web.fsx"

open Newtonsoft.Json
open Suave
open Suave.Filters
open Suave.Operators
open Suave.Successful
open Suave.RequestErrors

open Expense

let app =
    let expenseReportService = createExpenseReportService()
    choose [
        pathScan Path.Content.file Content.readContent

        choose [
            path Path.home >=> Web.index
            path Path.login >=>
                choose [
                    GET >=> request(Web.Login.index)
                    POST >=> request(Authentication.userLogin)
                ]
            path Path.logout >=> Authentication.logout >=> (Redirection.redirect Path.home)
            Authentication.protect <|
                choose [
                    path Path.Expense.index >=>
                        GET >=> context(Web.Expense.index expenseReportService)
                    path Path.Expense.create >=>
                        POST >=> context(Web.Expense.create expenseReportService)
                    pathScan Path.Expense.details (fun i ->
                        GET >=> context(Web.Expense.details expenseReportService i))
                ]
        ] >=> Writers.setMimeType "text/html"

        Authentication.protect <|
            choose [
                pathScan Path.Api.Expense.details (fun expenseId ->
                    choose [
                        GET >=> request(Api.Expense.getExpenseReport expenseReportService expenseId)
                        PUT >=> request(Api.Expense.updateExpense expenseReportService)
                    ])
                pathScan Path.Api.Expense.submit (fun expenseId ->
                        POST >=> request(Api.Expense.submitExpenseReport expenseReportService expenseId)
                    )
                pathScan Path.Api.Expense.fileUpload (fun expenseId ->
                    choose [
                        POST >=> request(Api.Expense.uploadFile expenseId)
                    ])
            ] >=> Writers.setMimeType "application/json"
    ]
