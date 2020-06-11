module Types

open System
open System.Collections.Generic

type keyword =
    | If
    | Cond
    | Add
    | Subtract
    | Divide
    | Multiply
    | And
    | Or
    | Equal
    | GreaterThan
    | LessThan
    | GreaterThanOrEqual
    | LessThanOrEqual
    | Define
    | Else
    | Exit
    | Lambda
    | Let
    | Display
    | Newline
    override this.ToString() =
        match this with
        | If -> "if"
        | Cond -> "cond"
        | Add -> "+"
        | Subtract -> "-"
        | Divide -> "/"
        | Multiply -> "*"
        | And -> "and"
        | Or -> "or"
        | Equal -> "="
        | GreaterThan -> ">"
        | LessThan -> "<"
        | GreaterThanOrEqual -> ">="
        | LessThanOrEqual -> "<="
        | Define -> "define"
        | Else -> "else"
        | Exit -> "exit"
        | Lambda -> "lambda"
        | Let -> "let"
        | Display -> "display"
        | Newline -> "newline"
    static member FromString = function
        | "if" -> If |> Some
        | "cond" -> Cond |> Some
        | "and" -> And |> Some
        | "or" -> Or |> Some
        | "define" -> Define |> Some
        | "else" -> Else |> Some
        | "exit" -> Exit |> Some
        | "lambda" -> Lambda |> Some
        | "let" -> Let |> Some
        | _ -> None

and literal =
    | Nil
    | Number of float
    | Boolean of bool
    | Chr of char
    | Str of string
    override this.ToString() =
        match this with
        | Nil -> "#nil"
        | Number(n) -> n.ToString()
        | Boolean(b) -> if b then "#t" else "#f"
        | Chr(c) -> sprintf @"\#%O" c
        | Str(s) -> s.Replace("\r", @"\r").Replace("\n", @"\n")
    static member FromString = function
        | "#t" -> Boolean(true) |> Some
        | "#f" -> Boolean(false) |> Some
        | s -> let d = ref 0.0
               match Double.TryParse(s, d) with
               | true -> Some(Number(!d))
               | false -> match s.StartsWith(@"\#") && s.Length > 2 with
                          | true -> Some(Chr(s.[2]))
                          | false -> match s.StartsWith("\"") && s.EndsWith("\"") with
                                     | true -> Some(Str(s))
                                     | false -> None

and expression =
    | Scope of env * expression
    | Literal of literal
    | Variable of string
    | Keyword of keyword
    | Expression of expression list
    | Error of string
    override this.ToString() =
        match this with
        | Scope(_, e) -> e.ToString()
        | Literal(l) -> l.ToString()
        | Variable(s) -> s
        | Keyword(kw) -> kw.ToString()
        | Expression(exprs) -> "(" + (exprs |> List.map (sprintf "%O") |> List.fold (fun s e -> s + " " + e) "") + " )"
        | Error(e) -> e

and env() =
    let exprs = Dictionary<string, expression list * expression list>()
    member private this.Exprs = exprs
    member this.GetVar name = 
        let func = ref ([], [])
        match exprs.TryGetValue(name, func) with
        | true -> Some(!func)
        | false -> None
    member this.Copy() =
        let copy = env()
        for kvp in exprs do copy.Exprs.[kvp.Key] <- kvp.Value
        copy
    member this.SetVar name func = 
        let copy = this.Copy()
        copy.Exprs.[name] <- func
        copy
    member this.Combine (other:env) =
        let newEnv = this.Copy()
        for kvp in other.Exprs do newEnv.Exprs.[kvp.Key] <- kvp.Value
        newEnv
    member this.VarNames = exprs.Keys |> Seq.toList
    override this.ToString() =
        if exprs.Count < 1 then "[empty environment]\r\n" else
        exprs |> Seq.fold (fun s kvp -> s + (sprintf "%O | %O\r\n" kvp.Key kvp.Value)) ""