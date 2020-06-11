#I __SOURCE_DIRECTORY__
#I "PACKAGES/FSHARP.DATA/LIB/NET40"
#I "PACKAGES/DEEDLE/LIB/NET40"
#I "PACKAGES/XPLOT.PLOTLY/LIB/NET45"
#I "PACKAGES/XPLOT.PLOTLY/LIB/NET45"


#load "packages/FsLab/FsLab.fsx"
#load "GitHub.fsx"

open System.IO
open System.Globalization
open System
open Deedle
open Foogle
open GitHub

type GitHubEvent = FSharp.Data.JsonProvider<"""   [

  {
    "type": "CreateEvent",
    "public": true,
    "payload": "{\"ref\":\"3.35\",\"ref_type\":\"tag\",\"master_branch\":\"master\",\"description\":\"\",\"pusher_type\":\"user\"}",
    "repo_id": "42523587",
    "repo_name": "naveensrinivasan/TestUpload",
    "repo_url": "https://api.github.com/repos/naveensrinivasan/TestUpload",
    "actor_id": "172697",
    "actor_login": "naveensrinivasan",
    "actor_gravatar_id": "",
    "actor_avatar_url": "https://avatars.githubusercontent.com/u/172697?",
    "actor_url": "https://api.github.com/users/naveensrinivasan",
    "id": "3366225505",
    "created_at": "2015-11-21 05:35:42 UTC"
  },
  {
    "type": "ReleaseEvent",
    "public": true,
    "payload": "{\"action\":\"published\",\"release\":{\"url\":\"https://api.github.com/repos/naveensrinivasan/TestUpload/releases/2164529\",\"assets_url\":\"https://api.github.com/repos/naveensrinivasan/TestUpload/releases/2164529/assets\",\"upload_url\":\"https://uploads.github.com/repos/naveensrinivasan/TestUpload/releases/2164529/assets{?name,label}\",\"html_url\":\"https://github.com/naveensrinivasan/TestUpload/releases/tag/3.35\",\"id\":2164529,\"tag_name\":\"3.35\",\"target_commitish\":\"master\",\"name\":null,\"draft\":false,\"author\":{\"login\":\"naveensrinivasan\",\"id\":172697,\"avatar_url\":\"https://avatars.githubusercontent.com/u/172697?v=3\",\"gravatar_id\":\"\",\"url\":\"https://api.github.com/users/naveensrinivasan\",\"html_url\":\"https://github.com/naveensrinivasan\",\"followers_url\":\"https://api.github.com/users/naveensrinivasan/followers\",\"following_url\":\"https://api.github.com/users/naveensrinivasan/following{/other_user}\",\"gists_url\":\"https://api.github.com/users/naveensrinivasan/gists{/gist_id}\",\"starred_url\":\"https://api.github.com/users/naveensrinivasan/starred{/owner}{/repo}\",\"subscriptions_url\":\"https://api.github.com/users/naveensrinivasan/subscriptions\",\"organizations_url\":\"https://api.github.com/users/naveensrinivasan/orgs\",\"repos_url\":\"https://api.github.com/users/naveensrinivasan/repos\",\"events_url\":\"https://api.github.com/users/naveensrinivasan/events{/privacy}\",\"received_events_url\":\"https://api.github.com/users/naveensrinivasan/received_events\",\"type\":\"User\",\"site_admin\":false},\"prerelease\":false,\"created_at\":\"2015-09-15T08:37:09Z\",\"published_at\":\"2015-11-21T05:35:41Z\",\"assets\":[],\"tarball_url\":\"https://api.github.com/repos/naveensrinivasan/TestUpload/tarball/3.35\",\"zipball_url\":\"https://api.github.com/repos/naveensrinivasan/TestUpload/zipball/3.35\",\"body\":null}}",
    "repo_id": "42523587",
    "repo_name": "naveensrinivasan/TestUpload",
    "repo_url": "https://api.github.com/repos/naveensrinivasan/TestUpload",
    "actor_id": "172697",
    "actor_login": "naveensrinivasan",
    "actor_gravatar_id": "",
    "actor_avatar_url": "https://avatars.githubusercontent.com/u/172697?",
    "actor_url": "https://api.github.com/users/naveensrinivasan",
    "id": "3366225510",
    "created_at": "2015-11-21 05:35:42 UTC"
  }
]
""">

