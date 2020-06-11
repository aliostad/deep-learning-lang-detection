namespace ParserCombinators.API

open ParserCombinators.Core.Parsers

[<AllowNullLiteralAttribute>]
type ParserResult (result, remaining:seq<char>) = 
    member x.RemainingInput:seq<char> = remaining;
    member x.HasSucceeded:bool = result;

type Parser = delegate of seq<char> -> ParserResult

module Parsers = 
    let CoreParserWrapper coreParser = new Parser(fun input -> new ParserResult(coreParser input ));

    let ApiParserWrapper (apiParser:Parser) = 
        fun input -> 
            let res = apiParser.Invoke(input);
            match res with
            | null -> false, input
            | _ -> res.HasSucceeded, res.RemainingInput;


    let TerminalParser terminal = CoreParserWrapper (terminalParser terminal);

    let EofParser = CoreParserWrapper eofParser;

    let SequenceParser first second = CoreParserWrapper(sequenceParser (ApiParserWrapper first) (ApiParserWrapper second));

    let AlternateParser first second = CoreParserWrapper(alternateParser (ApiParserWrapper first) (ApiParserWrapper second));
