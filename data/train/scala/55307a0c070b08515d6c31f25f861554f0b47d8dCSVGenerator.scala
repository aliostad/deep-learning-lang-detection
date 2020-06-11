package pl.mtpl.spark

import java.io.{BufferedWriter, FileWriter}

import scala.io.Source

/**
  * Created by MarcinT.P on 2017-02-25.
  */
class CSVGenerator {
  def generate(fileName: String, cnt: Int) : Unit = {
    val out : BufferedWriter = new BufferedWriter(new FileWriter(fileName))
    out.write(s"No;Name;Surname;Is_Male;Age\n")
    for (i <- 0 until cnt) {
      out.write(s"$i;Name$i;Surname$i;")
      out.write((i % 2 == 1).toString)
      out.write(";")
      out.write((i % 60).toString)
      out.write("\n")
    }
    out.flush()
    out.close()
  }
}
