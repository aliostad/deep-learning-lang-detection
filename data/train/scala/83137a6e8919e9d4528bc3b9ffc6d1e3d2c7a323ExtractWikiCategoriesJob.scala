package com.griddynamics.analytics.darknet.job.wiki

import com.griddynamics.analytics.darknet.job.SparkJob
import com.griddynamics.analytics.darknet.utils.WikiPayloadExtractor
import com.typesafe.scalalogging.slf4j.LazyLogging
import org.apache.spark.SparkContext

/**
  * The {@link SparkJob} job implementation extracts Wiki categories from dump.
  */
object ExtractWikiCategoriesJob extends SparkJob with LazyLogging {

  /**
    * Executes the job
    * @param sc predefined Spark context
    * @param args required job arguments:
    *             #1: path to Wiki dump
    *             #2: path to result extracted categories
    *
    * @return status of job completion: '1' / '0' - success / failure
    */
  override def execute(sc: SparkContext, args: String*): Int = {
    val wikiDumpPath = args(0)
    val extractedCategoriesPath = args(1)

    val wikiDump = WikiPayloadExtractor.extractPayloadFromRawData(sc, wikiDumpPath)
    val categories = WikiPayloadExtractor.extractCategories(sc, wikiDump)

    logger.info(s"Number of categories: ${categories.count()}") //on extract - 15/12/27 15:50:05 INFO ExtractWikiCategories$: Number of categories: 21948

    categories.saveAsTextFile(extractedCategoriesPath)
    1
  }
}
