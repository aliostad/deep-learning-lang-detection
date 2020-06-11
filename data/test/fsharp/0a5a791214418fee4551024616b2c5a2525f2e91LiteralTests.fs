namespace RegexModelerTests

open NUnit.Framework
open RegexModeler
open RegexModeler.Main
open ListHelpers
open System

type LiteralTests () = 

    [<Test>]
    member _x.``When given empty string, returns empty string`` () =
        let expected = String.Empty
        let actual = processInput <| stringToChrs String.Empty
        Assert.That(actual, Is.EqualTo expected)

    [<Test>]
    member _x.``When given verbatim string, returns the same string`` () =
        let expected = @"hlowrld"
        let actual = processInput <| stringToChrs @"hlowrld"
        Assert.That(actual, Is.EqualTo expected)
   
    [<Test>]
    member _x.``When given an escaped slash, inserts a literal slash`` () =
        let expected = @"hel\lo"
        let actual = processInput <| stringToChrs @"hel\\lo"
        Assert.That(actual, Is.EqualTo expected)

    [<Test>]
    member _x.``When given a control char, inserts that control char`` () =
        let expected = "hel^Mlo"
        let actual = processInput <| stringToChrs @"hel\cMlo"
        Assert.That(actual, Is.EqualTo expected)

    [<Test>]
    member _x.``When given a lowercase control char, inserts uppercase control char`` () =
        let expected = "hel^Mlo"
        let actual = processInput <| stringToChrs @"hel\cmlo"
        Assert.That(actual, Is.EqualTo expected)

    [<Test>]
    member _x.``When give one-digit hex, returns Unicode char`` () =
        let expected = "hel\u000Flo"
        let actual = processInput <| stringToChrs @"hel\x{F}lo"
        Assert.That(actual, Is.EqualTo expected)

    [<Test>]
    member _x.``When given two-digit hex, returns Unicode char`` () =
        let expected = "hel\u00A9lo"
        let actual = processInput <| stringToChrs @"hel\x{A9}lo"
        Assert.That(actual, Is.EqualTo expected)
        
    [<Test>]
    member _x.``When given three-digit hex, returns Unicode char`` () = 
        let expected = "hel\u020Alo"
        let actual = processInput <| stringToChrs @"hel\x{20A}lo"
        Assert.That(actual, Is.EqualTo expected)

    [<Test>]
    member _x.``When given four-digit hex, returns Unicode char`` () = 
        let expected = "hel\u20AClo"
        let actual = processInput <| stringToChrs @"hel\x{20AC}lo"
        Assert.That(actual, Is.EqualTo expected)
        
    [<Test>]
    member _x.``When give one-digit unicode hex, returns Unicode char`` () =
        let expected = "hel\u000Flo"
        let actual = processInput <| stringToChrs @"hel\u{F}lo"
        Assert.That(actual, Is.EqualTo expected)

    [<Test>]
    member _x.``When given two-digit unicode hex, returns Unicode char`` () =
        let expected = "hel\u00A9lo"
        let actual = processInput <| stringToChrs @"hel\u{A9}lo"
        Assert.That(actual, Is.EqualTo expected)
        
    [<Test>]
    member _x.``When given three-digit unicode hex, returns Unicode char`` () = 
        let expected = "hel\u020Alo"
        let actual = processInput <| stringToChrs @"hel\u{20A}lo"
        Assert.That(actual, Is.EqualTo expected)

    [<Test>]
    member _x.``When given four-digit unicode hex, returns Unicode char`` () = 
        let expected = "hel\u20AClo"
        let actual = processInput <| stringToChrs @"hel\u{20AC}lo"
        Assert.That(actual, Is.EqualTo expected)

    [<Test>]
    member _x.``When given four-digit unicode hex without braces, returns Unicode char`` () =
        let expected = "hel\u20AClo"
        let actual = processInput <| stringToChrs @"hel\u20AClo"
        Assert.That(actual, Is.EqualTo expected)
