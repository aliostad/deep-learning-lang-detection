namespace WordPress.Test

open System
open Xunit
open WordPress
open WordPress.Types
open WordPressTest

module Categories =
  [<Fact>]
  let ``WordPress.Categories getAllAsync with empty response``  () =
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient "[]"; }

    WordPress.Categories.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.Empty

  [<Fact>]
  let ``WordPress.Categories getAllAsync with non-empty response``  () =
    let response = readFixture "AllCategories.json"
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient response; }

    WordPress.Categories.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.NotEmpty
