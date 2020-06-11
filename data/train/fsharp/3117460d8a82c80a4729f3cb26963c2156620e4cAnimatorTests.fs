namespace GitHubAnimator

    module AnimatorTests =
        open NUnit.Framework
        open FsUnit
        open Animator
        open Octokit

        let parameters = { Owner = "pedromsantos"; Repository = "FSharpKatas"; File="Bowling.fs"; Language = "language-fsharp" }

        [<Test>]
        [<Ignore("To avoid hitting github API request limits")>]
        let ``Should create git hub client from token``() =
            createClient |> should be ofExactType<GitHubClient>

        [<Test>]
        [<Ignore("To avoid hitting github API request limits")>]
        let ``Should get all commits for repository``() =
            createClient
            |> commits parameters
            |> Async.RunSynchronously
            |> should not' (be Empty) 

        [<Test>]
        [<Ignore("To avoid hitting github API request limits")>]
        let ``Should get all commits for repository that touch a file``() =
            createClient
            |> fileCommits parameters
            |> should not' (be Empty)

        [<Test>]
        [<Ignore("To avoid hitting github API request limits")>]
        let ``Should get all changes for a file``() =
            createClient
            |> fileChanges parameters
            |> should not' (be Empty)

        [<Test>]
        [<Ignore("To avoid hitting github API request limits")>]
        let ``Should get all raw url for changes in a file``() =
            createClient
            |> rawUrlFileChanges parameters
            |> should not' (be Empty)

        [<Test>]
        [<Ignore("To avoid hitting github API request limits")>]
        let ``Should get all file changes``() =
            createClient
            |> rawFileChanges parameters
            |> Async.RunSynchronously
            |> should not' (be Empty)

        [<Test>]
        [<Ignore("To avoid hitting github API request limits")>]
        let ``Should create presentation``() =
            createClient
            |> createPresentation parameters
            |> printfn "%s"

        [<Test>]
        [<Ignore("To avoid hitting github API request limits")>]
        let ``Should save presentation``() =
            createClient
            |> createPresentation parameters
            |> savePresentation 
                "C:\\src\GitHubAnimator\\reveal.js" 
                "C:\\src\\GitHubAnimator\\Presentation"

