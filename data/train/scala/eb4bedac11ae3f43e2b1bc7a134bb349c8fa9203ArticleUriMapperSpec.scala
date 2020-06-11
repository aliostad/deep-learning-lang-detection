package samcarr.freedomtoyell.convert

import org.scalatest._
import org.scalatest.matchers.ShouldMatchers
import samcarr.freedomtoyell._
import java.net.URI

class ArticleUriMapperSpec extends UnitSpec {
    val ArticleDir = "foo/"
    implicit val config = Config("", "old.com", "new.net", ArticleDir, "")
    
    import UnitSpec.string2Uri
    
    "ArticleUriMapper" should "remove directory prefix and .html suffix" in {
        ArticleUriMapper.mapUri(s"http://old.com/${ArticleDir}some-old-article.html") should
                be (new URI("http://new.net/some-old-article"))
    }
}