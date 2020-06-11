namespace HighlighterLib

module SolutionProcessing =

    open System
    open System.Collections.Generic
    open System.IO
    open Microsoft.CodeAnalysis
    open Microsoft.CodeAnalysis.CSharp
    open Microsoft.CodeAnalysis.CSharp.Syntax
    open Microsoft.CodeAnalysis.Text
    open Types
    open Analysis
    

    type ProcessedProject = {
        Path: string;
        Files: FileAnalysisResult array
    }

    type ProcessedSolution = {
        Path: string;
        Projects: ProcessedProject array
    }

    let openSolution solutionPath = 
        async {
            let workspace = MSBuild.MSBuildWorkspace.Create()
            let! solution = workspace.OpenSolutionAsync(solutionPath) |> Async.AwaitTask
            return workspace
        }



    let processSolution (sol: Solution) =
        let solutionDir = Path.GetDirectoryName sol.FilePath
        let processDocument (doc: Document) : Async<FileAnalysisResult> option =
            // Dont process files that arent under the solution directory.
            // This simplifies things when doing a tree structure
            
            if doc.FilePath.StartsWith solutionDir then
                let asd = 
                    async {
                        let! model = doc.GetSemanticModelAsync() |> Async.AwaitTask
                        let! root = doc.GetSyntaxRootAsync() |> Async.AwaitTask
                        let highlightingModel = Analysis.createHighlightingModel root model
                        let declaredTypes = Analysis.getDeclaredTypes root model
                        return {
                            FilePath = doc.FilePath
                            ClassifiedTokens = highlightingModel
                            DeclaredTypes = declaredTypes
                        }
                    }
                Some asd
            else
                None

        let processProject (proj: Project) =
            if proj.FilePath.StartsWith solutionDir then
                let asd = 
                    async {
                        let! formattedFiles = 
                            proj.Documents
                            |> Seq.choose processDocument
                            |> Async.Parallel
                        return {
                            Path = proj.FilePath.Substring(solutionDir.Length)
                            Files = formattedFiles
                        }
                    }
                Some asd
            else
                None

        async {
            let dependencyGraph = sol.GetProjectDependencyGraph()
            let! projects = 
                dependencyGraph.GetTopologicallySortedProjects() 
                |> Seq.map (fun projId -> sol.GetProject projId)
                |> Seq.choose processProject
                |> Async.Parallel
            return {
                Path = Path.GetFileName sol.FilePath;
                Projects = projects
            }
        }
    
    let processSolutionAtPath (solutionPath: string) =
        async {
            use! workspace = openSolution solutionPath
            let! processed = processSolution workspace.CurrentSolution
            return processed
        } |> Async.RunSynchronously