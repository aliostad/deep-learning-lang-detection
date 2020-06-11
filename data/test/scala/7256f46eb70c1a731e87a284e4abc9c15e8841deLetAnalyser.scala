package uk.ac.cam.bsc28.diss.Analysis

import uk.ac.cam.bsc28.diss.Analysis.StaticAnalyser.AnalysisError
import uk.ac.cam.bsc28.diss.FrontEnd.ParseTree
import uk.ac.cam.bsc28.diss.FrontEnd.ParseTree._

object LetAnalyser {

  def analyse(prog: ParseTree.Node): Option[AnalysisError] = {
    None
    /*prog match {
      case ProcessStart(proc) =>
        validateProcess(proc)

      case _ => Some("Invalid program structure.")
    }*/
  }

  def validateProcess(p: ParseTree.Process): Option[AnalysisError] = {
    p match {
      case ParallelProcess(left, right, more) =>
        val maybeLeft = validateProcess(left)
        val maybeRight = validateProcess(right)
        val maybeAux = validateProcessAux(more)
        (maybeLeft, maybeRight, maybeAux) match {
          case (Some(e), _, _) => Some(e)
          case (_, Some(e), _) => Some(e)
          case (_, _, Some(e)) => Some(e)
          case _ => None
        }

      case ReplicateProcess(proc) =>
        val maybeProc = validateProcess(proc)
        maybeProc match {
          case Some(e) => Some(e)
          case _ => None
        }

      case IfProcess(left, right, proc, more) =>
        val maybeProc = validateProcess(proc)
        val maybeAux = validateProcessAux(more)
        (maybeProc, maybeAux) match {
          case (Some(e), _) => Some(e)
          case (_, Some(e)) => Some(e)
          case _ => None
        }

      case LetProcess(name, value, proc, more) =>
        val usedNames = processInNames(proc)
        if (usedNames contains name) {
          Some(s"Error: cannot re-bind variable ${name.name}")
        } else {
          val maybeProc = validateProcess(proc)
          val maybeAux = validateProcessAux(more)
          (maybeProc, maybeAux) match {
            case (Some(e), _) => Some(e)
            case (_, Some(e)) => Some(e)
            case _ => None
          }
        }

      case FreshProcess(name, proc, more) =>
        val usedNames = processInNames(proc)
        if (usedNames contains name) {
          Some(s"Error: cannot re-bind variable ${name.name}")
        } else {
          val maybeProc = validateProcess(proc)
          val maybeAux = validateProcessAux(more)
          (maybeProc, maybeAux) match {
            case (Some(e), _) => Some(e)
            case (_, Some(e)) => Some(e)
            case _ => None
          }
        }

      case _ => None
    }
  }

  def validateProcessAux(aux: ParseTree.ProcessAux): Option[AnalysisError] = {
    aux match {
      case SequentialProcessAux(proc, more) =>
        val maybeProc = validateProcess(proc)
        val maybeAux = validateProcessAux(more)
        (maybeProc, maybeAux) match {
          case (Some(e), _) => Some(e)
          case (_, Some(e)) => Some(e)
          case _ => None
        }

      case EmptyProcessAux() => None
    }
  }

  def processInNames(p: ParseTree.Process): Set[VariableName] = {
    p match {
      case OutProcess(chan, expr, more) =>
        processAuxInNames(more)

      case InProcess(chan, varName, more) =>
        processAuxInNames(more) + varName

      case ParallelProcess(left, right, more) =>
        processInNames(left) | processInNames(right) | processAuxInNames(more)

      case ReplicateProcess(proc) =>
        processInNames(proc)

      case IfProcess(left, right, proc, more) =>
        processInNames(proc) | processAuxInNames(more)

      case LetProcess(name, value, proc, more) =>
        processInNames(proc) | processAuxInNames(more) + name

      case EndProcess() =>
        Set()

      case FreshProcess(name, proc, more) =>
        processInNames(proc) | processAuxInNames(more) + name
    }
  }

  def processAuxInNames(aux: ParseTree.ProcessAux): Set[VariableName] = {
    aux match {
      case SequentialProcessAux(proc, more) =>
        processInNames(proc) | processAuxInNames(more)

      case EmptyProcessAux() => Set()
    }
  }

}
