package samcarr.freedomtoyell.convert

import org.scalatest._
import org.scalatest.matchers.ShouldMatchers
import samcarr.freedomtoyell._
import java.net.URI

class UriExtractorSpec extends UnitSpec {
    val ArticleDir = "foo/"
    implicit val config = Config("", "www.old.com", "", ArticleDir, "")
    val uriExtractor = new UriExtractor(config)
    
    import UnitSpec.string2Uri

    "UriExtractor" should "find img URL in trivial img tag" in {
        val input = """<img src="http://www.old.com" />"""
        check(input, List(ImageUri("http://www.old.com")))
    }

    it should "find img URL in non-trivial img tag" in {
        // Notable features of the input:
        // - attr between img and src
        // - attr after src
        // - space around =
        // - non-lowercase tag and attribute names
        // - non-lowercase URL that only matches oldHost when case insensitive.
        // - self-closing img tag with space before /
        val input = """<Img class = "image" SRC = "http://www.OLD.com" alt="foo" />"""
        check(input, List(ImageUri("http://www.OLD.com")))
    }

    it should "find img URL where the tag is not the whole input" in {
        val input = """<a href="foo"><img src="http://www.old.com" /></a>"""
        check(input, List(ImageUri("http://www.old.com")))
    }

    it should "not find img URL where the URL does not contain the old host" in {
        val input = """<a href="foo"><img src="http://www.notold.com" /></a>"""
        check(input, List())
    }

    it should "find link URL for a typical Typepad image used in popup" in {
        val input = """<a href="http://www.old.com/bar/1234-pi">Foo</a>"""
        check(input, List(ImageUri("http://www.old.com/bar/1234-pi")))
    }

    it should "find link URL for typical Typepad popup image (actually serves HTML)" in {
        val input = """<a href="http://www.old.com/bar/1234-popup">Foo</a>"""
        check(input, List(ImageUri("http://www.old.com/bar/1234-popup")))
    }

    it should "find link URL for typical Typepad scaled image" in {
        val input = """<a href="http://www.old.com/bar/1234-350wi">Foo</a>"""
        check(input, List(ImageUri("http://www.old.com/bar/1234-350wi")))
    }

    it should "find link URL in non-trivial tag" in {
        // Notable features of the input:
        // - attr between a and href
        // - attr after href
        // - space around =
        // - non-lowercase tag and attribute names
        // - non-lowercase URL that only matches oldHost when case insensitive.
        val input = """<A class = "popup" HREF = "http://www.OLD.com/123-pi" id="foo" />"""
        check(input, List(ImageUri("http://www.OLD.com/123-pi")))
    }
    
    it should "not find link URL where the URL does not contain the old host" in {
        val input = """<a href="http://www.notold.com/123-pi" /></a>"""
        check(input, List())
    }
    
    it should "find linked article URL" in {
        val input = s"""<a href="http://www.old.com/${ArticleDir}2008/04/some-old-article.html""""
        check(input, List(ArticleUri(s"http://www.old.com/${ArticleDir}2008/04/some-old-article.html")))
    }

    private def check(input: String, expected: List[UriForMigration]) = {
        uriExtractor.extract(input).toList should be (expected)
    }
}