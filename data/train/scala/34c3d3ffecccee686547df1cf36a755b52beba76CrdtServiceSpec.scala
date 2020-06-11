package com.tuplejump.continuum

class CrdtServiceSpec extends AbstractCrdtSpec("crdt") {
  import com.rbmhtechnology.eventuate.crdt._

  "A CRDTService" must {
    "manage multiple CRDTs identified by name" in {
      val service = new CounterService[Int]("a", eventLog)
      service.update("a", 1).await should be(1)
      service.update("b", 2).await should be(2)
      service.value("a").await should be(1)
      service.value("b").await should be(2)
    }
    "ignore events from CRDT services of different type" in {
      val service1 = new CounterService[Int]("a", eventLog)
      val service2 = new MVRegisterService[Int]("b", eventLog)
      val service3 = new LWWRegisterService[Int]("c", eventLog)
      service1.update("a", 1).await should be(1)
      service2.set("a", 1).await should be(Set(1))
      service3.set("a", 1).await should be(Some(1))
    }
  }
}
