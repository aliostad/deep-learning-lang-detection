package org.aertslab.grnboost.algo

import java.io.File

import org.scalatest.{FlatSpec, Matchers}
import org.aertslab.grnboost.XGBoostRegressionParams
import org.aertslab.grnboost.algo.InferRegulations._

import scala.io.Source

/**
  * @author Thomas Moerman
  */
class InferRegulationsSpec extends FlatSpec with Matchers {

  behavior of "parsing metrics"

  val treeDumpWithStats = Source.fromFile(new File("src/test/resources/xgb/treeDumpWithStats.txt")).getLines.mkString("\n")

  it should "parse tree metrics" in {
    val scoresMap = parseImportanceScores(treeDumpWithStats)

    scoresMap.size shouldBe 28

    val (featureIdx, score) = scoresMap(0)

    featureIdx shouldBe 223
    score.gain shouldBe 1012.38f
  }

  behavior of "aggregating booster metrics"

  it should "aggregate correctly for 1 tree" in {
    val scores = aggregateImportanceScoresByGene(null)(Seq(treeDumpWithStats))

    scores(223).gain shouldBe 1012.38f + 53.1558f
  }

  it should "aggregate correctly for multiple trees" in {
    val gains = aggregateImportanceScoresByGene(null)(Seq(treeDumpWithStats, treeDumpWithStats))

    gains(223).gain shouldBe 2 * (1012.38f + 53.1558f)
  }

}