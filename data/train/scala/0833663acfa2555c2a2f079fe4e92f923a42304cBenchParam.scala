package de.jasminelli.souffleuse.bench

/**
 * Parameters to a run of a RpcBench instance
 *
 * @author Stefan Plantikow<Stefan.Plantikow@googlemail.com>
 *
 * Originally created by User: stepn Date: 13.02.2009 Time: 15:30:08
 */
final case class BenchParams(val load: RqLoad,
                             val workDur: Long,
                             val numStages: Int,
                             val warmUp: Int, val times: Int, val deferredSending: Boolean);

abstract sealed class RqLoad(val numRequests: Int) {
  val requiredRequests = numRequests
  val numObligations = numRequests
}

final case class LinRqLoad(requests: Int) extends RqLoad(requests) ;

final case class BulkRqLoad(requests: Int) extends RqLoad(requests) ;

final case class ParRqLoad(requests: Int, val numPartitions: Int) extends RqLoad(requests) {
  assert(((numRequests/numPartitions) * numPartitions) == numRequests)
}

final case class NBParRqLoad(requests: Int, val numPartitions: Int) extends RqLoad(requests) {
  assert(numPartitions > 0)

  override val numObligations = numPartitions +
    (if ((numRequests % numPartitions) == 0) 0 else 1)
}