module Server.App

open Suave
open Suave.Filters
open Suave.Operators
open Helpers

let homepage =
    """<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body style="margin:0; padding:0">
    <div id="elmish-app">Loading...</div>
    <script src="./scripts/app.js"></script>
    <script>
    window.onload = function () {
        App.run("elmish-app");
    };
    </script>
</body>
</html>"""

let apiHandler (api : Common.Api.SampleDataApi) =
    choose [
        GET >=> path "/api/user" >=> request(fun _ -> api.User.Search() |> restResponce)
        GET >=> path "/api/product" >=> request(fun _ -> api.Product.Search() |> restResponce) ]

let appHandler api = 
    choose [
        GET >=> path "/" >=> Successful.OK homepage
        apiHandler api
        Files.browseHome ]