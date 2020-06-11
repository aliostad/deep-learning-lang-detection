package neural.utils
import java.io._
import neural.Net

trait CalcLogger extends Net {
  var out:Writer= new OutputStreamWriter(java.lang.System.out)
  override def calc()={
    out.write("calc() invoked\n")
    out.flush()
    super.calc()
  }
  override def timestep()={
    out.write("\n##################\nInputs:\n")
    inputs foreach { i=> out.write(i+": "+i.output+"\n")}
    out.write("\nOld state:")
    neurons foreach {n=> out.write(n+": "+n.output+"\n")} 
    val ret= super.timestep
    out.write("\nNew state:")
    neurons foreach {n=> out.write(n+": "+n.output+"\n")}
    out.write("#################\n")
    out.flush()
    ret
  }
}