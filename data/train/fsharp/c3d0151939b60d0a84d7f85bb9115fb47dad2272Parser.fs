module Parser
open FParsec
open FParsec.CharParsers
open System

type PExpression =
 | StringLit of string
 | IntLit of int
 | Variable of string
 | Func of string * (PExpression list)

type PStatement = 
 | ReturnStat of PExpression
 | IfStat of PExpression * PStatement list
 | Execution of PExpression
 | Declaration of string * string
 | Assignment of string * PExpression
 | While of PExpression * PStatement list
 | DeclAndAssign of string * string * PExpression

 
type FuncSignature = {
  access : string
  returnTy : string
  name : string
  args : (string * string) list
}

type ParserFunction = {
  signature : FuncSignature
  body : PStatement list
}
 
type ParserData = unit


let allowabeNameChar = letter
let parseName = many1Chars letter .>> spaces
let tok s = pstring s >>. spaces >>. preturn ()
let tok2 s = spaces >>. tok s
let betweenParens a = between (tok "(") (tok ")") a
let betweenCurlys a = between (tok "{") (tok "}") a
let parsePairAndLift l p1 p2 = parse {
  let! p1' = p1
  let! p2' = p2
  return l (p1',p2')
}

///fparsec uses an OperatorPrecedenceParser to manage 
///multiple operators with different precedense at once. 
///The operator has an ExpressionParser member (parseExpression), which 
///references the TermParser member, which also refernces parseExpression. 
///That's how we get recursion here.
let opp = OperatorPrecedenceParser<_,_,ParserData>()
let parseExpression = opp.ExpressionParser;

///Here we add the supported operators, where precedence increases with p
let arithHelper s p = InfixOperator(s, spaces, p, Associativity.Left, fun x y -> Func ("_" + s,[x;y]))
opp.AddOperator(arithHelper "-" 1)
opp.AddOperator(arithHelper "+" 1)
opp.AddOperator(arithHelper "*" 2)
opp.AddOperator(arithHelper "==" 3)

let expr = 
   let parseInt = pint32 .>> spaces |>> IntLit
   let parseVariable = parseName |>> Variable
   ///we parse escape characteres so the string "foo\n" ends in a newline in F#, not a '\' and an 'n'.
   let parseString =
     let normal = satisfy (fun c -> c <>'\\' && c <> '"')
     let unescapeChar = function
        | 'n' -> '\n' 
        | 'r' -> '\r'
        | 't' -> '\t'
        |  c  ->  c
     let escaped = pstring "\\" >>. (anyOf "\\nrt\"" |>> unescapeChar)
     let strChar = (manyChars (normal <|> escaped))
     between (pstring "\"") (tok "\"") strChar |>> StringLit
   let parseFunc = parse { 
     let! name = parseName
     let! args = betweenParens <| sepBy parseExpression (tok ",") 
     return Func (name,args)}
   let parsensExpr = betweenParens parseExpression
              
   attempt parsensExpr   
   <|>  attempt parseInt      
   <|>  attempt parseFunc     
   <|>  attempt parseString   
   <|>  attempt parseVariable 
   <?>  "Failed to parse expression"
opp.TermParser <- expr

//Outside of the expression parser, fparsec can create a pair of reference cell
//and parser to manage recursive parsing. parseStatement is just a redirection to the cell.
let parseStatement, parseStatementRef = createParserForwardedToRef()

do parseStatementRef :=
   let parseReturn = tok "return " >>. parseExpression |>> ReturnStat 
   let parseBody =  betweenCurlys <| many parseStatement
   let parseExecution = parseExpression |>> Execution
   let parseIfStat = 
     parsePairAndLift IfStat 
       (tok "if" >>. (betweenParens <| parseExpression))
       parseBody
   let parseDeclaration = 
     parsePairAndLift Declaration 
       parseName 
       parseName 
   let parseAssignment =
     parsePairAndLift Assignment
       (parseName .>> tok "=")
       parseExpression
   let parseWhile = 
     parsePairAndLift While
       (tok "while" >>. (parseExpression |> betweenParens))
       parseBody
   let parseDeclAndAssign = parse {
       let! ty = parseName
       let! var = parseName
       do! tok "="
       let! expr = parseExpression
       return DeclAndAssign (ty, var ,expr)}
   
   (attempt parseReturn .>> tok ";")
   <|> (attempt parseIfStat)
   <|> (attempt parseAssignment .>> tok ";")
   <|> (attempt parseDeclAndAssign .>> tok ";")
   <|> (attempt parseDeclaration .>> tok ";")
   <|> (attempt parseWhile)
   <|> (attempt parseExecution .>> tok ";")
   <?> "Failed to parse statement"

let parseSignature = parse {
    let! access = parseName
    let! returnTy = parseName 
    let! name = parseName
    let! args = sepBy (parseName .>>. parseName) (tok ",") 
             |> betweenParens
    return {
      access = access
      returnTy = returnTy
      args = args
      name = name
    } }
  
let parseFunction = parse {
  let! signature = parseSignature
  let! body = many parseStatement |> betweenCurlys
  return {signature = signature; body = body} }

let parseModule = spaces >>. many parseFunction .>> spaces .>> eof

let public parseProgram s : ParserFunction list =
  match run parseModule s with
  | Success(result,_,_) -> result
  | Failure(err,_,_) -> failf "parser failed: %s" err









