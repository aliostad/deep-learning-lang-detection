// Copyright (c) Narvalo.Org. All rights reserved. See LICENSE.txt in the project root for license information.

[<AutoOpen>]
module Helpers

open System
open System.Collections.Generic
open System.IO

open NuGet

/// Combines two path strings using Path.Combine. Borrowed from FAKE.
let inline combinePaths path1 (path2 : string) = Path.Combine(path1, path2.TrimStart [| '\\'; '/' |])

/// Combines two path strings using Path.Combine. Borrowed from FAKE.
let inline (++) path1 path2 = combinePaths path1 path2

/// Machine-wide settings for NuGet.
type MachineWideSettings(settings:IEnumerable<Settings>) =
    let _settings = settings

    interface IMachineWideSettings with
        member this.Settings
            with get() = _settings

/// Read the API Key from the settings.
let readApiKey (settings:ISettings) (key:string) =
    let apiKey = settings.GetDecryptedValue(Constants.ApiKeysSectionName, key)

    if String.IsNullOrWhiteSpace(apiKey)
    then failwithf "No API key could be found for the source: '%s'." key
    else apiKey

/// Load the NuGet settings.
let loadNuGetSettings =
    let baseDirectory = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData);
    let machineWideSettings =
        new MachineWideSettings(
            NuGet.Settings.LoadMachineWideSettings(new PhysicalFileSystem(baseDirectory)))

    // Personal NuGet.config can be found in %APPDATA%\Roaming\NuGet\NuGet.config
    NuGet.Settings.LoadDefaultSettings(
        new PhysicalFileSystem(Directory.GetCurrentDirectory()),
        configFileName=null,
        machineWideSettings=machineWideSettings)

/// Container for the various NuGet API keys.
type ApiKeysContainer(settings:ISettings) =
    let myGetApiKey = lazy( readApiKey settings Constants.MyGetConfigKey )
    let nuGetApiKey = lazy( readApiKey settings Constants.NuGetConfigKey )

    /// Return the API key for the MyGet server.
    member this.MyGetApiKey with get() = myGetApiKey.Value

    /// Return the API key for the NuGet server.
    member this.NuGetApiKey with get() = nuGetApiKey.Value