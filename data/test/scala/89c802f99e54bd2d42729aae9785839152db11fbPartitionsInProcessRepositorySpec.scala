package mysqlcommon.repositories

import mysqlcommon.models.PartitionsInProcess
import mysqlcommon.traits.RepositoryConfiguration
import org.scalatest.FunSpec

import scala.concurrent.Await
import scala.concurrent.duration.Duration

/**
  * Created by mor on 9/3/17.
  */
class PartitionsInProcessRepositorySpec extends FunSpec {

  private lazy val partitionsInProcessRepository = new PartitionsInProcessRepository(RepositoryConfiguration("development", "PartitionsInProcess").config)

  describe("collect") {
    it("should return process partitions") {
      val results = Await.result(partitionsInProcessRepository.getPartitionsForProcesses(Seq[Int](21701, 21710), Seq[String]("bundle_stormfall", "bundle_nords")), Duration.Inf)
      val partitionsInProcessList = results.map(p => PartitionsInProcess(p._1, p._2, p._3)).toList
      println(partitionsInProcessList)
    }
  }
}
