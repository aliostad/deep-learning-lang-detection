namespace RegexModelerTests

open ListHelpers
open NUnit.Framework
open RegexModeler
open RegexModeler.Main

type PosixTests () =

    let charSet = Factory.GetICharset()

    [<Test>]
    member _x.``:upper: gets an uppercase letter.``() =
        let testRegex = "hello [:upper:]orld"
        let expectedCharSet = charSet.posixUpper
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:lower: gets a lowercase letter.``() =
        let testRegex = "hello [:lower:]orld"
        let expectedCharSet = charSet.posixLower
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:alpha: gets an alpha letter.``() =
        let testRegex = "hello [:alpha:]orld"
        let expectedCharSet = charSet.posixAlpha 
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:alnum: gets an alphanumeric letter.``() =
        let testRegex = "hello [:alnum:]orld"
        let expectedCharSet = charSet.posixAlnum
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:digit: gets a digit.``() =
        let testRegex = "hello [:digit:]orld"
        let expectedCharSet = charSet.posixDigit
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:xdigit: gets a hex digit.``() =
        let testRegex = "hello [:xdigit:]orld"
        let expectedCharSet = charSet.posixXdigit 
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:punct: gets punctuation.``() =
        let testRegex = "hello [:punct:]orld"
        let expectedCharSet = charSet.posixPunct
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:blank: gets space or tab.``() =
        let testRegex = "hello [:blank:]orld"
        let expectedCharSet = charSet.posixBlank
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:space: gets whitespace, including line breaks.``() =
        let testRegex = "hello [:space:]orld"
        let expectedCharSet = charSet.posixSpace
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:cntrl: gets a control character.``() =
        let testRegex = "hello [:cntrl:]orld"
        let expectedCharSet = charSet.posixCntrl
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:graph: gets printable character.``() =
        let testRegex = "hello [:graph:]orld"
        let expectedCharSet = charSet.posixGraph
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:print: gets printable characters and spaces.``() =
        let testRegex = "hello [:print:]orld"
        let expectedCharSet = charSet.posixPrint
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:word: matches digits, letters, and underscore.``() =
        let testRegex = "hello [:word:]orld"
        let expectedCharSet = charSet.posixWord
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<Test>]
    member _x.``:ascii: matches any ASCII character.``() =
        let testRegex = "hello [:ascii:]orld"
        let expectedCharSet = charSet.posixAscii
        let actual = processInput <| stringToChrs testRegex
        CollectionAssert.Contains(expectedCharSet, actual.[6])
        Assert.AreEqual("hello world".Length, actual.Length)

    [<TestCase @"hello [:puke:]orld">]
    [<TestCase @"hello [:Word:]orld">]
    [<TestCase @"hello [:DIGIT:]orld">]
    member _x.``When given a non-matching POSIX class, throws error.``(badRegex) =
        let badProcessCall = fun () -> stringToChrs badRegex |> processInput |> ignore
        Assert.That(badProcessCall, Throws.ArgumentException)

    [<Test>]
    member _x.``When given a malformed POSIX class, throws error.``() = 
        let testRegex = "hello [:oops]"
        let badProcessCall = fun () -> stringToChrs testRegex |> processInput |> ignore
        Assert.That(badProcessCall, Throws.TypeOf<InvalidCharacterSetException>())
