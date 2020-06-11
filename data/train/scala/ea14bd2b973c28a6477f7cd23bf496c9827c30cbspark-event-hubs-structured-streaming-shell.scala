val eventhubParameters = Map[String, String] (
      "eventhubs.policyname" -> "RootManageSharedAccessKey",
      "eventhubs.policykey" -> "0P1Q17Wd1rdLP1OZAYn6dD2S13Bb3nF3h2XZD9hvyyU=",
      "eventhubs.namespace" -> "hdiz-docs-eventhubs",
      "eventhubs.name" -> "hub1",
      "eventhubs.partition.count" -> "2",
      "eventhubs.consumergroup" -> "$Default",
      "eventhubs.progressTrackingDir" -> "/eventhubs/progress",
      "eventhubs.sql.containsProperties" -> "true"
    )

val inputStream = spark.readStream.
  format("eventhubs").
  options(eventhubParameters).
  load()

val streamingQuery1 = inputStream.writeStream.
  outputMode("append").
  format("console").start().awaitTermination()