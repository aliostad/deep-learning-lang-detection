package com.godatadriven.kafka.offset

import com.google.gson.{Gson, GsonBuilder}
import org.apache.kafka.common.protocol.SecurityProtocol
import org.specs2.mutable.Specification

class BrokerInfoTest extends Specification {
  val gson: Gson = new GsonBuilder().create()

  "Brokerinfo host should" >> {
    "return host if host is filled" >> {
      val brokerInfo = gson.fromJson("{\"jmx_port\":-1,\"timestamp\":\"1459185255551\",\"host\":\"ron\",\"version\":1,\"port\":9092}", classOf[BrokerInfo])
      brokerInfo.getHost must equalTo("ron")
    }
    "return host if endpoint is filled" >> {
      val brokerInfo = gson.fromJson("{\"jmx_port\":-1,\"timestamp\":\"1459185255551\",\"endpoints\": [\"PLAINTEXTSASL://ron:9092\"],\"host\":\"\",\"version\":1,\"port\":-1}", classOf[BrokerInfo])
      brokerInfo.getHost must equalTo("ron")
    }
    "return host if endpoint is filled and host is null" >> {
      val brokerInfo = gson.fromJson("{\"jmx_port\":-1,\"timestamp\":\"1459185255551\",\"endpoints\": [\"PLAINTEXTSASL://ron:9092\"],\"host\": null,\"version\":1,\"port\":-1}", classOf[BrokerInfo])
      brokerInfo.getHost must equalTo("ron")
    }
  }

  "Brokerinfo port should" >> {
    "return port if port is filled" >> {
      val brokerInfo = gson.fromJson("{\"jmx_port\":-1,\"timestamp\":\"1459185255551\",\"host\":\"ron\",\"version\":1,\"port\":9092}", classOf[BrokerInfo])
      brokerInfo.getPort must equalTo(9092)
    }
    "return port if endpoinst is filled" >> {
      val brokerInfo = gson.fromJson("{\"jmx_port\":-1,\"timestamp\":\"1459185255551\",\"endpoints\": [\"PLAINTEXTSASL://ron:9092\"],\"host\":\"\",\"version\":1,\"port\":-1}", classOf[BrokerInfo])
      brokerInfo.getPort must equalTo(9092)
    }
  }

}
