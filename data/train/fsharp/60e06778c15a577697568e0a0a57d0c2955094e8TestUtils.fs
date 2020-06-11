[<AutoOpen>]
module EveLib.Tests.TestUtils

    open System.IO
    open System.Reflection
    open System.Xml.Linq
    open EveLib
    open EveLib.FSharp
    open Xunit

    /// Loads the api key from an xml file not in source control,
    /// located in the "packages" folder.
    let apiKey =
        let asm = Assembly.GetExecutingAssembly()
        let apiFile = @"D:\Projects\EveLib\packages\ApiKey.xml"
        let doc = XDocument.Load(apiFile)
        let root = doc.Root
        { Id = root.Element(xn "id") |> int
          VCode = root.Element(xn "vCode").Value
          AccessMask = root.Element(xn "accessMask") |> int }