type PullRequest = FSharp.Data.JsonProvider<"""
{
  "action": "opened",
  "number": 24,
  "pull_request": {
    "url": "https://api.github.com/repos/mono/docker/pulls/24",
    "id": 51435355,
    "html_url": "https://github.com/mono/docker/pull/24",
    "diff_url": "https://github.com/mono/docker/pull/24.diff",
    "patch_url": "https://github.com/mono/docker/pull/24.patch",
    "issue_url": "https://api.github.com/repos/mono/docker/issues/24",
    "number": 24,
    "state": "open",
    "locked": false,
    "title": "Updated Dockerfile to the correct version",
    "user": {
      "login": "naveensrinivasan",
      "id": 172697,
      "avatar_url": "https://avatars.githubusercontent.com/u/172697?v=3",
      "gravatar_id": "",
      "url": "https://api.github.com/users/naveensrinivasan",
      "html_url": "https://github.com/naveensrinivasan",
      "followers_url": "https://api.github.com/users/naveensrinivasan/followers",
      "following_url": "https://api.github.com/users/naveensrinivasan/following{/other_user}",
      "gists_url": "https://api.github.com/users/naveensrinivasan/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/naveensrinivasan/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/naveensrinivasan/subscriptions",
      "organizations_url": "https://api.github.com/users/naveensrinivasan/orgs",
      "repos_url": "https://api.github.com/users/naveensrinivasan/repos",
      "events_url": "https://api.github.com/users/naveensrinivasan/events{/privacy}",
      "received_events_url": "https://api.github.com/users/naveensrinivasan/received_events",
      "type": "User",
      "site_admin": false
    },
    "body": "The latest Dockerfile had reference to version `4.0.0` instead of `4.2.1`",
    "created_at": "2015-11-21T06:39:36Z",
    "updated_at": "2015-11-21T06:39:36Z",
    "closed_at": null,
    "merged_at": null,
    "merge_commit_sha": null,
    "assignee": null,
    "milestone": null,
    "commits_url": "https://api.github.com/repos/mono/docker/pulls/24/commits",
    "review_comments_url": "https://api.github.com/repos/mono/docker/pulls/24/comments",
    "review_comment_url": "https://api.github.com/repos/mono/docker/pulls/comments{/number}",
    "comments_url": "https://api.github.com/repos/mono/docker/issues/24/comments",
    "statuses_url": "https://api.github.com/repos/mono/docker/statuses/523ff11184761b702161e44156e7915b8df66353",
    "head": {
      "label": "naveensrinivasan:patch-1",
      "ref": "patch-1",
      "sha": "523ff11184761b702161e44156e7915b8df66353",
      "user": {
        "login": "naveensrinivasan",
        "id": 172697,
        "avatar_url": "https://avatars.githubusercontent.com/u/172697?v=3",
        "gravatar_id": "",
        "url": "https://api.github.com/users/naveensrinivasan",
        "html_url": "https://github.com/naveensrinivasan",
        "followers_url": "https://api.github.com/users/naveensrinivasan/followers",
        "following_url": "https://api.github.com/users/naveensrinivasan/following{/other_user}",
        "gists_url": "https://api.github.com/users/naveensrinivasan/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/naveensrinivasan/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/naveensrinivasan/subscriptions",
        "organizations_url": "https://api.github.com/users/naveensrinivasan/orgs",
        "repos_url": "https://api.github.com/users/naveensrinivasan/repos",
        "events_url": "https://api.github.com/users/naveensrinivasan/events{/privacy}",
        "received_events_url": "https://api.github.com/users/naveensrinivasan/received_events",
        "type": "User",
        "site_admin": false
      },
      "repo": {
        "id": 46364493,
        "name": "docker",
        "full_name": "naveensrinivasan/docker",
        "owner": {
          "login": "naveensrinivasan",
          "id": 172697,
          "avatar_url": "https://avatars.githubusercontent.com/u/172697?v=3",
          "gravatar_id": "",
          "url": "https://api.github.com/users/naveensrinivasan",
          "html_url": "https://github.com/naveensrinivasan",
          "followers_url": "https://api.github.com/users/naveensrinivasan/followers",
          "following_url": "https://api.github.com/users/naveensrinivasan/following{/other_user}",
          "gists_url": "https://api.github.com/users/naveensrinivasan/gists{/gist_id}",
          "starred_url": "https://api.github.com/users/naveensrinivasan/starred{/owner}{/repo}",
          "subscriptions_url": "https://api.github.com/users/naveensrinivasan/subscriptions",
          "organizations_url": "https://api.github.com/users/naveensrinivasan/orgs",
          "repos_url": "https://api.github.com/users/naveensrinivasan/repos",
          "events_url": "https://api.github.com/users/naveensrinivasan/events{/privacy}",
          "received_events_url": "https://api.github.com/users/naveensrinivasan/received_events",
          "type": "User",
          "site_admin": false
        },
        "private": false,
        "html_url": "https://github.com/naveensrinivasan/docker",
        "description": "Docker images, for the Docker container system",
        "fork": true,
        "url": "https://api.github.com/repos/naveensrinivasan/docker",
        "forks_url": "https://api.github.com/repos/naveensrinivasan/docker/forks",
        "keys_url": "https://api.github.com/repos/naveensrinivasan/docker/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/naveensrinivasan/docker/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/naveensrinivasan/docker/teams",
        "hooks_url": "https://api.github.com/repos/naveensrinivasan/docker/hooks",
        "issue_events_url": "https://api.github.com/repos/naveensrinivasan/docker/issues/events{/number}",
        "events_url": "https://api.github.com/repos/naveensrinivasan/docker/events",
        "assignees_url": "https://api.github.com/repos/naveensrinivasan/docker/assignees{/user}",
        "branches_url": "https://api.github.com/repos/naveensrinivasan/docker/branches{/branch}",
        "tags_url": "https://api.github.com/repos/naveensrinivasan/docker/tags",
        "blobs_url": "https://api.github.com/repos/naveensrinivasan/docker/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/naveensrinivasan/docker/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/naveensrinivasan/docker/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/naveensrinivasan/docker/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/naveensrinivasan/docker/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/naveensrinivasan/docker/languages",
        "stargazers_url": "https://api.github.com/repos/naveensrinivasan/docker/stargazers",
        "contributors_url": "https://api.github.com/repos/naveensrinivasan/docker/contributors",
        "subscribers_url": "https://api.github.com/repos/naveensrinivasan/docker/subscribers",
        "subscription_url": "https://api.github.com/repos/naveensrinivasan/docker/subscription",
        "commits_url": "https://api.github.com/repos/naveensrinivasan/docker/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/naveensrinivasan/docker/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/naveensrinivasan/docker/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/naveensrinivasan/docker/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/naveensrinivasan/docker/contents/{+path}",
        "compare_url": "https://api.github.com/repos/naveensrinivasan/docker/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/naveensrinivasan/docker/merges",
        "archive_url": "https://api.github.com/repos/naveensrinivasan/docker/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/naveensrinivasan/docker/downloads",
        "issues_url": "https://api.github.com/repos/naveensrinivasan/docker/issues{/number}",
        "pulls_url": "https://api.github.com/repos/naveensrinivasan/docker/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/naveensrinivasan/docker/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/naveensrinivasan/docker/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/naveensrinivasan/docker/labels{/name}",
        "releases_url": "https://api.github.com/repos/naveensrinivasan/docker/releases{/id}",
        "created_at": "2015-11-17T17:46:43Z",
        "updated_at": "2015-11-17T17:46:44Z",
        "pushed_at": "2015-11-21T06:39:07Z",
        "git_url": "git://github.com/naveensrinivasan/docker.git",
        "ssh_url": "git@github.com:naveensrinivasan/docker.git",
        "clone_url": "https://github.com/naveensrinivasan/docker.git",
        "svn_url": "https://github.com/naveensrinivasan/docker",
        "homepage": null,
        "size": 20,
        "stargazers_count": 0,
        "watchers_count": 0,
        "language": "Shell",
        "has_issues": false,
        "has_downloads": true,
        "has_wiki": true,
        "has_pages": false,
        "forks_count": 0,
        "mirror_url": null,
        "open_issues_count": 0,
        "forks": 0,
        "open_issues": 0,
        "watchers": 0,
        "default_branch": "master"
      }
    },
    "base": {
      "label": "mono:master",
      "ref": "master",
      "sha": "93f8a2bfe90a00998a4522ea811dd2e4512d6e1d",
      "user": {
        "login": "mono",
        "id": 53395,
        "avatar_url": "https://avatars.githubusercontent.com/u/53395?v=3",
        "gravatar_id": "",
        "url": "https://api.github.com/users/mono",
        "html_url": "https://github.com/mono",
        "followers_url": "https://api.github.com/users/mono/followers",
        "following_url": "https://api.github.com/users/mono/following{/other_user}",
        "gists_url": "https://api.github.com/users/mono/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/mono/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/mono/subscriptions",
        "organizations_url": "https://api.github.com/users/mono/orgs",
        "repos_url": "https://api.github.com/users/mono/repos",
        "events_url": "https://api.github.com/users/mono/events{/privacy}",
        "received_events_url": "https://api.github.com/users/mono/received_events",
        "type": "Organization",
        "site_admin": false
      },
      "repo": {
        "id": 25306699,
        "name": "docker",
        "full_name": "mono/docker",
        "owner": {
          "login": "mono",
          "id": 53395,
          "avatar_url": "https://avatars.githubusercontent.com/u/53395?v=3",
          "gravatar_id": "",
          "url": "https://api.github.com/users/mono",
          "html_url": "https://github.com/mono",
          "followers_url": "https://api.github.com/users/mono/followers",
          "following_url": "https://api.github.com/users/mono/following{/other_user}",
          "gists_url": "https://api.github.com/users/mono/gists{/gist_id}",
          "starred_url": "https://api.github.com/users/mono/starred{/owner}{/repo}",
          "subscriptions_url": "https://api.github.com/users/mono/subscriptions",
          "organizations_url": "https://api.github.com/users/mono/orgs",
          "repos_url": "https://api.github.com/users/mono/repos",
          "events_url": "https://api.github.com/users/mono/events{/privacy}",
          "received_events_url": "https://api.github.com/users/mono/received_events",
          "type": "Organization",
          "site_admin": false
        },
        "private": false,
        "html_url": "https://github.com/mono/docker",
        "description": "Docker images, for the Docker container system",
        "fork": false,
        "url": "https://api.github.com/repos/mono/docker",
        "forks_url": "https://api.github.com/repos/mono/docker/forks",
        "keys_url": "https://api.github.com/repos/mono/docker/keys{/key_id}",
        "collaborators_url": "https://api.github.com/repos/mono/docker/collaborators{/collaborator}",
        "teams_url": "https://api.github.com/repos/mono/docker/teams",
        "hooks_url": "https://api.github.com/repos/mono/docker/hooks",
        "issue_events_url": "https://api.github.com/repos/mono/docker/issues/events{/number}",
        "events_url": "https://api.github.com/repos/mono/docker/events",
        "assignees_url": "https://api.github.com/repos/mono/docker/assignees{/user}",
        "branches_url": "https://api.github.com/repos/mono/docker/branches{/branch}",
        "tags_url": "https://api.github.com/repos/mono/docker/tags",
        "blobs_url": "https://api.github.com/repos/mono/docker/git/blobs{/sha}",
        "git_tags_url": "https://api.github.com/repos/mono/docker/git/tags{/sha}",
        "git_refs_url": "https://api.github.com/repos/mono/docker/git/refs{/sha}",
        "trees_url": "https://api.github.com/repos/mono/docker/git/trees{/sha}",
        "statuses_url": "https://api.github.com/repos/mono/docker/statuses/{sha}",
        "languages_url": "https://api.github.com/repos/mono/docker/languages",
        "stargazers_url": "https://api.github.com/repos/mono/docker/stargazers",
        "contributors_url": "https://api.github.com/repos/mono/docker/contributors",
        "subscribers_url": "https://api.github.com/repos/mono/docker/subscribers",
        "subscription_url": "https://api.github.com/repos/mono/docker/subscription",
        "commits_url": "https://api.github.com/repos/mono/docker/commits{/sha}",
        "git_commits_url": "https://api.github.com/repos/mono/docker/git/commits{/sha}",
        "comments_url": "https://api.github.com/repos/mono/docker/comments{/number}",
        "issue_comment_url": "https://api.github.com/repos/mono/docker/issues/comments{/number}",
        "contents_url": "https://api.github.com/repos/mono/docker/contents/{+path}",
        "compare_url": "https://api.github.com/repos/mono/docker/compare/{base}...{head}",
        "merges_url": "https://api.github.com/repos/mono/docker/merges",
        "archive_url": "https://api.github.com/repos/mono/docker/{archive_format}{/ref}",
        "downloads_url": "https://api.github.com/repos/mono/docker/downloads",
        "issues_url": "https://api.github.com/repos/mono/docker/issues{/number}",
        "pulls_url": "https://api.github.com/repos/mono/docker/pulls{/number}",
        "milestones_url": "https://api.github.com/repos/mono/docker/milestones{/number}",
        "notifications_url": "https://api.github.com/repos/mono/docker/notifications{?since,all,participating}",
        "labels_url": "https://api.github.com/repos/mono/docker/labels{/name}",
        "releases_url": "https://api.github.com/repos/mono/docker/releases{/id}",
        "created_at": "2014-10-16T14:43:42Z",
        "updated_at": "2015-11-17T20:01:08Z",
        "pushed_at": "2015-11-17T21:25:09Z",
        "git_url": "git://github.com/mono/docker.git",
        "ssh_url": "git@github.com:mono/docker.git",
        "clone_url": "https://github.com/mono/docker.git",
        "svn_url": "https://github.com/mono/docker",
        "homepage": null,
        "size": 28,
        "stargazers_count": 46,
        "watchers_count": 46,
        "language": "Shell",
        "has_issues": true,
        "has_downloads": true,
        "has_wiki": true,
        "has_pages": false,
        "forks_count": 18,
        "mirror_url": null,
        "open_issues_count": 14,
        "forks": 18,
        "open_issues": 14,
        "watchers": 46,
        "default_branch": "master"
      }
    },
    "_links": {
      "self": {
        "href": "https://api.github.com/repos/mono/docker/pulls/24"
      },
      "html": {
        "href": "https://github.com/mono/docker/pull/24"
      },
      "issue": {
        "href": "https://api.github.com/repos/mono/docker/issues/24"
      },
      "comments": {
        "href": "https://api.github.com/repos/mono/docker/issues/24/comments"
      },
      "review_comments": {
        "href": "https://api.github.com/repos/mono/docker/pulls/24/comments"
      },
      "review_comment": {
        "href": "https://api.github.com/repos/mono/docker/pulls/comments{/number}"
      },
      "commits": {
        "href": "https://api.github.com/repos/mono/docker/pulls/24/commits"
      },
      "statuses": {
        "href": "https://api.github.com/repos/mono/docker/statuses/523ff11184761b702161e44156e7915b8df66353"
      }
    },
    "merged": false,
    "mergeable": null,
    "mergeable_state": "unknown",
    "merged_by": null,
    "comments": 0,
    "review_comments": 0,
    "commits": 1,
    "additions": 1,
    "deletions": 1,
    "changed_files": 1
  }
}""">

