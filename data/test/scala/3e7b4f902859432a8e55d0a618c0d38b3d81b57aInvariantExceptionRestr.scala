package invariant.invariantEvaluator.Exceptions

import java.io.{PrintWriter, PrintStream}


class InvariantExceptionRestr(expr:String,oldValue:Double,newValue:Double) extends InvariantException{
  override def printStackTrace(){
    println("\nInvariant Restriction Exception:\n");
    println("\nTrying to : "+oldValue + "->"+newValue+"\n");
    println("Expression provided: \n"+expr)
    println("\n");
    super.printStackTrace();

  }
  override def printStackTrace(s:PrintStream){
    s.print("\nInvariant Restriction Exception:\n");
    s.print("\nTrying to : "+oldValue + "->"+newValue+"\n");
    s.print("Expression provided: \n"+expr)
    s.print("\n");
    s.print("\n");
    super.printStackTrace(s);
  }
  override def printStackTrace(s:PrintWriter){
    s.print("\nInvariant Restriction Exception:\n");
    s.print("\nTrying to : "+oldValue + "->"+newValue+"\n");
    s.print("Expression provided: \n"+expr)
    s.print("\n");
    s.print("\n");
    super.printStackTrace(s);
  }


}
