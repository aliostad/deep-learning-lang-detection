(*** raw ***)
---
layout: page
title: F# end to end
---
(*** hide ***)
#I @"..\packages\FAKE\tools";
#r "FakeLib.dll";

#I @"..\packages\FSharpx.TypeProviders.Xaml\lib\40"
#r "PresentationFramework.dll"
#r "PresentationCore.dll"
#r "WindowsBase.dll"
#r "System.Xaml.dll"
#r "FSharpx.TypeProviders.Xaml.dll"

#I @"..\tools"
#r "FSharp.Literate.dll"
#r "FSharp.Markdown.dll"
#r "FSharp.CodeFormat.dll"

(**
##Introduction
Recently my colleague [@simontcousins](https://twitter.com/simontcousins) published an article comparing to similar projects one written 
in C# one written in F#. The conclusion is that for the two projects the F# one is about 4% of the size.
You can read more about this [here](http://www.simontylercousins.net/journal/2013/2/22/does-the-language-you-choose-make-a-difference.html).

Now normally, a typical project comprises of several languages / technologies.

 * Application Code -> C#
 * Build -> MSBuild/Nant
 * Deploy -> Powershell script/Batch script
 * UI (Web) -> HTML/Javascript
 * Documentation -&gt; Word/HTML

However the F# project in question here has a profile more like this,

 * Application Code -> F#
 * Build -> F#
 * Deploy -> F#
 * UI (Web) -> HTML/CSS/Javascript
 * Documentation -> F#

Note the stack is 'almost' completely F# (we actually could have made this completely F# see below). Maybe I'm biased but I think that this is a huge benefit for 
maintainability I only need to have my F# brain switched on and I can change any part of the application. Sure I have to learn a few 
libraries, but the playfulness offered by the REPL here makes testing and experimenting easy; this is especially true when it comes writing 
build and deployment scripts, which I normally find quiet difficult to test.

##Full stack F#

So is it possible to use F# for everything Build, Deployment, UI (Web/WPF), Documentation. The answer is simply YES!! 
There is just a few libraries we need to know about to achieve this. Lets look at each area of a typical application and see which 
libraries we can use.

###Application Logic

Ok this might seem like an obvious one, just write F#, but I thought I'd use this as an opportunity to highlight some libraries that I find useful

 * [FSharpx]("http://fsharp.github.com/fsharpx/") - Contains lots of extensions to the F# core modules, many useful data structures, commonly used monads, validation, <a href="http://msdn.microsoft.com/en-gb/library/hh156509.aspx" target="_blank">type providers</a>, async extensions etc.</li>
 * [FSharp.Data]("http://tpetricek.github.com/FSharp.Data") - Contains implementation of various type providers such as CSV, XML and JSON and I'm sure as the library matures we will see a lot more implementations to connect to wide variety of data sources.</li>
	
###Build and Deployment

To build and deploy application with F# we can use [FAKE](http://fsharp.github.com/FAKE). FAKE allows you to write your build and 
deployment scripts in F#. A simple script might look something like this
*)

// include Fake libs
open Fake

//Define Targets

Description "Cleans the last build"
Target "Clean" (fun () ->
    trace " --- Cleaning stuff --- "
)

Target "Build" (fun () ->
    trace " --- Building the app --- "
)

Target "Deploy" (fun () ->
    trace " --- Deploying app --- "
)

//Define Dependencies
"Clean"
  ==> "Build"
  ==> "Deploy"

//Start Build
RunParameterTargetOrDefault "target" "Deploy"


(**
The really nice thing about this is you have the full .NET framework and the full power of F# available in your scripts. Additionally FAKE 
also has an accompanying website, which allows you to manage your deployment agents, so you can easily deploy, upgrade or rollback 
applications from a central place.

###UI

How you tackle writing a UI in F# obviously depends on your choice of technologies. There are others obviously but the two I'm going to 
consider are WPF and HTML/CSS/Javascript.

####WPF
If you choose to write your UI using WPF then things are fairly straight forward, Write XAML markup and then use code behind F#. 
However wiring up the code behind can be a pain because of the C# code gen involved, typically you have to load the view yourself 
using a XAML reader, or code the view layout in F# as in these series of examples from [John Laio](http://blogs.msdn.com/b/dsyme/archive/2008/01/05/learning-wpf-through-f-and-vice-versa-by-john-liao.aspx?Redirected=true). 
If however you want to keep XAML markup then FSharpx has a [XAML type provider](https://github.com/fsharp/fsharpx/tree/master/src/FSharpx.TypeProviders.Xaml) 
that helps things along here.
*)

open System
open System.Windows
open System.Windows.Controls
open FSharpx

type MainWindow = XAML<"libs/MainWindow.xaml">

let loadWindow() =
    let window = MainWindow()
    window.myButton.Click.Add(fun _ ->
        MessageBox.Show("Hello world!")
        |> ignore)
    window.Root

[<STAThread>]
let main(args) = (new Application()).Run(loadWindow())

(**
See [Steffan Forkmann's](http://www.navision-blog.de/blog/2012/03/22/wpf-designer-for-f/) post for more information about this. 
Lets also not forget about first class events and the asynchronous programming model in F# that makes writing responsive UI's that much easier. 

####HTML/CSS/Javascript

If you go webby then things get a little more interesting, we have several options available here.

 * [WebSharper](http://www.websharper.com/home) - This is a very complete web framework, I have not personally played with it yet but I understand it does everything you'd want and more. Well worth checking out.
 * [FunScript](https://github.com/ZachBray/FunScript) - A new project, but it exploits the power of type providers to offer strongly typed access to TypeScript files [@thomaspetricek](http://tomasp.net/blog/) has a nice talk about it. 
 With fun script you still have to write the HTML markup, although providing a Combinator library to emit the markup wouldn't be that difficult. (If some one knows of one I'll add it here), but this isn't application logic anyway. The important stuff is still written in F# and compiled to javascript later on.

###Documentation

[@thomaspetricek](http://tomasp.net/blog/) recently released [FSharp.Formatting](https://github.com/tpetricek/FSharp.Formatting) we can generate documentation 
from an F# script file, using a mix of markdown and F#, for an example see this [link](http://tpetricek.github.com/FSharp.Formatting/). This can then be integrated into your FAKE build script, 
using a build target something like the following example, Incidentally this is exactly the library that is used to create this blog.
*)

open System.IO
open FSharp.Literate

Target "Docs" (fun _ -> 
    let template = Path.Combine(currentDirectory, "template.html")
    let sources = Path.Combine(__SOURCE_DIRECTORY__, "samples")
    let output = "out_dir"
    
    Literate.ProcessDirectory(sources, template, output)
)

(**
##Conclusion

Ok I might of over stated that <strong>everything</strong> can be written in F#, certainly at the moment there is a lack of libraries for 
emitting XAML and HTML (with the exception of WebSharper of course). But HTML and XAML are really inconsequential when it comes the to 
the correctness of your application they do not contain any logic which needs to be tested they simply control layout. The important thing 
to take from the above is the fact that all of your logic whether it is for build, deployment, UI interaction, example documentation can be 
written in a type safe way using the various libraries and F# feature spoken about above.
*)