(*
 * Lw
 * console.fs: interactive console
 * (C) Alvise Spano' @ Universita' Ca' Foscari di Venezia
 *)
 
module Lw.Interpreter.Console

open System
open System.Threading
open System.Diagnostics
open Lw.Core
open Lw.Core.Globals
open Lw.Interpreter.Globals
open Lw.Core.Typing.Report
open Lw.Interpreter.Intrinsic
open Lw.Core.Typing.Defs
open FSharp.Common.Log
open FSharp.Common

module A = Lw.Core.Absyn.Ast

let print_env_diffs (Γ1 : jenv) Γ2 (Δ1 : Eval.venv) Δ2 =
    for (_, { jenv_value.scheme = σ }), (x, v) in Seq.zip (Γ2 - Γ1) (Δ2 - Δ1) do
        L.norm L.log_line (Config.Console.pretty_prompt_decl x σ v)

let print_decl_bindings (Γ : jenv) (Δ : Eval.venv) d =
    for x in Typing.Ops.vars_in_decl d do
        let σ = Γ.lookup (jenv_key.Var x)
        let v = Δ.lookup x
        L.norm L.log_line (Config.Console.pretty_prompt_decl x σ v)

let read_and_eval_loop (envs : Intrinsic.envs) =
    print_env_diffs Intrinsic.envs.envs0.Γ envs.Γ Intrinsic.envs.envs0.Δ envs.Δ
    L.msg Low "entering console mode"

    let default_ctrl_c_handler = new ConsoleCancelEventHandler (fun _ _ ->
        L.msg Unmaskerable "CTRL-C signal intercepted: forcing console exit"
        exit Config.Exit.ctrl_c)
    Console.CancelKeyPress.AddHandler default_ctrl_c_handler

    let rΔ = ref envs.Δ
    let st = ref { Typing.StateMonad.state.empty with Γ = envs.Γ; γ = envs.γ; δ = envs.δ }
    let unM f x =
        let ctx = Typing.Defs.context.as_top_level_decl
        let r, st' = f ctx x !st
        st := st'
        r

    let watchdog f =
        use cancellation_source = new CancellationTokenSource ()
        let eval_ctrl_c_handler =  new ConsoleCancelEventHandler (fun _ args ->
                L.msg Normal "CTRL-C signal intercepted: interrupting current evaluation"
                args.Cancel <- true
                cancellation_source.Cancel ())
        Console.CancelKeyPress.RemoveHandler default_ctrl_c_handler
        Console.CancelKeyPress.AddHandler eval_ctrl_c_handler
        let watcher =
            async {
                let p = Process.GetCurrentProcess ()
                while true do
                    do! Async.Sleep (int <| Config.Console.watchdog_interval * 1000.0)
                    L.hint High "evaluation is in progress (cpu time: %s)..." p.UserProcessorTime.pretty
            }
        async {
            try
                Async.Start (watcher, cancellation_source.Token)
                return f cancellation_source.Token
            finally
                cancellation_source.Cancel ()
                Console.CancelKeyPress.RemoveHandler eval_ctrl_c_handler
                Console.CancelKeyPress.AddHandler default_ctrl_c_handler
        } |> Async.RunSynchronously


    while true do
        try
            lock L <| fun () ->
                printf "\n%s " Config.Console.prompt
                stdout.Flush ()
            let W f e = watchdog (fun c -> cputime (f { Eval.context.cancellation_token = c } !rΔ) e)
            let tspan, vspan =
                match Parsing.parse_line stdin "STDIN" with
                | A.Line_Expr e ->
                    let t, tspan = cputime (unM Typing.Inference.W_expr) e
                    let v, vspan = W Eval.eval_expr e
                    L.log_line (Config.Console.pretty_prompt_expr t v)
                    tspan, vspan

                | A.Line_Decl d ->
                    let (), tspan = cputime (unM Typing.Inference.W_decl) d
                    let Δ', vspan = W Eval.eval_decl d
                    let Γ' = (!st).Γ
                    rΔ := Δ'
                    print_decl_bindings Γ' Δ' d
                    tspan, vspan
            let s = sprintf "-- typing %s / eval %s" tspan.pretty vspan.pretty
            L.log_line (sprintf "%s%s" (spaces (Console.BufferWidth - s.Length)) s)

        with :? OperationCanceledException -> ()
           | e                             -> ignore <| handle_exn_and_return e


