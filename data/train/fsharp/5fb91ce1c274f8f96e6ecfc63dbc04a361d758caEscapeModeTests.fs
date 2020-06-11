namespace UnitTests

open ListHelpers
open NUnit.Framework
open RegexModeler.Interfaces
open RegexModeler
open UnitTests.Stubs
open TestHelpers

type EscapeModeTests () =

    member _x.GetEscape(?quantifier, ?charGenerator, ?charClass) =
        let quantifier' = defaultArg quantifier (new QuantifierStub() :> IQuantifier)
        let charGenerator' = defaultArg charGenerator (new CharGeneratorStub() :> ICharGenerator)
        let charClass' = defaultArg charClass (new CharClassStub() :> ICharClass)
        new EscapeMode(quantifier', charGenerator', charClass')

    [<Test>]
    member x.``processEscape, when given literal slash and no quantifier, returns slash plus remaining chars.``() =
        let quantifierMock = 
            new QuantifierStub(processQuantifierFn = fun _c -> (1, ['t';'e';'s';'t'])) 
        let charGeneratorMock = 
            new CharGeneratorStub(
                GetNLiterals = fun _i _c -> ['\\']) 
        let escape = x.GetEscape(quantifierMock, charGeneratorMock)
        let input = stringToChrs "\\test"
        let expected = (['\\'], ['t';'e';'s';'t'])
        let actual = escape.processInMode input
        Assert.PairsEqual expected actual 

    [<Test>]
    member x.``processEscape, when given literal slash and a quantifier, returns slash the right number of times plus remaining chars.``() =
        let quantifierMock = 
            new QuantifierStub(processQuantifierFn = (fun _c -> (2, ['t';'e';'s';'t'])))
        let charGeneratorMock = 
            new CharGeneratorStub(GetNLiterals = (fun _i _c -> ['\\';'\\']))
        let escape = x.GetEscape(quantifierMock, charGeneratorMock)

        let input = stringToChrs "\\{2}test"
        let expected = (['\\';'\\'], ['t';'e';'s';'t'])
        let actual = escape.processInMode input
        Assert.PairsEqual expected actual

    [<Test>]
    member x.``processEscape, when given control char and no quantifier, returns control char and rest of list.``() =
        let quantifierMock = 
            new QuantifierStub(processQuantifierFn = (fun _c -> (1, ['b';'o';'o'])))
        let charGeneratorMock = 
            new CharGeneratorStub(GetNStringsAsList = (fun _i _c -> ['^';'M']))
        let escape = x.GetEscape(quantifierMock, charGeneratorMock)
        let input = stringToChrs @"cMboo"
        let expected = (['^';'M'], ['b';'o';'o'])
        let actual = escape.processInMode input
        Assert.PairsEqual expected actual

    [<Test>]
    member x.``processEscape, when given 2-digit hex char and no quantifier, returns hex char and rest of list.``() =
        let quantifierMock = 
            new QuantifierStub(processQuantifierFn = (fun _c -> (1, ['b';'o';'o'])))
        let charGeneratorMock = 
            new CharGeneratorStub(GetNStringsAsList = (fun _i _c -> ['F']))
        let escape = x.GetEscape(quantifierMock, charGeneratorMock)
        let input = stringToChrs @"x{46}boo"
        let expected = (['F'], ['b'; 'o'; 'o'])        
        let actual = escape.processInMode input
        Assert.PairsEqual expected actual
        
    [<Test>]
    member x.``processEscape, when given 4-digit(x) hex char and no quantifier, returns hex char and rest of list.``() =
        let quantifierMock = 
            new QuantifierStub(processQuantifierFn = (fun _c -> (1, ['b';'o';'o'])))
        let charGeneratorMock = 
            new CharGeneratorStub(GetNStringsAsList = (fun _i _c -> ['F']))
        let escape = x.GetEscape(quantifierMock, charGeneratorMock)
        let input = stringToChrs @"x{0046}boo"
        let expected = (['F'], ['b'; 'o'; 'o'])        
        let actual = escape.processInMode input
        Assert.PairsEqual expected actual
            
    [<Test>]
    member x.``processEscape, when given 4-digit(u) hex char and no quantifier, returns hex char and rest of list.``() =
        let quantifierMock = 
            new QuantifierStub(processQuantifierFn = (fun _c -> (1, ['b';'o';'o'])))
        let charGeneratorMock = 
            new CharGeneratorStub(GetNStringsAsList = (fun _i _c -> ['F']))
        let escape = x.GetEscape(quantifierMock, charGeneratorMock)
        let input = stringToChrs @"u0046boo"
        let expected = (['F'], ['b'; 'o'; 'o'])        
        let actual = escape.processInMode input
        Assert.PairsEqual expected actual

    [<Test>]
    member x.``processEscape, when given char class and no quantifier, returns one instance of that char class.``() =
        let quantifierMock = 
            new QuantifierStub(processQuantifierFn = (fun _c -> (1, ['b'; 'o'; 'o'])))
        let charClassMock = 
            new CharClassStub(getNCharsFromClass = (fun _i _c -> ['x']))
        let escape = x.GetEscape(quantifierMock, charClass = charClassMock)
        let input = stringToChrs @"dboo"
        let expected = (['x'], ['b'; 'o'; 'o'])
        let actual = escape.processInMode input
        Assert.PairsEqual expected actual