type GitHuBPR = {Opened : DateTime;
      Merged:Option<DateTime>;
      Author : string ;
      Comments : int;
      Repo : string;
      Id: int}


let keyvalues =   fun (key,values) -> (key, values |> Seq.length)
let stringkeyvalues =   fun (key,values) -> (key.ToString(), values |> Seq.length)
let PR = "PullRequestEvent"

let fsharpeventsjson = Path.Combine(__SOURCE_DIRECTORY__, "fsharporg2015githubevents.json")


let pullrequests (e)  =
     GitHubEvent.Parse e |> Seq.filter(fun f ->  try  f.Type = PR with e -> false )
                |> Seq.map(fun f -> f.Payload.Replace("\\",""))  // replacing json escape character
                |> Seq.map(fun f -> try Some(PullRequest.Parse(f)) with e -> None)
                |> Seq.filter(fun f -> f.IsSome)
                |> Seq.map(fun f -> f.Value)
                |> Seq.map(fun f -> {Opened = f.PullRequest.CreatedAt;
                                        Merged = (try Some(DateTime.Parse(f.PullRequest
                                                        .MergedAt.JsonValue.ToString().Replace("\"","")))
                                                    with e -> None);
                                      Author = f.PullRequest.User.Login;
                                      Comments = f.PullRequest.ReviewComments;
                                      Repo = f.PullRequest.Base.Repo.Name;
                                      Id = f.PullRequest.Id})

