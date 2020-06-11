// sbt run

import scala.collection.immutable

case class Employee(name: String, age: Int)

class Company(name: String, employees: List[Employee]) {
    override def toString(): String = {
        return s"name=${name}, employees=${employees}"
    }
}

trait LoadableStatic[T] {
    def load(iterator: Iterator[String]): T
}

object Load {
    def load[T](string: String)(implicit static: LoadableStatic[T]): T = {
        val tokens = string.split("/")
        return load(tokens.iterator)
    }
    def load[T](iterator: Iterator[String])(implicit static: LoadableStatic[T]): T = {
        return static.load(iterator)
    }
}

package object Implicits {
    implicit object IntLoadableStatic extends LoadableStatic[Int] {
        def load(iterator: Iterator[String]): Int = {
            val x = iterator.next
            return x.toInt
        }
    }

    implicit object StringLoadableStatic extends LoadableStatic[String] {
        def load(iterator: Iterator[String]): String = {
            val x = iterator.next
            return x
        }
    }

    implicit def createListLoadableStatic[T](implicit elementStatic: LoadableStatic[T]): LoadableStatic[List[T]] = {
        return new ListLoadableStatic[T](elementStatic)
    }

    class ListLoadableStatic[T](elementStatic: LoadableStatic[T]) extends LoadableStatic[List[T]] {
        def load(iterator: Iterator[String]): List[T] = {
            val n = Load.load[Int](iterator)
            var ret = List[T]()
            for (i <- 0 until n) {
                val x = Load.load[T](iterator)(elementStatic)
                ret = ret :+ x
            }
            return ret
        }
    }

    implicit object EmployeeLoadableStatic extends LoadableStatic[Employee] {
        def load(iterator: Iterator[String]): Employee = {
            return new Employee(
                Load.load[String](iterator),
                Load.load[Int](iterator)
                )
        }
    }

    implicit object CompanyLoadableStatic extends LoadableStatic[Company] {
        def load(iterator: Iterator[String]): Company = {
            return new Company(
                Load.load[String](iterator),
                Load.load[List[Employee]](iterator))
        }
    }
}

object Main {
    import Implicits._

    def main(args: Array[String]) {
        val i = Load.load[Int]("33")
        println(i)
        val s = Load.load[String]("abc")
        println(s)

        val a = Load.load[List[String]]("3/apple/banana/cherry")
        println(a)

        val c = Load.load[Company]("CatWorld/3/tama/5/mike/6/kuro/7")
        println(c)
    }
}

