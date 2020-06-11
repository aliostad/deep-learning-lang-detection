package chunked

import utils.{TakeUntilStringParser, TakeUntilParser}

import scala.collection.immutable.PagedSeq
import scala.util.parsing.combinator.Parsers
import scala.util.parsing.input._


/**
 * Created by alex on 25.04.15.
 */
object DumpChunkedIntoString extends TakeUntilStringParser {

    def parse(input: Reader[Char]) = parseAll(dump, input) match {
      case Success(e, rdr) => e
      case err => throw new RuntimeException(err.toString)
    }

    def cond: Parser[String] = "\n0\n"

    def p: Parser[String] = NumberParser.number.asInstanceOf[Parser[Int]] flatMap (n => repNIntoString(n, ".".r))

    def dump: Parser[String] = takeUntilIntoString(cond, p)
}