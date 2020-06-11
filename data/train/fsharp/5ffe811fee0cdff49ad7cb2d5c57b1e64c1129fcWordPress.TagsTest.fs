namespace WordPress.Test

open System
open Xunit
open WordPress
open WordPress.Types
open WordPressTest

module Tags =
  [<Fact>]
  let ``WordPress.Tags getAllAsync with empty response``  () =
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient "[]"; }

    WordPress.Tags.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.Empty

  [<Fact>]
  let ``WordPress.Tags getAllAsync with non-empty response``  () =
    let response = readFixture "AllTags.json"
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient response; }

    WordPress.Tags.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.NotEmpty
