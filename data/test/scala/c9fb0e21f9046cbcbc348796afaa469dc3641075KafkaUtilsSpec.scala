package org.dsa.iot.kafka

import org.scalatest.{ Finders, Matchers, Suite, WordSpecLike }

import kafka.cluster.Broker

class KafkaUtilsSpec extends Suite with WordSpecLike with Matchers {
  import Settings._

  "KafkaUtils.parseBrokerList" should {
    "return an empty list for blank string" in {
      KafkaUtils.parseBrokerList(" ") shouldBe Nil
      KafkaUtils.parseBrokerList(" , ") shouldBe Nil
    }
    "parse hosts with ports" in {
      KafkaUtils.parseBrokerList("host1:111, host2:222,host3:333") shouldBe
        Broker(0, "host1", 111) :: Broker(1, "host2", 222) :: Broker(2, "host3", 333) :: Nil
    }
    "parse hosts without ports" in {
      KafkaUtils.parseBrokerList("host1,host2, host3") shouldBe
        Broker(0, "host1", DEFAULT_PORT) :: Broker(1, "host2", DEFAULT_PORT) :: Broker(2, "host3", DEFAULT_PORT) :: Nil
    }
    "parse mixed hosts with/without ports" in {
      KafkaUtils.parseBrokerList("host1:111,host2, host3:333") shouldBe
        Broker(0, "host1", 111) :: Broker(1, "host2", DEFAULT_PORT) :: Broker(2, "host3", 333) :: Nil
    }
    "fail on bad port format" in {
      a[NumberFormatException] should be thrownBy KafkaUtils.parseBrokerList("host:port")
    }
  }

}