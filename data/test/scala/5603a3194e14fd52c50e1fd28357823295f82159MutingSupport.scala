package dbis.piglet.plan.rewriting.internals

import dbis.piglet.tools.logging.PigletLogging
import dbis.piglet.plan.DataflowPlan
import dbis.piglet.op.Store
import dbis.piglet.op.Dump
import dbis.piglet.plan.rewriting.Rewriter
import org.kiama.rewriting.Rewriter._
import org.kiama.rewriting.Strategy

trait MutingSupport extends PigletLogging {
  
  def mute(plan: DataflowPlan): DataflowPlan = {
    
    val strategy = (op: Any) => op match {
      case s: Store => 
        val dump = Dump(s.inputs.head, mute = true)
        Rewriter.replace(plan, s, dump)
        logger.debug(s"replaced $s with $dump")
        Some(dump)
      case d: Dump if !d.mute => 
        logger.debug(s"muting $d")
        d.mute = true
        Some(d)
        
      case _ => None 
    }
    
    
    Rewriter.rewritePlan(plan, manybu(strategyf(t => strategy(t))))
//    var newPlan = plan
//    
//    val sinks = newPlan.sinkNodes
//    
//    sinks.foreach { sink => sink match {
//      case s: Store =>
//        val dump = Dump(s.inputs.head, quietMode = true)
//        newPlan = newPlan.replace(s, dump)
//      case d: Dump if !d.quietMode =>
//        d.quietMode = true
//      case _ => // ignore other consumers (such as display, empty)
//        
//      } 
//    }
//    
//    newPlan  
//    
  }
}