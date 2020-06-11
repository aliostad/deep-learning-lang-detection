package com.github.seratch.ltsv4s

object LTSV {

  def parseLine(line: String, lenient: Boolean = false): Map[String, String] =
    LTSVParser.parse(line, lenient).head

  def parseLines(lines: String, lenient: Boolean = false): List[Map[String, String]] =
    LTSVParser.parse(lines, lenient)

  def dump(value: Map[String, String]): String = dump(value.toSeq: _*)

  def dump(values: List[Map[String, String]]): List[String] = values.map(dump)

  def dump(value: (String, String)*): String = value.map { case (k, v) => k + ":" + v }.mkString("\t")

}

