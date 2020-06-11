// Copyright 2015 Mårten Rånge
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

namespace FsInclude

module internal Processor =

    open System
    open System.Collections.Generic
    open System.IO
    open System.Net
    open System.Text
    open System.Text.RegularExpressions

    type Lines          = ResizeArray<string>
    type Blacklister    = string -> bool
    type Appender       = int -> string -> unit
    type Resolver       = ProcessContext -> string -> unit
    and ProcessContext  =
        {
            RelativePath    : string
            ParentNamespaces: string []
            Appender        : Appender
            Resolver        : Resolver
            Blacklister     : Blacklister
            Prelude         : Lines
            Content         : Lines
            Includes        : ResizeArray<string>
            SeenIncludes    : HashSet<string>
            SeenNamespaces  : Dictionary<string, string>
        }

        member x.ParentNamespace = String.Join (".", x.ParentNamespaces)

        static member New rp pn a r b p c =
                        {
                            RelativePath    = rp
                            ParentNamespaces= pn
                            Appender        = a
                            Resolver        = r
                            Blacklister     = b
                            Prelude         = p
                            Content         = c
                            Includes        = ResizeArray<_> ()
                            SeenIncludes    = HashSet<_> (StringComparer.OrdinalIgnoreCase)
                            SeenNamespaces  = Dictionary<_, _> (StringComparer.OrdinalIgnoreCase)
                        }

        member x.MoveLocation (path : string) = { x with RelativePath = Path.Combine (x.RelativePath, path) }

    type LineAction = ProcessContext -> string -> Match -> unit

    let rec LineActions : (Regex*LineAction) [] =
        let makeRegex s = Regex (s, RegexOptions.Compiled ||| RegexOptions.ExplicitCapture ||| RegexOptions.Singleline)

        let includeAction (context : ProcessContext) (l : string) (m : Match) : unit =
            let ref         = m.Groups.["ref"].Value
            context.Resolver context ref

        let namespaceAction (context : ProcessContext) (l : string) (m : Match) : unit =
            if context.ParentNamespaces.Length = 0 then
                context.Content.Add l
            else
                let ws  = m.Groups.["ws"].Value
                let ns  = m.Groups.["ns"].Value

                let success, seen = context.SeenNamespaces.TryGetValue ns
                let result =
                    if success then
                        seen
                    else
                        let parent  = context.ParentNamespace

                        let result =
                            if ns.StartsWith ("global", StringComparison.Ordinal) then
                                parent
                            else
                                sprintf "%s.%s" parent ns

                        context.SeenNamespaces.Add (ns, result)

                        result

                context.Content.Add <| sprintf "%snamespace %s" ws result

        let openAction (context : ProcessContext) (l : string) (m : Match) : unit =
            let ws  = m.Groups.["ws"].Value
            let ns  = m.Groups.["ns"].Value

            let success, seen = context.SeenNamespaces.TryGetValue ns
            let result =
                if success then
                    seen
                else
                    ns

            context.Content.Add <| sprintf "%sopen %s" ws result

        let defaultAction (context : ProcessContext) (l : string) (m : Match) : unit =
            context.Content.Add l

        [|
            """^.*$"""                                          , defaultAction
            """^\s*//\s+###\s*INCLUDE:\s*(?<ref>\S+)\s*.*$"""   , includeAction
            """^(?<ws>\s*)namespace\s+(?<ns>\S+)\s*.*$"""       , namespaceAction
            """^(?<ws>\s*)open\s+(?<ns>\S+)\s*.*$"""            , openAction
        |] |> Array.map (fun (r,a) -> makeRegex r, a)

    and MatchLineActions (context : ProcessContext) (line : string) : int -> unit = function
        | 0 -> ()
        | i ->
            let r,la = LineActions.[i - 1]
            let m = r.Match line
            if m.Success then
                la context line m
            else
                MatchLineActions context line (i-1)

    and AppendLines (context : ProcessContext) (lines : seq<string>) : unit =
        for line in lines do
            MatchLineActions context line LineActions.Length

    let CreateProcessContext    (relativePath       : string        )
                                (parentNamespaces   : string []     )
                                (appender           : Appender      )
                                (resolver           : Resolver      )
                                (blacklister        : Blacklister   ) : ProcessContext =
        let prelude     = Lines()
        let content     = Lines()
        ProcessContext.New relativePath parentNamespaces appender resolver blacklister prelude content

    let ProcessDocument (context : ProcessContext) : unit =
        let indent = 4

        let appender = context.Appender

        for line in context.Prelude do
            appender (0*indent) line

        for line in context.Content do
            appender (0*indent) line

        if context.ParentNamespaces.Length > 0 then
            appender (0*indent) <| sprintf "namespace %s" context.ParentNamespace

        appender (0*indent) "module IncludeMetaData ="

        appender (1*indent) <| "[<Literal>]"
        appender (1*indent) <| sprintf "let IncludeDate = \"%s\"" (DateTime.Now.ToString "yyyy-MM-ddTHH:mm:ss")

        context.Includes
            |> Seq.iteri
                (fun i fp ->
                    appender (1*indent) <| "[<Literal>]"
                    appender (1*indent) <| sprintf "let Include_%d = @\"%s\"" i fp
                )

    let CreateResolver  (pathAppender   : string -> string -> string)
                        (downloader     : string -> seq<string>     ) : Resolver =
        fun context path ->
            let fullPath = pathAppender context.RelativePath path

            let lines =
                if context.SeenIncludes.Add fullPath then
                    context.Includes.Add fullPath
                    seq {
                        yield sprintf "// @@@ INCLUDE: %s" fullPath

                        yield sprintf "// @@@ BEGIN_DOCUMENT: %s" fullPath

                        for line in (downloader fullPath) do
                            yield line

                        yield sprintf "// @@@ END_DOCUMENT: %s" fullPath
                    }
                else
                    seq {
                        yield sprintf "// @@@ SKIPPED_INCLUDE (Already seen): %s" fullPath
                    }
            AppendLines context lines


    let ProcessWebFiles (parentNamespaces : string []) (baseUri : Uri) (paths : string []) (appender : Appender) (blacklister : Blacklister) : unit =

        let pathAppender relativePath path =
            let ub      = UriBuilder baseUri
            ub.Path     <- Path.Combine (relativePath, path)
            let uri     = ub.Uri
            uri.ToString ()

        let downloader (fullPath : string) =
            use wc      = new WebClient ()
            try
                let input   = wc.DownloadString (fullPath)
                seq {
                    use stringReader    = new StringReader (input)
                    let line            = ref ""
                    while (line := stringReader.ReadLine(); !line <> null) do
                        yield !line
                }
            with
            | e ->
                seq {
                    yield sprintf "// @@@ SKIPPED_INCLUDE (Exception %A): %s" e.Message fullPath
                }


        let resolver        = CreateResolver pathAppender downloader
        let context         = CreateProcessContext "" parentNamespaces appender resolver blacklister

        let downloadLines (path : string) =
            let full            = Uri (baseUri, path)
            let relativePath    = Path.GetDirectoryName full.LocalPath
            let name            = Path.GetFileName full.LocalPath
            let movedContext    = context.MoveLocation relativePath
            resolver movedContext name


        for path in paths do
            downloadLines path

        ProcessDocument context

    let DownloadWebFilesAsString (enclosingNamespace : string option) (baseUri : Uri) (paths : string []) : string =
        let sb = StringBuilder ()

        let appender n s =
            ignore <| sb.Append (' ', n)
            ignore <| sb.AppendLine s

        ProcessWebFiles (enclosingNamespace |> Option.toArray) baseUri paths appender (fun p -> true)

        sb.ToString ()

    let DownloadWebFilesToStream (sw : StreamWriter) (enclosingNamespace : string option) (baseUri : Uri) (paths : string []) : unit =
        let appender n (s : string) =
            for n in 1..n do
                sw.Write ' '

            sw.WriteLine s

        ProcessWebFiles (enclosingNamespace |> Option.toArray) baseUri paths appender (fun p -> true)


