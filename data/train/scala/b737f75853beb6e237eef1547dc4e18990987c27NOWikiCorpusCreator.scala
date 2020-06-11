import info.bliki.wiki.dump.WikiXMLParser
import java.io.File

object NOWikiCorpusCreator {
  def main(args: Array[String]) {
    val arglist = args.toList
    type OptionMap = Map[Symbol, Any]

    def nextOption(map : OptionMap, list : List[String]) : OptionMap = {
      list match {
        case Nil => map
        case "-c" :: value :: tail => nextOption(map ++ Map('corpus_dir -> value), tail)
        case "-w" :: value :: tail => nextOption(map ++ Map('wiki_dump -> value), tail)
        case _ => println("error")
          sys.exit(1)
      }
    }

    val options = nextOption(Map(), arglist)

    if (options.contains('corpus_dir).&&(options.contains('wiki_dump)).unary_!) {
      println("error")
      sys.exit(1)
    }

    val root = System.getProperty("user.dir")
    val wikiDir = "nowiki-20130702"
    val dumpFile = "nowiki-20130702-pages-articles.xml"

    val p = new File(root, wikiDir)
    val f = new File(p, dumpFile)

    val handler = new ArticleFilter(new File(options('corpus_dir).toString))

    val wxp = new WikiXMLParser(options('wiki_dump).toString, handler)
    wxp.parse()
  }
}
