package hr.element.onebyseven.common
import java.io.Writer
import java.io.OutputStreamWriter
import java.io.PrintWriter
import java.io.ByteArrayOutputStream

class TextFormater(separation: Array[Int]){//}, w: Writer) {
  val ba = new ByteArrayOutputStream
  val w = new OutputStreamWriter(ba)
  val count = Country.values
  count.foreach{
      x =>
        val form = ( i: Int, s: String) => //"%" + separation(i) + "s"
          {
            (for(i <- 0 to separation(i)) yield
            {
              if (s.length <= i) " "
              else s(i)
            }).mkString
          }
        w.write(form(0, x.alpha3))
        w.write(form(1, x.alpha2))
        w.write(form(2, x.numeric3))
        w.write(form(3, x.wikiName))
        w.write("\n")

//        w.write(form(0).format(x.alpha3))
//        w.write(form(1).format(x.alpha2))
//        w.write(form(2).format(x.numeric3))
//        w.write(form(3).format(x.wikiName))
//        w.write("\n")
  }
  w.flush()
  val toByteArray = ba.toByteArray()
  w.close()
}
