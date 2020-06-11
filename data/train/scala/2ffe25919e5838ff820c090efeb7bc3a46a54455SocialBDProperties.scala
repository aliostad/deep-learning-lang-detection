package ucm.socialbd.com.config

import com.typesafe.config.ConfigFactory
/**
  * Created by Jeff on 16/04/2017.
  */

case class TwitterConf(twitterTopicIn: String, twitterTopicOut:String,elasticIndex:String,elasticType:String, outputDir:String)

case class TrafficConf(urbanTrafficTopicIn:String, interUrbanTrafficTopicIn:String, trafficTopicOut: String,elasticIndex:String,elasticType:String, outputDir:String)

case class QualityAirConf(qualityAirTopicIn:String, qualityAirTopicOut:String,elasticIndex:String,elasticType:String, outputDir:String)

case class BiciMADConf(bicimadTopicIn:String, bicimadTopicOut:String,elasticIndex:String,elasticType:String, outputDir:String)

case class EMTBusConf(emtbusTopicIn:String, emtbusTopicOut:String,elasticIndex:String,elasticType:String, outputDir:String)

@SerialVersionUID(100L)
class SocialBDProperties extends Serializable{
  //checks about if exist components in application.conf
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "twitter")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "traffic")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "qualityAir")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "bicimad")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "emtbus")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "kafkaBrokersUrls")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "zkUrl")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "elasticClusterName")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "elasticNodeName")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "elasticPort")
  ConfigFactory.load().checkValid(ConfigFactory.defaultReference(), "elasticUrl")

  val twitterConf = TwitterConf(ConfigFactory.load().getString("twitter.twitterTopicIn"),
                    ConfigFactory.load().getString("twitter.twitterTopicOut"),
                    ConfigFactory.load().getString("twitter.elasticIndex"),
                    ConfigFactory.load().getString("twitter.elasticType"),
                    ConfigFactory.load().getString("twitter.outputDir"))

 val trafficConf = TrafficConf(ConfigFactory.load().getString("traffic.urbanTrafficTopicIn"),
                   ConfigFactory.load().getString("traffic.interUrbanTrafficTopicIn"),
                   ConfigFactory.load().getString("traffic.trafficTopicOut"),
                   ConfigFactory.load().getString("traffic.elasticIndex"),
                   ConfigFactory.load().getString("traffic.elasticType"),
                   ConfigFactory.load().getString("traffic.outputDir"))

  val qualityAirConf = QualityAirConf(ConfigFactory.load().getString("qualityAir.qualityAirTopicIn"),
                  ConfigFactory.load().getString("qualityAir.qualityAirTopicOut"),
                  ConfigFactory.load().getString("qualityAir.elasticIndex"),
                  ConfigFactory.load().getString("qualityAir.elasticType"),
                  ConfigFactory.load().getString("qualityAir.outputDir"))

  val biciMADConf = BiciMADConf(ConfigFactory.load().getString("bicimad.bicimadTopicIn"),
                  ConfigFactory.load().getString("bicimad.bicimadTopicOut"),
                  ConfigFactory.load().getString("bicimad.elasticIndex"),
                  ConfigFactory.load().getString("bicimad.elasticType"),
                  ConfigFactory.load().getString("bicimad.outputDir"))

  val eMTBusConf = EMTBusConf(ConfigFactory.load().getString("emtbus.emtbusTopicIn"),
                  ConfigFactory.load().getString("emtbus.emtbusTopicOut"),
                  ConfigFactory.load().getString("emtbus.elasticIndex"),
                  ConfigFactory.load().getString("emtbus.elasticType"),
                  ConfigFactory.load().getString("emtbus.outputDir"))

  val kafkaBrokersUrls =  ConfigFactory.load().getString("kafkaBrokersUrls")
  val zkUrl =  ConfigFactory.load().getString("zkUrl")
  val elasticClusterName =  ConfigFactory.load().getString("elasticClusterName")
  val elasticNodeName =  ConfigFactory.load().getString("elasticNodeName")
  val elasticPort =  ConfigFactory.load().getInt("elasticPort")
  val elasticUrl =  ConfigFactory.load().getString("elasticUrl")
  val outputMode =  ConfigFactory.load().getString("outputMode")
}
