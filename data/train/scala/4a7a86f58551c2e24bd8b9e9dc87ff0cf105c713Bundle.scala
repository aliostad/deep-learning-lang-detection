package uvm

import uvm.types._
import uvm.ssavalues._

class Bundle {
  val typeNs = new SimpleNamespace[Type]()
  val funcSigNs = new SimpleNamespace[FuncSig]()
  val declConstNs = new SimpleNamespace[DeclaredConstant]()
  val globalDataNs = new SimpleNamespace[GlobalData]()
  val funcNs = new SimpleNamespace[Function]()
  val globalValueNs = new SimpleNamespace[GlobalValue]()

  private def simpleMerge[T <: Identified](oldNs: Namespace[T], newNs: Namespace[T]) {
    for (cand <- newNs.all) {
      try {
        oldNs.add(cand)
      } catch {
        case e: NameConflictException =>
          throw new IllegalRedefinitionException(
            "Redefinition of type, function signature, declared constant," +
              " global data or global value is not allowed", e);
      }
    }
  }
  
  private def mergeFunc(oldNs: Namespace[Function], newNs: Namespace[Function]) {
    for (cand <- newNs.all) {
      val id = cand.id
      oldNs.get(id) match {
        case None => oldNs.add(cand)
        case Some(oldObj) => oldObj.cfg = cand.cfg
      }
    }
  }
  def merge(newBundle: Bundle) {
    simpleMerge(typeNs, newBundle.typeNs)
    simpleMerge(funcSigNs, newBundle.funcSigNs)
    simpleMerge(declConstNs, newBundle.declConstNs)
    simpleMerge(globalDataNs, newBundle.globalDataNs)
    simpleMerge(globalValueNs, newBundle.globalValueNs)
    mergeFunc(funcNs, newBundle.funcNs)
  }
}
