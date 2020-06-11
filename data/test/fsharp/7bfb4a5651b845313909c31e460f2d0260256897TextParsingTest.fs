namespace prismic.tests
open System
open System.Text.RegularExpressions
open prismic
open prismic.Fragments
open NUnit.Framework

[<TestFixture>]
type TextParsing() =

    let linkresolver = Api.DocumentLinkResolver.For(fun l ->
                        String.Format("""http://localhost/{0}/{1}""", l.typ, l.id))


    [<Test>]
    member x.``Should Escape HTML content``() =
        let text = Fragment.Text("&my <value> #abcde")
        let expectedExceptTags = "^<[^>]+>&amp;my &lt;value&gt; #abcde<[^>]+>$"
        let actual = Api.asHtml linkresolver Api.HtmlSerializer.Empty text
        Assert.IsTrue(Regex.IsMatch(actual, expectedExceptTags))
