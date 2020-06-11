module SolutionCrawler

open System.IO
open System.Linq
open Roslyn.Compilers
open Roslyn.Compilers.CSharp
open Roslyn.Compilers.Common
open Roslyn.Services
open Roslyn.Services.CSharp

/// ----------------------------------------------------------
/// Project can be represented by a full file path or IProject instance
/// ----------------------------------------------------------
type Project =
    | Name of string
    | Ref of IProject

let updateSolution (workspace: IWorkspace) (oldSolution: ISolution) (newSolution: ISolution) = 
    if oldSolution = newSolution then oldSolution
    else if workspace.ApplyChanges(oldSolution, newSolution) then newSolution else oldSolution

let forEachFileInProject (project: Project) (handler: CompilationUnitSyntax -> CompilationUnitSyntax option) =
    let processDocument (document: IDocument) (solution: ISolution) =
        let updatedTree = document.GetSyntaxTree().GetRoot() :?> CompilationUnitSyntax |> handler
        match updatedTree with
        | Some(t) -> solution.UpdateDocument(document.Id, t)
        | None -> solution
    let rec processDocuments (documents: IDocument list) (solution: ISolution) =
        match documents with
        | hd :: tl -> processDocuments tl (processDocument hd solution)
        | []       -> solution
    let processProject (project: IProject) = processDocuments (project.Documents |> Seq.filter (fun d -> d.LanguageServices.Language = LanguageNames.CSharp) |> Seq.toList) (project.Solution)
    match project with
    | Name n ->
        let workspace = Workspace.LoadStandAloneProject n
        let project = workspace.CurrentSolution.Projects.First()
        updateSolution workspace (workspace.CurrentSolution) (processProject project)
    | Ref  p -> processProject p

let forEachFileInSolution (solutionName: string) (handler: CompilationUnitSyntax -> CompilationUnitSyntax option) =
    let workspace = Workspace.LoadSolution solutionName
    let solution = workspace.CurrentSolution
    let rec processProjects (projects: IProject list) (solution: ISolution) = 
        match projects with
        | hd :: tl -> processProjects tl (forEachFileInProject (Ref(hd)) handler)
        | []       -> solution
    solution.Projects |> Seq.iter (fun p -> forEachFileInProject (Ref(p)) handler |> ignore)