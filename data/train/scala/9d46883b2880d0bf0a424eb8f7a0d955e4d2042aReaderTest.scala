
package com.github.rubyu.parsertuning

import org.specs2.mutable._
import java.io
import org.specs2.specification.Scope


class ReaderTest extends SpecificationWithJUnit {

  "Reader" should {

    sequential

    trait scope extends Scope {
      val readers = List(
        (p: Parser, r: io.Reader) => new Reader1(p, r),
        (p: Parser, r: io.Reader) => new Reader2(p, r),
        (p: Parser, r: io.Reader) => new Reader3(p, r),
        (p: Parser, r: io.Reader) => new Reader4(p, r)
      )
      val parsers = List(
        new Parser1,
        new Parser2,
        new Parser3
      )

      def dump(r: Reader, p: Parser) = {
        println(s"reader=${ r.getClass.getName } ,parser=${ p.getClass.getName }")
        System.out.flush()
      }

    }

    "parse raw-text" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("a"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a")))
        }}
    }

    "parse quoted-text" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("\"a\""))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a")))
        }}
    }

    "parse \\n" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("\n"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List()))
        }}
    }

    "parse \\r\\r\\n as two empty Row" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("\r\r\n"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List()), Result.Row(List()))
        }}
    }

    "parse \\r\\n" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("\r\n"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List()))
        }}
    }

    "parse quoted-text contains \\n" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("\"a\nb\""))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a\nb")))
        }}
    }

    "parse raw-text, DELIM, raw-text" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("a\tb"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a", "b")))
        }}
    }

    "parse raw-text, DELIM, raw-test, DELIM, raw-text" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("a\tb\tc"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a", "b", "c")))
        }}
    }

    "parse raw-text, \\n, raw-text" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("a\nb"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a")), Result.Row(List("b")))
        }}
    }

    "parse raw-text, \\n, raw-text, \\n, raw-text" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("a\nb\nc"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a")), Result.Row(List("b")), Result.Row(List("c")))
        }}
    }

    "parse raw-text, \\n" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("a\n"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a")))
        }}
    }

    "parse raw-text, \\r\\n" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("a\r\n"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a")))
        }}
    }

    "parse raw-text, \\r\\r\\n" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("a\r\r\n"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.Row(List("a")), Result.Row(List()))
        }}
    }

    "parse un-closed quote-text as InvalidString" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("\"a"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.InvalidString("\"a"))
        }}
    }

    "parse a Result.Row that has un-closed quote-text as Result.Row, InvalidString" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader("a\t\"b"))
        dump(reader, parser)
        reader.toList mustEqual List(Result.InvalidString("a\t\"b"))
        }}
    }

    "return empty input when empty input is given" in new scope {
      parsers map { parser => readers map {r =>
        val reader = r(parser, new io.StringReader(""))
        dump(reader, parser)
        reader.toList mustEqual List()
        }}
    }
  }
}
