package data

import de.fosd.typechef.conditional.Opt

/**
 * Created by IntelliJ IDEA.
 * User: Familie
 * Date: 03.10.11
 * Time: 17:12
 * To change this template use File | Settings | File Templates.
 */

class Program(b: List[Opt[Statement]]) extends AbstractSyntaxTree {
  var stmList:List[Opt[AbstractSyntaxTree]] = b
  this.setLabel(stmList.head.entry.getLabel)

  def calculateFlowGraph(){
    var oldStm:AbstractSyntaxTree = null
    var oldDefStm:AbstractSyntaxTree = null    //zwei old Opt Knoten, da der unäre Operator abweichen kann
    var oldDefStmThen:AbstractSyntaxTree = null
    if(this.initNode==null){
      setInitNode(stmList.head.entry.getLabel)
    }
    if(this.getExit.isEmpty){
      addExitNode(stmList.last.entry.getLabel)
    }
    for(stm:Opt[AbstractSyntaxTree]<-stmList){
      stm match{
        case  de.fosd.typechef.conditional.Opt(feature,entry) =>
          feature match{
            case de.fosd.typechef.featureexpr.DefinedExpr(_) =>  {     //Optinaler Knoten
              stm.entry.calculateFlowGraph()
              if((oldDefStmThen != null)){      //Wenn es einen alten Opt Knoten gab und er den selben unären Operator hat, dann packe ihn auf den FlowGraph
                addFlow(oldDefStmThen,stm.entry.getLabel)
              }else{                                                        //Falls nicht, kann es eine Kante vom letzten nicht Opt Knoten zum Opt Knoten geben
                if(oldStm != null)
                  addFlow(oldStm, stm.entry.getLabel)
              }
              oldDefStmThen = stm.entry.getLabel
              addSubFlow(stm.entry.getFlow)
            }

            case de.fosd.typechef.featureexpr.Not(_) =>  {     //Optinaler Knoten
            stm.entry.calculateFlowGraph()
              if((oldDefStm != null)){      //Wenn es einen alten Opt Knoten gab und er den selben unären Operator hat, dann packe ihn auf den FlowGraph
                addFlow(oldDefStm,stm.entry.getLabel)
              }else{                                                        //Falls nicht, kann es eine Kante vom letzten nicht Opt Knoten zum Opt Knoten geben
                if(oldStm != null)
                  addFlow(oldStm, stm.entry.getLabel)
              }
              oldDefStm = stm.entry.getLabel
              addSubFlow(stm.entry.getFlow)
            }

            case _ => {
              stm.entry.calculateFlowGraph()
               if(oldStm!=null && oldDefStmThen == null && oldDefStm == null)
                 addFlow(oldStm,stm.entry.getLabel )
               oldStm = stm.entry.getLabel
               addSubFlow(stm.entry.getFlow)
               if(oldDefStmThen!=null){
                 addFlow(oldDefStmThen,stm.entry.getLabel)                    //Kante vom letzten Knoten des Opt-thenBranchs zum nächsten normalen Knoten
                 oldDefStmThen = null
               }
               if(oldDefStm!=null){
                 addFlow(oldDefStm, stm.entry.getLabel)
                 oldDefStm = null
               }
            }
          }

      }
    }
  }

  def generateBlocks {
    for(stm:Opt[AbstractSyntaxTree]<-stmList){
      stm.entry.generateBlocks
      addBlocksSet(stm.entry.getBlocks)
    }
  }

  override def generateAllExpressions{
    for(stm:Opt[AbstractSyntaxTree]<-stmList){
      stm.entry.generateAllExpressions
      allExpressions++=stm.entry.allExpressions
    }
  }

  override def genAE{
    for(stm:Opt[AbstractSyntaxTree]<-stmList){
      stm.entry.genAE
    }
  }

    override def killAE(caller:AbstractSyntaxTree){
    for(stm:Opt[AbstractSyntaxTree]<-stmList){
      stm.entry.killAE(caller)
    }
  }

  override def calculateAEentry(prog:Program):Set[AbstractSyntaxTree] ={

      for(stm<-blocks){
        stm.calculateAEentry(this)
      }
    return Set.empty
/*    var aeExitIntersection:Set[AbstractSyntaxTree]=null
    for((from,to)<-prog.getFlow){
      if(to.equals(this)){
        if(aeExitIntersection == null){
          aeExitIntersection=from.calculateAEexit(prog)
        }else{
          aeExitIntersection=from.calculateAEexit(prog) & aeExitIntersection
        }
      }
    }
    aeExit = aeExitIntersection
    return aeExitIntersection
*/
  }

  override def calculateAEexit(prog:Program):Set[AbstractSyntaxTree] = {
      for(stm<-blocks){
        stm.calculateAEexit(prog)
      }
    return Set.empty
//    return ((aeEntry--kill)++gen)
  }

  override def toString:String = "\n"+stmList.toString()

  override def printKillGen:String = {
    var result:String = ""
    for(stm<-blocks) {
      result+=stm.printKillGen
    }
    return result
  }

  override def printAE:String = {
    var result:String = ""
    for(stm<-blocks) {
      result+=stm.printAE
    }
    return result
  }

  override def setAllExpressions(set:Set[Expression]){
    aeEntry++=set
    aeExit++=set
    for(stm<-blocks){
      stm.setAllExpressions(set)
    }
  }

}