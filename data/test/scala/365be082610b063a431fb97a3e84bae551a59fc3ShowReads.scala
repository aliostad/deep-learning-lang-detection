package com.netgents.typeclass

object ShowReads extends App {
  
  def split(str: String, sep: Char): List[String] = {
    def findString(s: (String, String)): (String, String) = s._2.headOption match {
      case Some(c) if c == '"' && s._1.last != '\\' => (s._1 + c, s._2.tail)
      case Some(c) => findString((s._1 + c, s._2.tail))
      case None => (s._1, s._2)
    }
    def findSep(s: (String, String), b: Int): (String, String) = s._2.headOption match {
      case Some(c) => c match {
        case '"' => findSep(findString((s._1 + c, s._2.tail)), b)
        case '[' | '{' => findSep((s._1 + c, s._2.tail), b + 1)
        case ']' | '}' => findSep((s._1 + c, s._2.tail), b - 1)
        case _ if c == sep && b == 0 => (s._1, s._2.tail)
        case _ => findSep((s._1 + c, s._2.tail), b)
      }
      case None => s
    }
    if (str == "") List.empty
    else {
      val (s1, s2) = findSep(("", str), 0)
      s1 :: split(s2, sep)
    }
  }
  
  trait ShowRead[A] {
    def show(x: A): String
    def read(s: String): A
  }
  
  object ShowRead {
    def apply[A : ShowRead] = implicitly[ShowRead[A]]
    implicit object IntShowRead extends ShowRead[Int] {
      def show(x: Int) = x.toString
      def read(s: String) = s.toInt
    }
    implicit object StringShowRead extends ShowRead[String] {
      def show(x: String) = "\"" + x.replaceAllLiterally("\"", "\\\"") + "\""
      def read(s: String) = s.drop(1).init.replaceAllLiterally("\\\"", "\"")
    }
    implicit def ListShowRead[A : ShowRead] = new ShowRead[List[A]] {
      def show(x: List[A]) = x.map(ShowRead[A].show(_)).mkString("[", ",", "]")
      def read(s: String) = split(s.drop(1).init, ',').map(ShowRead[A].read(_)).toList
    }
    implicit def MapShowRead[A : ShowRead, B: ShowRead] = new ShowRead[Map[A, B]] {
      def show(x: Map[A, B]) = "{" + x.map(kv => ShowRead[A].show(kv._1) + ":" + ShowRead[B].show(kv._2)).mkString(",") + "}"
      def read(s: String) = Map(split(s.drop(1).init, ',').map(split(_, ':')).map(kv => (ShowRead[A].read(kv(0)), ShowRead[B].read(kv(1)))): _*)
    }
  }
  
  def show[A : ShowRead](x: A): String = ShowRead[A].show(x)
  def read[A : ShowRead](s: String): A = ShowRead[A].read(s)
  
  assert(read[Int](show(123)) == 123)
  assert(read[String](show("hello\"world")) == "hello\"world")
  assert(read[List[Int]](show(List(1, 2, 3))) == List(1, 2, 3))
  assert(read[List[String]](show(List("a", "b", "c"))) == List("a", "b", "c"))
  assert(read[List[List[Int]]](show(List(List(1, 2), List(2, 3), List(3, 4)))) == List(List(1, 2), List(2, 3), List(3, 4)))
  assert(read[Map[String, Int]](show(Map("a" -> 1, "b" -> 2))) == Map("a" -> 1, "b" -> 2))
  assert(read[Map[Int, List[String]]](show(Map(1 -> List("a", "b"), 2 -> List("b", "c"), 3 -> List("c", "d")))) == Map(1 -> List("a", "b"), 2 -> List("b", "c"), 3 -> List("c", "d")))
}