let top10Repos (githubprs:seq<GitHuBPR>) = githubprs
                                             |> Seq.groupBy (fun x -> x.Repo)
                                             |> Seq.map keyvalues
                                             |> Seq.sortBy(fun f -> - (snd f))
                                             |> Seq.take(10)

let prsByMonth (githubprs:seq<GitHuBPR>) = githubprs
                                         |> Seq.groupBy (fun f -> DateTimeFormatInfo.CurrentInfo.GetAbbreviatedMonthName( f.Opened.Month))
                                         |> Seq.map keyvalues
                                         |> Seq.sortBy(fun f -> - snd f )

let prsByMonthForaRepo (githubprs:seq<GitHuBPR>)
                          (e:string) =
                                        githubprs |> Seq.filter(fun f-> f.Repo = e)
                                                     |> Seq.groupBy (fun f -> DateTimeFormatInfo.CurrentInfo.GetAbbreviatedMonthName( f.Opened.Month))
                                                     |> Seq.map keyvalues
                                                     |> Seq.sortBy(fun f -> - snd f  )


let prsByHour (githubprs:seq<GitHuBPR>) = githubprs
                                             |> Seq.groupBy (fun f -> f.Opened.ToUniversalTime().Hour)
                                             |> Seq.map stringkeyvalues
                                             |> Seq.sortBy(fun f -> - snd f)
                                             |> Seq.take(10)

