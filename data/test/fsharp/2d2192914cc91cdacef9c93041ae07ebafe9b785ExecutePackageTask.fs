module Chimayo.Ssis.CodeGen.ExecutePackageTask

open Chimayo.Ssis.CodeGen.Internals
open Chimayo.Ssis.CodeGen.CodeDsl
open Chimayo.Ssis.CodeGen.CodeDsl.Builder
open Chimayo.Ssis.CodeGen.Core

open Chimayo.Ssis.Ast.ControlFlow
open Chimayo.Ssis.Ast.ControlFlowApi

let build (t : CftExecutePackageFromFile) =
    
    let tbdecls, tb = ExecutableTaskCommon.buildTaskBase t.executableTaskBase

    let ct =
        RecordExpression
            [
                "executableTaskBase", tb
                "executeOutOfProcess", t.executeOutOfProcess |> constant
                "connection", t.connection |> makeNamedReference false 
            ]
    [ tbdecls ], ct
