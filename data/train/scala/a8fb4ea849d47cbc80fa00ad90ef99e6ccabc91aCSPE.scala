/*
 *
 *  * Copyright (c) 2014-2016. National Institute of Advanced Industrial Science and Technology (AIST)
 *  * All rights reserved.
 *
 */

package jp.go.aist.cspe

object CSPE {

  private var objId = 0

  def rec0(f: Process => Process): Process = {
    objId += 1
    new Rec0(f, objId)
  }

  // Klaus's naming
  def process: (Process => Process) => Process = rec0

  def rec1[X](f: (X => Process) => (X => Process))(args: X): Process = {
    objId += 1
    new Rec1(f, args, objId)
  }

  def ?(g: Boolean): Process => Process = p => if (g) p else Failure

  def ??(f: PartialFunction[AbsEvent, Process]): Process = {
    objId += 1
    new ParamPrefix(f, objId)
  }

  def ???(f: PartialFunction[AbsEvent, Process]): Process = {
    objId += 1
    new ParamPrefixRelaxed(f, objId) /// Relaxed semantics
  }

  def choice(ps: List[Process]): Process =
    new Choice(ps)

  def parallel(ps: List[Process], as: Set[Symbol]): Process = {
     if (ps isEmpty) SKIP else {
        if (ps contains Failure) Failure else new Parallel(ps filter (! _.isTerminated), as)
    }
  }

  def ||(as : Set[Symbol], f : (AbsEvent => Process)) :Process =
    ?? {
      case e => parallel(List(choice(f(e) << e processes), choice(||(as, f) << e processes)), as)
    }


  def |||(f : (AbsEvent => Process)) :Process =
    ?? {
      case e => parallel(List(choice(f(e) << e processes), choice(|||(f) << e processes)), Set.empty)
    }


  def <+> (f : (AbsEvent => Process)) : Process =
    ?? {
      case e => choice(f(e) << e processes)
    }


  def sequence(ps: List[Process]): Process =
    if (ps.isEmpty) SKIP else new Sequence(ps)


  def interrupt(p: Process, es: Set[Symbol], q: Process): Process =
    new Interrupt(p, es, q)

  def processSet(ps : List[Process]) : ProcessSet = new ProcessSet(ps)

}