let top10contributorsByPR (githubprs:seq<GitHuBPR>) =
                githubprs
                     |> Seq.groupBy (fun f -> f.Author)
                     |> Seq.map keyvalues
                     |> Seq.sortBy(fun f -> - snd f)
                     |> Seq.take(10)


let durationToMergePRByRepo (githubprs:seq<GitHuBPR>) =
                githubprs
                        |> Seq.filter(fun f -> f.Merged.IsSome)
                        |> Seq.map(fun f ->(f.Repo,
                                            f.Merged.Value.ToUniversalTime().Subtract(f.Opened.ToUniversalTime()).Hours))
                        |> Seq.groupBy(fun f -> (fst f))
                        |> Seq.map keyvalues

let fsharpevents = File.ReadAllText  fsharpeventsjson

let fsharpPRs = pullrequests fsharpevents |> Seq.toList

let ``10repos`` = fsharpPRs |>  top10Repos

fsharpPRs |>  top10Repos
          |> Chart.PieChart
          |> Chart.WithTitle "Top 10 FSharp Repo's in 2015 By PR's"

fsharpPRs |>  top10contributorsByPR  |> Chart.PieChart |> Chart.WithTitle "Top 10 GitHub Contributors in FSharp org in 2015 "

fsharpPRs |>  prsByMonth|> Chart.PieChart |>  Chart.WithTitle "FSharp PR's By Month"

fsharpPRs |> prsByHour  |> Chart.PieChart |> Chart.WithTitle "FSharp PR's by the hour of the day"

let reponames =``10repos``  
                |> Seq.sortBy(fun f -> - (snd f)) |> Seq.map(fun f -> fst f) |> Seq.take(2)

let toprepo = reponames |> Seq.head

let secondtoprepo = reponames |> Seq.nth 1

let toprepopr = fsharpPRs |> Seq.filter (fun f -> f.Repo = toprepo) |> Seq.map(fun f -> ( f.Opened.Hour)) 

let secondtoprepopr = fsharpPRs |> Seq.filter (fun f -> f.Repo = secondtoprepo) |> Seq.map(fun f -> ( f.Opened.Hour)) 
let df = Series(toprepopr,secondtoprepopr) 
