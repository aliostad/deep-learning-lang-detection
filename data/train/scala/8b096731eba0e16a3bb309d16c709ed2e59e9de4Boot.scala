package syndor.feedbot

import syndor.source.ReutersSource
import syndor.source.TempoSource
import syndor.model.MongoConfig
import syndor.source.TechCrunchSource
import syndor.source.DetikSource
import syndor.model.FeedItem
import syndor.model.Feed
import syndor.model.Source
import syndor.EnvironmentSupport
import syndor.EnvironmentSupport._

object Boot extends EnvironmentSupport {
  override def load(env: Environment) {
    FeedBotConfig.load(env)
    MongoConfig.load(env)
    super.load(env)
  }

  def dev() {
    cleanMongo()

    ReutersSource.load()
    DetikSource.load()
    TechCrunchSource.load()
    TempoSource.load()
  }
  
  def test() {
    cleanMongo()
  }
  
  def prod() {
    
  }
  
  def cleanMongo() {
    Source.collection.drop()
    Feed.collection.drop()
    FeedItem.collection.drop()
  }
}