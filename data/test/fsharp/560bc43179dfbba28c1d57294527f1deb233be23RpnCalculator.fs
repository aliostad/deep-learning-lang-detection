open System

let calculateRpn rpnExpr =
    let tokenize (expr:string) = expr.Split(' ') |> List.ofArray

    let (|Operand|_|) token =
        let isOperand, operand = Double.TryParse(token)
        if isOperand then Some(operand) else None

    let (|Operator|_|) token =
        let isOperator, operator = Char.TryParse(token)
        if isOperator then Some(operator) else None

    let apply operator stack =
        match operator, stack with
        | '+', op1::op2::rest -> op2 + op1 :: rest
        | '-', op1::op2::rest -> op2 - op1 :: rest
        | '*', op1::op2::rest -> op2 * op1 :: rest
        | '/', op1::op2::rest -> op2 / op1 :: rest
        | _ -> failwith "unknown operator or missing operands"

    let processToken token stack =
        match token with
        | Operand operand -> operand :: stack
        | Operator operator -> apply operator stack
        | _ -> failwith "unrecognized token"

    let rec processTokens tokens acc =
        match tokens with
        | head::tail -> processTokens tail (processToken head acc)
        | [] -> acc

    let tokens = tokenize rpnExpr
    let result = processTokens tokens []
    result.[0]

calculateRpn "1 2 + 4 * 5 + 3 - 2 /" |> printf "%f"

Console.ReadLine() |> ignore