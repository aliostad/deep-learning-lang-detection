namespace DependencyGraph
module DotLang=
    let nameForVertext (a:string)= a.Replace(".","_").Replace(" ","_")
    let beginGraph = "digraph G{"
    let endGraph = "}"
    let relation v1 v2 = sprintf "\t%s -> %s;" (nameForVertext v1) (nameForVertext v2)
    let labelForVertex v= sprintf "%s[label=\"%s\"];" (nameForVertext v) v

module GraphVizUtil=
    open System.Collections.Generic
    open GraphVizWrapper.Commands
    open GraphVizWrapper.Queries
    open GraphVizWrapper

    let translateGraptToDotLanguage graph= 
        seq {
            let vertices = new HashSet<string>()
            yield DotLang.beginGraph
            for (v1,v2) in graph do
                vertices.Add(v1) |> ignore
                vertices.Add(v2) |> ignore
                yield DotLang.relation v1 v2        
            for v in vertices do
                yield  DotLang.labelForVertex v        
            yield DotLang.endGraph
        } |> (fun x -> System.String.Join("\n",x))

    let generateGraphImage str= async{        
        let getStartProcessQuery = new GetStartProcessQuery()
        let getProcessStartInfoQuery = new GetProcessStartInfoQuery()
        let registerLayoutPluginCommand = new RegisterLayoutPluginCommand(getProcessStartInfoQuery, getStartProcessQuery)
        let wrapper = new GraphGeneration(getStartProcessQuery, getProcessStartInfoQuery, registerLayoutPluginCommand)
        return wrapper.GenerateGraph(str, Enums.GraphReturnType.Svg)
        }
    
    let generateGraphSvg relationsList= async{
        return! relationsList |> translateGraptToDotLanguage |> generateGraphImage
    }
        

            
