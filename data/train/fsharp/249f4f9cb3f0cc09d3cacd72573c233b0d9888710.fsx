#r "System.Xml"
#r "System.Xml.Linq"

open System.IO
open System.Text.RegularExpressions
open System.Xml.Linq

let tokenRegex = Regex("^\$.*\$$", RegexOptions.Compiled)

let transform (doc : XDocument) =
    let meta = doc.Root.Descendants(XName.Get "metadata") |> Seq.head
    meta.Descendants()
    |> Seq.map (fun e -> e.Name.LocalName, e.Value)
    |> Seq.filter (fun (_, value) -> not <| tokenRegex.IsMatch value)
    |> Seq.map (fun (name, value) -> sprintf "%s\n    %s\n" name value)
    |> String.concat ""

let processNuspec path =
    let projPaths =
        ["csproj";"vbproj";"fsproj"]
        |> List.map (fun ext -> Path.ChangeExtension(path, ext))
    if projPaths |> List.exists File.Exists then
        let original = File.ReadAllText path
        let template = "type project\n" + transform (XDocument.Parse original)
        let templatePath = Path.Combine(Path.GetDirectoryName path, "paket.template")
        File.WriteAllText(templatePath, template)
        File.Delete path

let processAll root =
    Directory.EnumerateFiles(root, "*.nuspec", SearchOption.AllDirectories)
    |> Seq.iter processNuspec
