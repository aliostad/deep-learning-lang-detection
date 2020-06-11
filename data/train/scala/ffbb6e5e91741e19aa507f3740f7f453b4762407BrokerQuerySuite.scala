package com.kainos.enstar.transformation.ndex

import com.kainos.enstar.transformation._
import com.kainos.enstar.transformation.sourcetype.Ndex

/**
 * Created by neilri on 11/01/2017.
 */
class BrokerQuerySuite extends QuerySuite {

  val sourceType = Ndex

  override def testTags = List( tags.Broker )

  override def queryTestSets : List[QueryTestSet] = List(
    QueryTestSet(
      "Broker",
      "broker",
      "Broker.hql",
      Set(
        QueryTest(
          "Primary",
          Set(
            CsvSourceData( "broking_company", "PrimaryTestData.csv" )
          ),
          CsvSourceData( "broker", "PrimaryTestData.csv" )
        )
      ),
      Set(
        ReconciliationTest(
          "Primary",
          Set(
            CsvSourceData( "broking_company", "PrimaryTestData.csv" )
          ),
          "broker",
          "Broker/RecordCount.hql",
          "Broker/RecordCount.hql"
        )
      )
    )
  )
}
