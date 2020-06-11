package progscala2.rounding

import scala.language.reflectiveCalls
import scala.util.control.NonFatal

// 딘 왐플러(2015/12/21): 반환된 타입 T인 객체를 처리한다는 사실을
// 더 분명히 보여주기 위해 구현을 좀 더 변경하고, 사용 예제도 바꿨다.
object manage {
  def apply[R <: { def close():Unit }, T](resource: => R)(f: R => T): T = {
    var res: Option[R] = None
    try {
      res = Some(resource)         // '자원'에 대한 유일한 참조
      f(res.get)                   // T 타입의 인스턴스 반환
    } catch {
      case NonFatal(ex) =>
        println(s"manage.apply(): Non fatal exception! $ex")
        throw ex
    } finally {
      if (res != None) {
        println(s"Closing resource...")
        res.get.close
      }
    }
  }
}

object TryCatchARM {
  /** 사용법: scala rounding.TryCatch 파일이름1 파일이름2 ... */
  def main(args: Array[String]) = {
    val sizes = args map (arg => returnFileLength(arg))
    println("Returned sizes: " + (sizes.mkString(", ")))
  }

  import scala.io.Source

  def returnFileLength(fileName: String): Int = {
    println()  // 가독성을 위해 빈 줄을 넣는다.
    manage(Source.fromFile(fileName)) { source =>
      val size = source.getLines.size
      println(s"file $fileName has $size lines")
      if (size > 30) throw new RuntimeException(s"Big file: $fileName!")
      size
    }
  }
}
