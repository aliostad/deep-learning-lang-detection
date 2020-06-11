namespace ChromeFSharp

open System
open System.IO
open System.Text
open CefSharp
open System.Reflection
open System.Resources

module AppScheme =

    type AppSource =
        | FileSystem of rootDir: string
        | Resource of resourcePrefix: string * assembly: Assembly

    let private errorResource code message : IResourceHandler =
        let stream = ResourceHandler.GetMemoryStream(message, Encoding.UTF8)
        let resourceHandler = ResourceHandler.FromStream stream
        resourceHandler.StatusText <- message
        resourceHandler.StatusCode <- code
        upcast resourceHandler

    let private fileSystemHandler rootDir =
        let rootDir = Path.GetFullPath rootDir

        fun (uri: Uri) ->
            let path = uri.AbsolutePath.TrimStart '/'
            let ext = uri.AbsolutePath |> Path.GetExtension

            let fullPath = Path.Combine(rootDir, path) |> Path.GetFullPath
            if not <| fullPath.StartsWith rootDir then
                errorResource 404 "Invalid path"
            else
                // Read from string instead of a stream so that we don't keep
                // a lock on the file.
                ResourceHandler.FromString(File.ReadAllText fullPath, ext)
                :> _

    let private makeResourceHandler (resourcePrefix: string) (assembly: Assembly) =

        let globalResource =
            assembly.GetManifestResourceNames()
            |> Array.find (fun name -> name.EndsWith(".g.resources"))
            |> assembly.GetManifestResourceStream

        let resourceSet = new ResourceSet(globalResource)
            
        fun (uri: Uri) ->
            let path = uri.AbsolutePath.TrimStart '/'
            let mime = path |> Path.GetExtension |> ResourceHandler.GetMimeType

            match resourceSet.GetObject(resourcePrefix + path, true) with
            | :? UnmanagedMemoryStream as stream ->
                ResourceHandler.FromStream(stream, mime) :> IResourceHandler
            | _ ->
                errorResource 404 "File does not exist in global resource"

    let make source =

        let resourceHandler =
            match source with
            | FileSystem rootDir -> fileSystemHandler rootDir
            | Resource (resourcePrefix, assembly) -> makeResourceHandler resourcePrefix assembly

        let scheme = new CefCustomScheme()
        scheme.SchemeName <- "app"

        scheme.SchemeHandlerFactory <-
            { new ISchemeHandlerFactory with
                member __.Create (browser, frame, schemeName, request) =
                    let uri = Uri(request.Url)

                    if uri.Host <> "local" then
                        errorResource 404 "URI host must be 'local'"
                    else
                        resourceHandler uri
            }

        // Don't allow other schemes to display (or link to) this scheme
        scheme.IsDisplayIsolated <- true

        scheme
