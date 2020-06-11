package example.philmonroe.setup.bundles

import io.dropwizard.ConfiguredBundle
import io.dropwizard.setup.{Environment, Bootstrap}
import example.philmonroe.DwExampleConfig
import example.philmonroe.core.tweet_stream.{TweetProcessor, TweetProcessingPool, TweetStream}
import example.philmonroe.healthchecks.TweetStreamHealthcheck

class TweetStreamBundle(esBundle: ElasticSearchBundle) extends ConfiguredBundle[DwExampleConfig] {
  override def initialize(bootstrap: Bootstrap[_]): Unit = {}

  override def run(config: DwExampleConfig, env: Environment): Unit = {
    val tweetStream = new TweetStream(config.twitter)
    val processors = 0 to 4 map { i =>
      new TweetProcessor(i, tweetStream.queue, env.getObjectMapper, esBundle.elasticsearch.get)
    }
    val processorPool = new TweetProcessingPool(processors)

    env.lifecycle().manage(processorPool)
    processors.foreach(env.lifecycle().manage)
    env.lifecycle().manage(tweetStream)

    env.healthChecks().register("tweet-stream", new TweetStreamHealthcheck(tweetStream))
  }
}
