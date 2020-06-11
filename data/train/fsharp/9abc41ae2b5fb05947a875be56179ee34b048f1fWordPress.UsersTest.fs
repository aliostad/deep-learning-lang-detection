namespace WordPress.Test

open System
open Xunit
open WordPress
open WordPress.Types
open WordPressTest

module Users =
  [<Fact>]
  let ``WordPress.Users getAllAsync with empty response``  () =
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient "[]"; }

    WordPress.Users.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.Empty

  [<Fact>]
  let ``WordPress.Users getAllAsync with non-empty response``  () =
    let response = readFixture "AllUsers.json"
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient response; }

    WordPress.Users.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.NotEmpty
