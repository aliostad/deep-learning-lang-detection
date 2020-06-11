﻿module Args

open Argu
open Common

let options = OpenQA.Selenium.Chrome.ChromeOptions()
options.AddArguments("--disable-extensions")
let defaultBrowser = canopy.types.BrowserStartMode.ChromeWithOptions(options)

type private CLIArguments =
  | Browser of string
  | Tag of string
  | TestType of string
  with
    interface IArgParserTemplate with
      member s.Usage =
        match s with
        | Browser _ -> "specicfy a browser (Chrome Firefox IE)."
        | Tag _ -> "specify tag (All Misc etc)."
        | TestType _ -> "specify testType (All Smoke Full UnderDevelopment)."

let parse cliargs =
    let parser = ArgumentParser.Create<CLIArguments>()
    let results = parser.Parse(cliargs)

    {
        Browser = defaultArg (results.TryPostProcessResult (<@ Browser @>, fromString<canopy.types.BrowserStartMode>)) defaultBrowser
        Tag = defaultArg (results.TryPostProcessResult (<@ Tag @>, fromString<Tag>)) Tag.All
        TestType = defaultArg (results.TryPostProcessResult (<@ TestType @>, fromString<TestType>)) TestType.Smoke
    }
