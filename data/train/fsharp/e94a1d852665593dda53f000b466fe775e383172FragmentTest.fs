namespace prismic.tests
open prismic
open System
open FSharp.Data
open NUnit.Framework
open Fragments
open FragmentsGetters
open FragmentsHtml

module FragmentTest =

    let await a = a |> Async.RunSynchronously
    let apiGetNoCache = Api.get (ApiInfra.NoCache() :> ApiInfra.ICache<Api.Response>) (ApiInfra.Logger.NoLogger)
    let htmlSerializer = Api.HtmlSerializer.Empty

    [<TestFixture>]
    type ``Query Document and Parse Fragments``() =

        [<Test>]
        member x.``Should Access Group Field``() =
            let url = "https://micro.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.type, "docchapter")]]""")
            let document = await(form.Submit()).results |> List.head
            let maybeGroup = document.fragments |> getGroup "docchapter.docs"
            match maybeGroup with
                            | Some(Group(docs)) ->
                                match docs |> Seq.tryPick Some with
                                    | Some(doc) -> match doc.fragments |> getLink "linktodoc" with
                                                            | Some(Link(DocumentLink(l))) -> Assert.IsNotNull(l.id)
                                                            | _ -> Assert.Fail("No link found")
                                    | _ -> Assert.Fail("No document found")
                            | _ -> Assert.Fail("Result is not of type group")


        [<Test>]
        member x.``Should Serialize Group To HTML``() =
            let url = "https://micro.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.type, "docchapter")]]""")
            let documentf = await(form.Submit()).results
            let document = List.nth documentf  1
            let maybeGroup = document.fragments |> getGroup "docchapter.docs"
            match maybeGroup with
                            | Some(g) ->
                                let linkresolver = Api.DocumentLinkResolver.For(fun l ->
                                    String.Format("""http://localhost/{0}/{1}""", l.typ, l.id))
                                let html = Api.asHtml linkresolver htmlSerializer g
                                Assert.AreEqual("""<section data-field="linktodoc"><a href="http://localhost/doc/UrDejAEAAFwMyrW9">installing-meta-micro</a></section>
<section data-field="desc"><p>Just testing another field in a group section.</p></section>
<section data-field="linktodoc"><a href="http://localhost/doc/UrDmKgEAALwMyrXA">using-meta-micro</a></section>""", html)
                            | _ -> Assert.Fail("Result is not of type group")


        [<Test>]
        member x.``Should Serialize Another Group To HTML``() =
            let url = "https://micro.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.type, "docchapter")]]""")
            let documentf = await(form.Submit()).results
            let document = List.head documentf
            let maybeGroup = document.fragments |> getGroup "docchapter.docs"
            match maybeGroup with
                            | Some(g) ->
                                let linkresolver = Api.DocumentLinkResolver.For(fun l ->
                                    String.Format("""http://localhost/{0}/{1}""", l.typ, l.id))
                                let html = Api.asHtml linkresolver htmlSerializer g
                                Assert.AreEqual("""<section data-field="linktodoc"><a href="http://localhost/doc/UrDofwEAALAdpbNH">with-jquery</a></section>
<section data-field="linktodoc"><a href="http://localhost/doc/UrDp8AEAAPUdpbNL">with-bootstrap</a></section>""", html)
                            | _ -> Assert.Fail("Result is not of type group")

        [<Test>]
        member x.``Should serialize to HTML with a custom rendering``() =
            let url = "https://lesbonneschoses.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.id, "UlfoxUnM0wkXYXbf")]]""")
            let documentf = await(form.Submit()).results
            let document = List.head documentf
            let content = document.fragments |> getStructuredText "article.content"
            match content with
                | Some(c) ->
                    let linkresolver = Api.DocumentLinkResolver.For(fun l ->
                        String.Format("""http://localhost/{0}/{1}""", l.typ, l.id))
                    let customSerializer = Api.HtmlSerializer.For(fun (elt) (content) ->
                        match elt with
                            | Span(Span.Hyperlink(_, _, Link.DocumentLink(l))) ->
                                Some(String.Format("""<a class="some-link" href="{0}">{1}</a>""", linkresolver.Apply l, content))
                            | Block(Block.Image(view)) -> Some(imageViewAsHtml linkresolver.Apply view)
                            | _ -> None
                    )
                    let html = Api.asHtml linkresolver customSerializer c
                    printfn "%s" html
                    Assert.AreEqual("""<h2>A tale of pastry and passion</h2>
<p>As a child, Jean-Michel Pastranova learned the art of fine cuisine from his grand-father, Jacques Pastranova, who was the creator of the &quot;taste-design&quot; art current, and still today an unmissable reference of forward-thinking in cuisine. At first an assistant in his grand-father&#39;s kitchen, Jean-Michel soon found himself fascinated by sweet flavors and the tougher art of pastry, drawing his own path in the ever-changing cuisine world.</p>
<p>In 1992, the first Les Bonnes Choses store opened on rue Saint-Lazare, in Paris (<a class="some-link" href="http://localhost/store/UlfoxUnM0wkXYXbb">we&#39;re still there!</a>), much to everyone&#39;s surprise; indeed, back then, it was very surprising for a highly promising young man with a preordained career as a restaurant chef, to open a pastry shop instead. But soon enough, contemporary chefs understood that Jean-Michel had the drive to redefine a new nobility to pastry, the same way many other kinds of cuisine were being qualified as &quot;fine&quot;.</p>
<p>In 1996, meeting an overwhelming demand, Jean-Michel Pastranova opened <a class="some-link" href="http://localhost/store/UlfoxUnM0wkXYXbP">a second shop on Paris&#39;s Champs-&#201;lys&#233;es</a>, and <a class="some-link" href="http://localhost/store/UlfoxUnM0wkXYXbr">a third one in London</a>, the same week! Eventually, Les Bonnes Choses gained an international reputation as &quot;a perfection so familiar and new at the same time, that it will feel like a taste travel&quot; (New York Gazette), &quot;the finest balance between surprise and comfort, enveloped in sweetness&quot; (The Tokyo Tribune), &quot;a renewal of the pastry genre (...), the kind that changed the way pastry is approached globally&quot; (The San Francisco Gourmet News). Therefore, it was only a matter of time before Les Bonnes Choses opened shops in <a class="some-link" href="http://localhost/store/UlfoxUnM0wkXYXbc">New York</a> (2000) and <a class="some-link" href="http://localhost/store/UlfoxUnM0wkXYXbU">Tokyo</a> (2004).</p>
<p>In 2013, Jean-Michel Pastranova stepped down as the CEO and Director of Workshops, remaining a senior advisor to the board and to the workshop artists; he passed the light on to Selena, his daugther, who initially learned the art of pastry from him. Passion for great food runs in the Pastranova family...</p>
<img alt="" src="https://prismic-io.s3.amazonaws.com/lesbonneschoses/df6c1d87258a5bfadf3479b163fd85c829a5c0b8.jpg" width="800" height="533" />
<h2>Our main value: our customers&#39; delight</h2>
<p>Our every action is driven by the firm belief that there is art in pastry, and that this art is one of the dearest pleasures one can experience.</p>
<p>At Les Bonnes Choses, people preparing your macarons are not simply &quot;pastry chefs&quot;: they are &quot;<a class="some-link" href="http://localhost/job-offer/UlfoxUnM0wkXYXba">ganache specialists</a>&quot;, &quot;<a class="some-link" href="http://localhost/job-offer/UlfoxUnM0wkXYXbQ">fruit experts</a>&quot;, or &quot;<a class="some-link" href="http://localhost/job-offer/UlfoxUnM0wkXYXbn">oven instrumentalists</a>&quot;. They are the best people out there to perform the tasks they perform to create your pastry, giving it the greatest value. And they just love to make their specialized pastry skill better and better until perfection.</p>
<p>Of course, there is a workshop in each <em>Les Bonnes Choses</em> store, and every pastry you buy was made today, by the best pastry specialists in your country.</p>
<p>However, the very difficult art of creating new concepts, juggling with tastes and creating brand new, powerful experiences, is performed every few months, during our &quot;<a class="some-link" href="http://localhost/blog-post/UlfoxUnM0wkXYXbl">Pastry Art Brainstorms</a>&quot;. During the event, the best pastry artists in the world (some working for <em>Les Bonnes Choses</em>, some not) gather in Paris, and showcase the experiments they&#39;ve been working on; then, the other present artists comment on the piece, and iterate on it together, in order to make it the best possible masterchief!</p>
<p>The session is presided by Jean-Michel Pastranova, who then selects the most delightful experiences, to add it to <em>Les Bonnes Choses</em>&#39;s catalogue.</p>""", html)
                | _ -> Assert.Fail("Failed to retrieve article content")


        [<Test>]
        member x.``Should Access Media Link``() =
            let url = "https://test-public.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.id, "Uyr9_wEAAKYARDMV")]]""")
            let document = await(form.Submit()).results |> List.head
            let maybeLink = document.fragments |> getLink "test-link.related"
            match maybeLink with
                            | Some(Link(MediaLink(l))) -> Assert.AreEqual("baastad.pdf", l.filename)
                            | _ -> Assert.Fail("Media Link not found")

        [<Test>]
        member x.``Should Access First Link In Multiple Document Link``() =
            let url = "https://lesbonneschoses.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.id, "UlfoxUnM0wkXYXba")]]""")
            let document = await(form.Submit()).results |> List.head
            let maybeLink = document.fragments |> getLink "job-offer.location"
            match maybeLink with
                            | Some(Link(DocumentLink(l))) -> Assert.AreEqual("paris-saint-lazare", l.slug)
                            | _ -> Assert.Fail("Document Link not found")


        [<Test>]
        member x.``Should Find All Links In Multiple Document Link``() =
            let url = "https://lesbonneschoses.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.id, "UlfoxUnM0wkXYXba")]]""")
            let document = await(form.Submit()).results |> List.head
            let links = document.fragments |> getAll "job-offer.location"
            Assert.AreEqual(3, links |> Seq.length)
            let link0 = links |> Seq.nth 0
            match link0 with
                            | Link(DocumentLink(l)) -> Assert.AreEqual("paris-saint-lazare", l.slug)
                            | _ -> Assert.Fail("Document Link not found")
            let link1 = links |> Seq.nth 1
            match link1 with
                            | Link(DocumentLink(l)) -> Assert.AreEqual("tokyo-roppongi-hills", l.slug)
                            | _ -> Assert.Fail("Document Link not found")


        [<Test>]
        member x.``Should Access Structured Text``() =
            let url = "https://lesbonneschoses.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.id, "UlfoxUnM0wkXYXbX")]]""")
            let document = await(form.Submit()).results |> List.head
            let maybeStructTxt = document.fragments |> getStructuredText "blog-post.body"
            Assert.IsTrue(maybeStructTxt.IsSome)

        [<Test>]
        member x.``Should Access Image``() =
            let linkresolver = fun (l: DocumentLink) -> String.Format("""http://localhost/{0}/{1}""", l.typ, l.id)
            let url = "https://test-public.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.id, "Uyr9sgEAAGVHNoFZ")]]""")
            let document = await(form.Submit()).results |> List.head
            let maybeImg = document.fragments |> getImageView "article.illustration" "icon"

            match maybeImg with
                            | Some(_) ->
                                let expectpattern = """<img alt="some alt text" src="{0}" width="100" height="100" />"""
                                let url = "https://prismic-io.s3.amazonaws.com/test-public/9f5f4e8a5d95c7259108e9cfdde953b5e60dcbb6.jpg"
                                let expect = String.Format(expectpattern, url)
                                let image = imageViewAsHtml linkresolver maybeImg.Value
                                Assert.AreEqual(expect, image)
                            | _ -> Assert.Fail("Document Link not found")


        [<Test>]
        member x.``Should Access GeoPoint``() =
            let url = "https://test-public.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.id, "U9pZMDQAADEAYj_n")]]""")
            let document = await(form.Submit()).results |> List.head
            let maybeGeoPoint = document.fragments |> getGeoPoint "product.location"

            match maybeGeoPoint with
                            | Some(g) ->
                                let expected = """<div class="geopoint"><span class="latitude">48.87687670000001</span><span class="longitude">2.3338801999999825</span></div>"""
                                let linkresolver = Api.DocumentLinkResolver.For(fun l -> String.Format("""http://localhost/{0}/{1}""", l.typ, l.id))
                                Assert.AreEqual(expected, Api.asHtml linkresolver htmlSerializer g)
                            | _ -> Assert.Fail("GeoPoint not found")

        [<Test>]
        member x.``Should Access Embed``() =
            let url = "https://test-public.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.id, "Uy4VGQEAAPQzRDR9")]]""")
            let document = await(form.Submit()).results |> List.head
            let maybeEmbed = document.fragments |> getEmbed "test-link.embed"

            match maybeEmbed with
                            | Some(e) ->
                                let expected = """<div data-oembed="https://gist.github.com/srenault/71b4f1e62783c158f8af" data-oembed-type="rich" data-oembed-provider="github"><script src="https://gist.github.com/srenault/71b4f1e62783c158f8af.js"></script></div>"""
                                let linkresolver = Api.DocumentLinkResolver.For(fun l -> String.Format("""http://localhost/{0}/{1}""", l.typ, l.id))
                                Assert.AreEqual(expected, Api.asHtml linkresolver htmlSerializer e)
                            | _ -> Assert.Fail("Ebed not found")

        [<Test>]
        member x.``Shoud Parse Timestamp``() =
            let json = JsonValue.Parse "{\"id\": \"UlfoxUnM0wkXYXbm\",\
                \"type\": \"blog-post\",\
                \"href\": \"https://example.com\",\
                \"slugs\": [\"tips-to-dress-a-pastry\"],\
                \"tags\": [],\
                \"data\": { \"blog-post\": { \"when\": { \"type\": \"Timestamp\", \"value\": \"2014-06-18T15:30:00+0000\" } } } }"
            let document = prismic.Api.Document.fromJson (json)
            let tstamp = document.fragments |> getTimestamp "blog-post.when"
            let linkresolver = Api.DocumentLinkResolver.For(fun l -> String.Format("""http://localhost/{0}/{1}""", l.typ, l.id))

            match tstamp with
                    | Some(ts) ->
                        Assert.AreEqual("<time>2014-06-18 15:30:00</time>", Api.asHtml linkresolver htmlSerializer ts)
                    | _ -> Assert.Fail("Timestamp not found")
