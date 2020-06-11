namespace WordPress.Test

open System
open Xunit
open WordPress
open WordPress.Types
open WordPressTest

module Posts =
  [<Fact>]
  let ``WordPress.Posts getAllAsync with empty response``  () =
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient "[]"; }

    WordPress.Posts.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.Empty

  [<Fact>]
  let ``WordPress.Posts getAllAsync with non-empty response``  () =
    let response = readFixture "AllPosts.json"
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient response; }

    WordPress.Posts.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.NotEmpty

  [<Fact>]
  let ``WordPress.Posts getAllAsync with non-empty response + embeds`` () =
    let response = readFixture "AllPostsWithEmbed.json"
    let options =
      { defaultOptions with
          apiHost = "localhost";
          apiClient = apiClient response; }

    WordPress.Posts.getAllAsync options
    |> Async.RunSynchronously
    |> Assert.NotEmpty
