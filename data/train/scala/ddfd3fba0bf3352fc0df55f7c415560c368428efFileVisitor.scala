package fr.ign.rjmcmc4s.samples.coal.visitor

import java.io.File
import java.io.PrintWriter
import fr.ign.rjmcmc4s.configuration.Configuration
import fr.ign.rjmcmc4s.rjmcmc.sampler.Sampler
import fr.ign.rjmcmc4s.rjmcmc.visitor.Visitor
import fr.ign.rjmcmc4s.samples.coal.configuration.CoalConfiguration

class FileVisitor(fileName: String) extends Visitor {
  var dump: Int = 1
  var writer: PrintWriter = null
  var accepted: Array[Int] = null
  var proposed: Array[Int] = null
  var clock_begin: Long = 0
  var clock: Long = 0
  var iter: Int = 0
  val separator = ";"
  def init(dump: Int, save: Int) = {
    this.dump = dump
    this.writer = new PrintWriter(new File(fileName))
  }
  def format(value: Any) = value match {
    case text: String => f"$text%15s"
    case doubleVal: Double => f"$doubleVal%15.5f"
    case intVal: Int => f"$intVal%15d"
  }

  def begin(config: Configuration, sampler: Sampler) = {
    val kernel_size = sampler.kernels.size
    proposed = new Array[Int](kernel_size)
    accepted = new Array[Int](kernel_size)
    for (i <- 0 until kernel_size) {
      proposed(i) = 0
      accepted(i) = 0
    }
    writer.write(format("Iteration"))
    writer.write(separator)
    writer.write(format("Size"))
    writer.write(separator)
    for (i <- 0 until kernel_size) {
      writer.write(format("P" + sampler.kernels.apply(i).name))
      writer.write(separator)
      writer.write(format("A" + sampler.kernels.apply(i).name))
      writer.write(separator)
    }
    writer.write(format("Accept"))
    writer.write(separator)
    writer.write(format("Time"))
    writer.write(separator)
    writer.write(format("LogLikelihood"))
    writer.write(separator)
    writer.write(format("Accept_Prob"))
    writer.write(separator)
    writer.write(format("Delta"))
    writer.write(separator)
    writer.write(format("Green_Ratio"))
    writer.write(separator)
    writer.write(format("Accepted"))
    writer.write(separator)
    writer.write(format("Kernel_Ratio"))
    writer.write(separator)
    writer.write(format("Ref_Pdf_Ratio"))
    writer.write("\n")
    writer.flush
    clock = System.currentTimeMillis
    clock_begin = clock
  }
  def visit(config: Configuration, sampler: Sampler) = config match {
    case configuration: CoalConfiguration =>
      val kernel_size = sampler.kernels.size
      proposed(sampler.kernel_id) += 1
      if (sampler.accepted) accepted(sampler.kernel_id) += 1
      iter += 1
      if (iter % dump == 0) {
        writer.write(format(iter))
        writer.write(separator)
        writer.write(format(configuration.K))
        writer.write(separator)
        var acceptedCount = 0
        for (i <- 0 until kernel_size) {
          writer.write(format(100.0 * proposed(i) / dump))
          writer.write(separator)
          val accept = if (proposed(i) > 0) 100.0 * accepted(i) / proposed(i) else 0.0
          writer.write(format(accept))
          writer.write(separator)
          acceptedCount += accepted(i)
          proposed(i) = 0
          accepted(i) = 0
        }
        writer.write(format(100.0 * acceptedCount / dump))
        writer.write(separator)
        val clock_temp = System.currentTimeMillis
        writer.write(format((clock_temp - clock).toDouble / dump))
        writer.write(separator)
        clock = clock_temp
        writer.write(format(configuration.getEnergy))
        writer.write(separator)
        writer.write(format(sampler.acceptance_probability))
        writer.write(separator)
        writer.write(format(sampler.delta))
        writer.write(separator)
        writer.write(format(sampler.green_ratio))
        writer.write(separator)
        writer.write(format(if (sampler.accepted) 1 else 0))
        writer.write(separator)
        writer.write(format(sampler.kernel_ratio))
        writer.write(separator)
        writer.write(format(sampler.ref_pdf_ratio))
        writer.write("\n")
        writer.flush
      }
  }
  def end(config: Configuration, sampler: Sampler) = {
    writer.close
    val clock_end = System.currentTimeMillis
    println("Total elapsed time : " + (clock_end - clock_begin) / 1000 + " s")
  }
}