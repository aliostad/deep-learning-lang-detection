namespace WordPress.Test

open System
open Xunit
open WordPress
open WordPress.Types
open WordPressTest

module Pages =
  [<Fact>]
  let ``WordPress.Pages getAllAsync with empty response``  () =
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient "[]"; }

    WordPress.Pages.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.Empty

  [<Fact>]
  let ``WordPress.Pages getAllAsync with non-empty response``  () =
    let response = readFixture "AllPages.json"
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient response; }

    WordPress.Pages.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.NotEmpty

  [<Fact>]
  let ``WordPress.Pages getAllAsync with non-empty response + embeds`` () =
    let response = readFixture "AllPagesWithEmbed.json"
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient response; }

    WordPress.Pages.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.NotEmpty
