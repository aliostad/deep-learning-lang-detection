package com.ojha.timestamps

import com.ojha.timestamps.datamodel._

/**
 * Created by alexandra on 08/03/15.
 */
class VectorClockEvaluator {


  /**
   * @param ps
   * @return Map (message_id -> (Process, index of corresponding send event in process)
   */
  def generatedSenderLookup(ps: Seq[CatProcess]): Map[Int, (CatProcess, Int)] = {

    val eventIndexInProcess = ps.flatMap(p => p.events.zipWithIndex.map(x => (x._1, x._2, p)))

    eventIndexInProcess.flatMap {
      case (Send(x), i, p) => List(x -> (p, i))
      case _ => Nil
    }.toMap
  }

  def clockify(procs: Seq[CatProcess]): Seq[ResolvedCatProcess]  = {

    val senderLookup: Map[Int, (CatProcess, Int)] = generatedSenderLookup(procs)
    procs.map(p => new ResolvedCatProcess(p.id, evaluateTimestampsForProcess(procs.length, p, senderLookup)))
  }

  def evaluateTimestampsForProcess(totalProcesses: Int, process: CatProcess, senderLookup: Map[Int, (CatProcess, Int)] ): Seq[(Event, CatTimestamp)] = {
    process.events.reverse.zipWithIndex.map {
      case (e, i) => calculateEventTimestamp(totalProcesses, process, process.events.length - 1 - i, senderLookup)
    }.reverse
  }

  def calculateEventTimestamp(totalProcesses: Int, process: CatProcess, index: Int, senderLookup: Map[Int, (CatProcess, Int)]): (Event, CatVectorClock) = {

    val event = process.events(index)

    if (index == 0) return basecase(totalProcesses, event, process, senderLookup)

    event match {
      case LocalEvent => {

        val prevClock = calculateEventTimestamp(totalProcesses, process, index-1, senderLookup)._2
        prevClock.vector(process.id) = prevClock.vector(process.id) + 1

        (event, prevClock)
      }
      case Send(x) => {
        val prevClock = calculateEventTimestamp(totalProcesses, process, index-1, senderLookup)._2
        prevClock.vector(process.id) = prevClock.vector(process.id) + 1

        (event, prevClock)
      }

      case Receive(x) => {
        val senderInfo: (CatProcess, Int) = senderLookup(x)
        val timestampInMsg: Array[Int] = calculateEventTimestamp(totalProcesses, senderInfo._1, senderInfo._2, senderLookup)._2.vector

        val prevClock: Array[Int] = calculateEventTimestamp(totalProcesses, process, index-1, senderLookup)._2.vector
        val newClock: Array[Int] = prevClock.zip(timestampInMsg).map { case (x,y) => math.max(x,y)}
        newClock(process.id) = newClock(process.id) + 1
        (event, new CatVectorClock(newClock))

      }
    }
  }

  def basecase(totalProcs: Int, event: Event, process: CatProcess, senderLookup: Map[Int, (CatProcess, Int)]): (Event, CatVectorClock) = {

    event match {
      case LocalEvent => (event, newClock(totalProcs, process.id ))
      case Send(x) => (event, newClock(totalProcs, process.id))
      case Receive(x) => {
        val senderInfo: (CatProcess, Int) = senderLookup(x)
        val timestampInMsg = calculateEventTimestamp(totalProcs, senderInfo._1, senderInfo._2, senderLookup)._2.vector
        timestampInMsg(process.id) = 1
        (event, new CatVectorClock(timestampInMsg))
      }
    }
  }

  def newClock(totalProcs: Int, currentProcId: Int): CatVectorClock = {
    val vector = new Array[Int](totalProcs)
    vector(currentProcId) = 1
    new CatVectorClock(vector)
  }




}



