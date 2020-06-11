package tsp_bb

import common.MatrixOld
import hungarian_method.HungarianSolver
import scala.collection.immutable.Queue

case class TraceData(iterationNum: Int,
                     destMat: MatrixOld[Int],
                     costMat: MatrixOld[Double],
                     f0: Double,
                     fs: Double)

class TspSolverWithBnb(val traceCallback: (TraceData) => Unit = (_: TraceData) => {}) {
  def solve(costs: MatrixOld[Double]) = {
    val initialDestinations = buildInitialDestMatrix(costs.rowCount)
    val taskQueue = Queue(costs)
    val (_, optVal, destMat) =
      completeTask(
        taskQueue,
        optimalValue(initialDestinations, costs),
        initialDestinations, 1
      )

    (optVal, destMat)
  }

  private def optimalValue(destMat: MatrixOld[Int], costMat: MatrixOld[Double]) =
    costMat
      .flat().zip(destMat.flat())
      .filter { case (c, x) => !c.isInfinity }
      .map { case (c, x) => c * x }
      .sum

  private def buildInitialDestMatrix(n: Int) =
    destMatrixFromFullCycle(
      for (i <- 0 until n) yield if (i != n - 1) i + 1 else 0)

  private def destMatrixFromFullCycle(seq: IndexedSeq[Int]) =
    new MatrixOld[Int](
      rowCount = seq.size,
      colCount = seq.size,
      initializer = (ri, ci) => if (seq(ri) == ci) 1 else 0
    )

  private def completeTask(queue: Queue[MatrixOld[Double]], optVal: Double, destMat: MatrixOld[Int], iterNum: Int)
  : (Queue[MatrixOld[Double]], Double, MatrixOld[Int]) =
  {
    if (queue.isEmpty)
      (queue, optVal, destMat)
    else {
      val (costs, newQueue) = queue.dequeue
      val hungarianSolver = new HungarianSolver(costs)
      val (newDestMat, newOptVal) = hungarianSolver.solve(maximize = false)
      val cycles = findAllCycles(newDestMat)

      traceCallback(TraceData(iterNum, destMat, costs, newOptVal, optVal))

      if (newOptVal > optVal)
        completeTask(newQueue, optVal, destMat, iterNum + 1)
      else if (isFullCycle(newDestMat, cycles))
        completeTask(newQueue, newOptVal, newDestMat, iterNum + 1)
      else
        completeTask(addSubTasks(newQueue, cycles, costs), optVal, destMat, iterNum + 1)
    }
  }

  private def findAllCycles(destMat: MatrixOld[Int]) = {
    def transitionsFromMatrix(destMat: MatrixOld[Int]) =
      for (row <- 0 until destMat.rowCount) yield
        (row, destMat.rows(row).indexOf(1))

    def recurseFindCycle(transitions: List[(Int,Int)], foundCycles: List[List[(Int, Int)]])
    : (List[(Int, Int)], List[List[(Int, Int)]]) =
    {
      def recurseFindPair(transitions: List[(Int, Int)], cycle: List[(Int, Int)])
      : (List[(Int, Int)], List[(Int, Int)]) =
      {
        if (cycle.head._1 == cycle.last._2 || transitions.isEmpty)
          (transitions, cycle)
        else
          recurseFindPair(transitions, cycle ++ transitions.find((tr) => tr._1 == cycle.last._2))
      }

      if (transitions.isEmpty) {
        (transitions, foundCycles)
      }
      else {
        val (_, cycle) = recurseFindPair(transitions.tail, List(transitions.head))
        recurseFindCycle(transitions.tail.filter(p => !cycle.contains(p)), foundCycles :+ cycle)
      }
    }

    val allTransitions = transitionsFromMatrix(destMat).toList
    val (_, foundCycles) = recurseFindCycle(allTransitions, List.empty[List[(Int, Int)]])

    foundCycles
  }

  private def isFullCycle(destMat: MatrixOld[Int], cycle: List[List[(Int, Int)]]): Boolean =
    cycle.length == 1 && cycle(0).length == destMat.rowCount

  private def addSubTasks(queue: Queue[MatrixOld[Double]], cycles: List[List[(Int, Int)]], costMatrix: MatrixOld[Double]) = {
    def createSubTask(queue: Queue[MatrixOld[Double]], cycle: List[(Int,Int)], task: MatrixOld[Double])
    : (Queue[MatrixOld[Double]], List[(Int,Int)]) =
    {
      if (cycle.isEmpty)
        (queue, cycle)
      else {
        val (c1, c2) = cycle.head
        val newMatrix = task.map((v, ri, ci) => if (ri == c1 && ci == c2) inf else v)
        createSubTask(queue.enqueue(newMatrix), cycle.tail, task)
      }
    }

    val minCycle = cycles.minBy((cycle) => cycle.length)
    val (newQueue, _) = createSubTask(queue, minCycle, costMatrix)

    newQueue
  }
}
