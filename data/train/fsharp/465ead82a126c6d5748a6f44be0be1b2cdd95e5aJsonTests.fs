namespace Updater.Tests

open System
open Xunit
open FsUnit.Xunit
open Updater
open Updater.Json
open Updater.Model

type Foo = 
    { name : string
      active : bool }

type Foo2 = 
    { copy : bool option
      names : string list }

type Foo3 = 
    { layout : Map<string, string> }

type JsonTests() = 
    let emptyVars _ = None

    [<Fact>]
    let ``record serialize``() = 
        serialize { name = "John"; active = true }
        |> should equal """{
  "name": "John",
  "active": true
}"""
    
    [<Fact>]
    let ``record derialize``() = 
        deserialize<Foo> emptyVars "{\"name\":\"John\",\"active\":true}"
        |> should equal { name = "John"; active = true }
        
        deserialize<Foo> emptyVars "{\"name\":\"John\"}" 
        |> should equal { name = "John"; active = false }
    
    [<Fact>]
    let ``serialize option and list``() = 
        serialize { copy = Some(true); names = [ "a"; "b"; "c" ] }
        |> should equal """{
  "copy": true,
  "names": [
    "a",
    "b",
    "c"
  ]
}"""
        
        serialize { copy = None; names = [ "a"; "b"; "c" ] }
        |> should equal """{
  "names": [
    "a",
    "b",
    "c"
  ]
}"""
    
    [<Fact>]
    let ``deserialize option and list``() = 
        deserialize<Foo2> emptyVars "{\"copy\":true,\"names\":[\"a\",\"b\",\"c\"]}" 
        |> should equal { copy = Some(true); names = [ "a"; "b"; "c" ] }

        deserialize<Foo2> emptyVars "{\"names\":[\"a\",\"b\",\"c\"]}" 
        |> should equal { copy = None; names = [ "a"; "b"; "c" ] }
    
    [<Fact>]
    let ``serialize map``() = 
        serialize { layout = Map.ofList [ "a", "1"; "b", "2" ] }
        |> should equal """{
  "layout": {
    "a": "1",
    "b": "2"
  }
}"""

        serialize { layout = Map.empty } 
        |> should equal """{
  "layout": {}
}"""
    
    [<Fact>]
    let ``deserialize map``() = 
        deserialize<Foo3> emptyVars "{\"layout\":{\"a\":\"1\",\"b\":\"2\"}}" 
        |> should equal { layout = Map.ofList [ "a", "1"; "b", "2" ] }
        
        deserialize<Foo3> emptyVars "{\"layout\":{}}" 
        |> should equal { layout = Map.empty }

    [<Fact>]
    let ``deserialize resolve variables``() =
        let vars = Map.ofList ["filename", "test.txt"; "dir", "\\a"]

        let result = deserialize<Launch> vars.TryFind """{"target":"${dir}\\${filename}"}"""
        result |> should equal { target = "\\a\\test.txt"; args = None; workDir = None; expectExitCodes = None } 

    [<Fact>]
    let ``deserialize recurvise resolve variables``() =
        let vars = Map.ofList ["filename", "test.txt"; "dir", "\\a"]

        let result = deserialize<Launch> vars.TryFind """
        {
          "workDir":"${target}\\..",
          "target":"${dir}\\${filename}"
        }
        """
        result |> should equal { target = "\\a\\test.txt"; args = None; workDir = Some "\\a\\test.txt\\.."; expectExitCodes = None} 

    [<Fact>]
    let ``deserialize resolve env vars``() =
        let result = deserialize<Launch> emptyVars """{"target":"%windir%\\system32\\notepad.exe"}"""
        result |> should equal { target = (Environment.ExpandEnvironmentVariables "%windir%") @@ "system32\\notepad.exe"; args = None; workDir = None; expectExitCodes = None } 

    [<Fact>]
    let ``deserialize app manifest``() = 
        let json = """
{
  "app": {
    "name": "qzpc",
    "title": "QzPycharm",
    "version": "0.1",
    "channel": "release"
  },
  "pkgs": {
    "updater": "updater-1",
    "jre": "jre-1",
    "qzpc": "qzpc-0.1"
  },
  "layout": {
    "main": "qzpc",
    "deps": [
      {
        "pkg": "jre",
        "to": "jre"
      }
    ]
  },
  "shortcuts": [
    {
      "name": "${app.title}-${app.version}",
      "target": "${pkgs.updater}\\updater.exe ${fileName}",
      "icon": "${launch.target}"
    }
  ],
  "launch": {
    "target": "${pkgs.qzpc}\\bin\\pycharm64.exe"
  }
}        """
        let result = deserialize<Manifest> (pathVars "qzpc-test.json") json 
        result
        |> should equal { app = 
                            { name = "qzpc"
                              title = "QzPycharm"
                              version = "0.1"
                              channel = "release"
                              desc = None }
                          pkgs = 
                              Map.ofList [ "updater", "updater-1"
                                           "jre", "jre-1"
                                           "qzpc", "qzpc-0.1" ]
                          layout = 
                              { main = "qzpc"
                                deps = 
                                    [ { pkg = "jre"
                                        from = None
                                        ``to`` = Some "jre" 
                                        parent = None } ] }
                          shortcuts = 
                              [ { name = "QzPycharm-0.1"
                                  target = "updater-1\\updater.exe qzpc-test.json" 
                                  args = None
                                  workDir = None
                                  parentDir = None
                                  icon = Some "qzpc-0.1\\bin\\pycharm64.exe" } ]
                          launch = 
                              { target = "qzpc-0.1\\bin\\pycharm64.exe"
                                args = None
                                workDir = None
                                expectExitCodes = None }
                          actions = None }
