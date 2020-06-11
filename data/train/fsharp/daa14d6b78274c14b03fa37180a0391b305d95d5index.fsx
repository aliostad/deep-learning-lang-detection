(**
- title : SlackTypeProvider 
- description : Introduction to SlackTypeProvider
- author : Romain Flechner
- theme : league
- transition : default

***

#Slack TypeProvider

![Image of LoveFsharp](images/IHeartFsharp160.png)
![Image of SlackLogo](images/slack_rgb_small.png)

<small>
by [@rflechner](https://twitter.com/rflechner)
</small>

***

## What is Slack TypeProvider?

- A small F# library providing properties and methods generated form Slack API
- An experimental use of F# Type Providers

***

## What is the use?

- Write a little bot sending messages on Slack with an autocomplete on user or channel list.

***

## Getting started

Get an API token

#### Method1: Using your account

Get your token at url: https://api.slack.com/tokens

#### Method2: Create a bot account

Go to https://{your_company}.slack.com/apps/manage 

Then click on "Custom Integrations" and "Bots"

***

## NuGet

Get the [NuGet package](https://www.nuget.org/packages/SlackTypeProvider/)

***

### Is it easy to use ?

*)

(*** hide ***)
#I @"../../packages/Newtonsoft.Json/lib/net40"
#r "Newtonsoft.Json.dll"
#I "../../src/SlackTypeProvider/bin/Debug"
#r "SlackTypeProvider.dll"

open System
open System.IO
open System.Net

(**
See example below

![Image of example1](images/SlackProvider3.gif)

---

*)

open SlackProvider

//You can provide a file path or an URL or a raw token
type TSlack = SlackTypeProvider<token="C:/keys/slack_token.txt">
let slack = TSlack()

slack.Channels.xamarininsights.Send("test")
slack.Users.romain_flechner.Send("Hi !")

// Or with custom image and/or name
slack.Users.romain_flechner
    .Send("I am a bot",
        botname="robot 4", 
        iconUrl="http://statics.romcyber.com/icones/robot1_48x48.jpg")

(**
***

# For FAKE users

See [FAKE](http://fsharp.github.io/FAKE/) website.

***

## Modify your build.cmd or build.bat

In a project using NuGet, you can have something like:

    [lang=shell]
    @echo off
    cls
    ".nuget\NuGet.exe" "Install" "FAKE" 
        "-OutputDirectory" "packages" "-ExcludeVersion"
    ".nuget\NuGet.exe" "Install" "SlackTypeProvider" 
        "-OutputDirectory" "packages" "-ExcludeVersion"
    ".nuget\NuGet.exe" "Install" "Newtonsoft.Json" 
        "-OutputDirectory" "packages" "-Version" "8.0.2"
    "packages\FAKE\tools\Fake.exe" build.fsx %2

---

If you are using Paket, simply append next lines in your paket.dependencies:

    [lang=paket]
    group Build
        source https://nuget.org/api/v2
        nuget Newtonsoft.Json
        nuget SlackTypeProvider

***

## Modify your build.fsx

Load assemblies

__ With NuGet __

    [lang=fsharp]
    #r "packages/Newtonsoft.Json.8.0.2/lib/net45/Newtonsoft.Json.dll"
    #r "packages/SlackTypeProvider/lib/net40/SlackTypeProvider.dll"

---

__ With the Paket example __

    [lang=fsharp]
    #r "packages/build/Newtonsoft.Json/lib/net45/Newtonsoft.Json.dll"
    #r "packages/build/SlackTypeProvider/lib/net40/SlackTypeProvider.dll"

---

Then you will be able to add slack notifications in your targets

    [lang=fsharp]
    Target "NotifyAppReleased" (fun _ ->
        slack.Channels.general.Send "Hi !"
        slack.Channels.general.
            Send "A new Android version of MyApp is on HockeyApp."
    )

***

*)

