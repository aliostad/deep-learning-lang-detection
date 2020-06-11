module Chimayo.Ssis.CodeGen.CodeGenerator

open Chimayo.Ssis.CodeGen
open Chimayo.Ssis.CodeGen.CodeDsl
open Chimayo.Ssis.CodeGen.CodeDsl.Builder
open Chimayo.Ssis.CodeGen.Internals

open Chimayo.Ssis.Ast.ControlFlow
open Chimayo.Ssis.Ast.ControlFlowApi
  

let buildPkgContent ``namespace`` (pkg : CftPackage) =
    
    let cmListName, cmListDeclaration = ConnectionManagers.build pkg.connectionManagers
    let varListName, varListDeclaration = Variables.build pkg.variables
    let configListName, configListDeclaration = PackageConfigurations.build pkg.configurations
    let execListName, execDeclarations = Executables.build pkg.executables

    let content = 
        Pipeline ("|>",
            [
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.create @> [ constant pkg.name ]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.setCreationDate @> [ constantOption true (pkg.creationDate |> Option.map (fun o -> upcast o)) ]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.delayValidation @> [ constant pkg.delayValidation ]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.failParentOnFailure @> [ constant pkg.failParentOnFailure ]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.failOnErrorCountReaching @> [ constant pkg.failOnErrorCountReaching ]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.maxConcurrentExecutables @> [ constant pkg.maxConcurrentExecutables ]
                yield! toConditionalListElement pkg.enableConfigurations <| functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.enableConfigurations @> [ ]
                yield! toConditionalListElement (not pkg.enableConfigurations) <| functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.disableConfigurations @> [ ]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.isolationLevel @> [ fullyQualifiedEnum<CfIsolationLevel> pkg.isolationLevel ]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.localeId @> [ constant pkg.localeId ]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.transactionOption @> [ fullyQualifiedEnum<CfTransactionOption> pkg.transactionOption ]

                yield! toConditionalListElement pkg.disabled <| functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.setDisabled @> [ constant pkg.disabled ]
                yield! toConditionalListElement pkg.disableEventHandlers <| functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.setDisableEventHandlers @> [ constant pkg.disableEventHandlers ]
                yield! pkg.forcedExecutionResult 
                       |> optionToListMap (fun v -> functionApplicationQ 
                                                        <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.forceExecutionResult @>
                                                        [ fullyQualifiedEnum<CfExecutableResult> v ])
                yield! pkg.forcedExecutionValue 
                       |> optionToListMap (functionApplicationWithDataValueSimpleQ 
                                                false 
                                                <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.forceResultValueDirect @>
                                                <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.forceResultValue @>)

                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.addConnectionManagers @> [cmListName]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.addVariables @> [varListName]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.addConfigurations @> [configListName]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.addExpressions @> [ Core.buildPropertyExpressions pkg.propertyExpressions ]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.addLogProviders @> [LogProviders.build pkg.logProviders]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.setLogging @> [LoggingOptions.build pkg.loggingOptions |> parentheses true]
                yield functionApplicationQ <@ Chimayo.Ssis.Ast.ControlFlowApi.Package.addExecutables @> [execListName]
            ])
    
    Namespace
        (``namespace``
        ,[
            Module 
                (pkg.name |> toCodeName
                ,[
                    yield! TypeNameRegistry.imports |> List.map Open
                    yield BlankLine
                    yield! TypeNameRegistry.aliases |> List.filter (fun (_,x,_) -> x) |> List.map (fun (a,_,b) -> a,b) |> List.map ModuleAlias
                    yield! [BlankLine ; cmListDeclaration]
                    yield! [BlankLine ; varListDeclaration]
                    yield! [BlankLine ; configListDeclaration]
                    yield BlankLine
                    yield execDeclarations
                    yield BlankLine
                    yield LetBinding (false, "package", Some "Chimayo.Ssis.Ast.ControlFlow.CftPackage", [], content, None)
                 ])
            ])

let build ``namespace`` (pkg : CftPackage) =
    pkg |> PackageNormaliser.normalise |> buildPkgContent ``namespace`` |> CodeDsl.Printer.toString

    



