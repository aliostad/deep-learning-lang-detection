namespace SvgConvert

open System
open System.Xml.Linq;

module SvgConverter =

    type private ElementMap = seq<(string * XElement)>

    let private nsId = "svgNs"

    let private buildElementMap (doc: XDocument) =
        doc.Root.DescendantsAndSelf()
        |> Seq.mapi(fun i el -> (sprintf "element%i" (i + 1), el))
        |> Seq.toArray

    let private processAttribute (rootEl: string, attr: XAttribute) =
        let localName = attr.Name.LocalName
        let attrName = attr.Name.LocalName
        sprintf "%s.setAttribute('%s', '%s');" rootEl attrName attr.Value

    let rec private processElements (root: XElement, map: ElementMap, parent: Option<string>) =
        let elementId = 
            map 
            |> Seq.filter (fun (_, el) -> el = root) 
            |> Seq.map (fun (n, _) -> n) 
            |> Seq.head

        let elementName = root.Name.LocalName
        let elString = sprintf "var %s = document.createElementNS(%s, '%s');" elementId nsId elementName
        let attributes = root.Attributes()
        let doc = 
            attributes 
            |> Seq.filter (fun x-> not x.IsNamespaceDeclaration)
            |> Seq.map (fun x -> processAttribute(elementId, x)) 
            |> String.concat "\n"
        
        let elements = 
            root.Elements() 
            |> Seq.map (fun x-> processElements(x, map, Some(elementId)))
            |> String.concat "\n"

        let elementResult = sprintf "%s\n%s\n%s" elString doc elements
        match parent with
            | Some p -> sprintf "%s\n%s.appendChild(%s);" elementResult p elementId
            | None -> elementResult

    let convertSvg svg =
        let ns = sprintf "var %s = 'http://www.w3.org/2000/svg';" nsId
        let xdoc = XDocument.Parse(svg)
        let map = buildElementMap xdoc
        sprintf "%s\n%s" ns (processElements(xdoc.Root, map, None))