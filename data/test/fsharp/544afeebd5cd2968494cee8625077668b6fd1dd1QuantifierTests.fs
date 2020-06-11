namespace UnitTests

open TestHelpers
open ListHelpers
open NUnit.Framework
open RegexModeler.Interfaces

type QuantifierTests () =

    let numGeneratorMock =   
            {
                new INumGenerator with
                    member _x.GetNumber max = 
                        (max / 2)
                    member _x.GetNumberInRange min max = 
                        match (min, max) with
                        | (Some(min), Some(max)) -> (min + max) / 2
                        | (Some(min), None)      -> (min + min*2) / 2 
                        | (None, _)              -> invalidArg "bad dog" "wrong argument"
                                                    0
            }

    let q = new RegexModeler.Quantifier(numGeneratorMock) :> IQuantifier

    [<Test>]
    member _x.``processQuantifier, when only given single quantifier, returns that number plus an empty list.``() =
        let input = stringToChrs "{3}"
        let expected = (3, List<char>.Empty)
        let actual = q.processQuantifier(input)
        Assert.PairsEqual expected actual

    [<Test>]
    member _x.``processQuantifier, when given range quantifier, returns number within range.``() = 
        let input = stringToChrs "{3,5}"
        let expected = (4, List<char>.Empty)
        let actual = q.processQuantifier(input)
        Assert.PairsEqual expected actual

    [<Test>]
    member _x.``processQuantifier, when given open-ended range quantifier, returns number within range.``() = 
        let input = stringToChrs "{3,}"
        let expected = ((3 + 2*3)/2, List<char>.Empty)
        let actual = q.processQuantifier(input)
        Assert.PairsEqual expected actual

    [<Test>]
    member _x.``processQuantifier, when given star quantifier, returns 5.``() = 
        let input = stringToChrs "*"
        let expected = (5, List<char>.Empty)
        let actual = q.processQuantifier(input)
        Assert.PairsEqual expected actual
    
    [<Test>]
    member _x.``processQuantifier, when given plus quantifier, returns 1.``() =
        let input = stringToChrs "+"
        let expected = ((1 + 10) / 2, List<char>.Empty)
        let actual = q.processQuantifier(input)
        Assert.PairsEqual expected actual

    [<Test>]
    member _x.``processQuantifier, when given question mark quantifier, returns 0.``() =
        let input = stringToChrs "?"
        let expected = ((0 + 1) / 2, List<char>.Empty)
        let actual = q.processQuantifier(input)
        Assert.PairsEqual expected actual
