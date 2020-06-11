package almhirt.reactivemongox

import scala.concurrent.duration._
import almhirt.common._
import almhirt.almvalidation.kit._
import almhirt.configuration._
import com.typesafe.config.ConfigFactory
import org.scalatest._

class WriteConcernConfigurationTests extends FunSuite with Matchers {

  test("Configure WriteConcernAlm.Unacknowledged without configured fsync") {
    val cfgStr =
      """|write-concern {
         |   mode = unacknowledged
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.Unacknowledged(fsync = false))
  }
  
  test("Configure WriteConcernAlm.Unacknowledged with disabled fsync") {
    val cfgStr =
      """|write-concern {
         |   mode = unacknowledged
         |   fsync = false
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.Unacknowledged(fsync = false))
  }

  test("Configure WriteConcernAlm.Unacknowledged with enabled fsync") {
    val cfgStr =
      """|write-concern {
         |   mode = unacknowledged
         |   fsync = true
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.Unacknowledged(fsync = true))
  }

  test("Configure WriteConcernAlm.Acknowledged without configured fsync") {
    val cfgStr =
      """|write-concern {
         |   mode = acknowledged
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.Acknowledged(fsync = false))
  }
  
  test("Configure WriteConcernAlm.Acknowledged with disabled fsync") {
    val cfgStr =
      """|write-concern {
         |   mode = acknowledged
         |   fsync = false
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.Acknowledged(fsync = false))
  }

  test("Configure WriteConcernAlm.Acknowledged with enabled fsync") {
    val cfgStr =
      """|write-concern {
         |   mode = acknowledged
         |   fsync = true
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.Acknowledged(fsync = true))
  }
  
  test("Configure WriteConcernAlm.Journaled without configured fsync") {
    val cfgStr =
      """|write-concern {
         |   mode = journaled
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.Journaled(fsync = false))
  }
  
  test("Configure WriteConcernAlm.Journaled with disabled fsync") {
    val cfgStr =
      """|write-concern {
         |   mode = journaled
         |   fsync = false
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.Journaled(fsync = false))
  }

  test("Configure WriteConcernAlm.Journaled with enabled fsync") {
    val cfgStr =
      """|write-concern {
         |   mode = journaled
         |   fsync = true
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.Journaled(fsync = true))
  }
  
  test("Configure WriteConcernAlm.ReplicaAcknowledged without configured fsync without a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-acknowledged
         |   w = 2
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaAcknowledged(w = 2, fsync = false, wtimeout = None))
  }
  
  test("Configure WriteConcernAlm.ReplicaAcknowledged with disabled fsync without a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-acknowledged
         |   w = 2
         |   fsync = false
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaAcknowledged(w = 2, fsync = false, wtimeout = None))
  }

  test("Configure WriteConcernAlm.ReplicaAcknowledged with enabled fsync without a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-acknowledged
         |   w = 2
         |   fsync = true
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaAcknowledged(w = 2, fsync = true, wtimeout = None))
  }
  
  test("Configure WriteConcernAlm.ReplicaAcknowledged without configured fsync with a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-acknowledged
         |   w = 2
         |   timeout = 1 second
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaAcknowledged(w = 2, fsync = false, wtimeout = Some(1.second)))
  }
  
  test("Configure WriteConcernAlm.ReplicaAcknowledged with disabled fsync with a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-acknowledged
         |   w = 2
         |   fsync = false
         |   timeout = 1 second
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaAcknowledged(w = 2, fsync = false, wtimeout = Some(1.second)))
  }

  test("Configure WriteConcernAlm.ReplicaAcknowledged with enabled fsync with a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-acknowledged
         |   w = 2
         |   fsync = true
         |   timeout = 1 second
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaAcknowledged(w = 2, fsync = true, wtimeout = Some(1.second)))
  }
 
  test("Configure WriteConcernAlm.ReplicaJournaled without configured fsync without a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-journaled
         |   w = 2
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaJournaled(w = 2, fsync = false, wtimeout = None))
  }
  
  test("Configure WriteConcernAlm.ReplicaJournaled with disabled fsync without a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-journaled
         |   w = 2
         |   fsync = false
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaJournaled(w = 2, fsync = false, wtimeout = None))
  }

  test("Configure WriteConcernAlm.ReplicaJournaled with enabled fsync without a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-journaled
         |   w = 2
         |   fsync = true
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaJournaled(w = 2, fsync = true, wtimeout = None))
  }
  
  test("Configure WriteConcernAlm.ReplicaJournaled without configured fsync with a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-journaled
         |   w = 2
         |   timeout = 1 second
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaJournaled(w = 2, fsync = false, wtimeout = Some(1.second)))
  }
  
  test("Configure WriteConcernAlm.ReplicaJournaled with disabled fsync with a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-journaled
         |   w = 2
         |   fsync = false
         |   timeout = 1 second
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaJournaled(w = 2, fsync = false, wtimeout = Some(1.second)))
  }

  test("Configure WriteConcernAlm.ReplicaJournaled with enabled fsync with a timeout") {
    val cfgStr =
      """|write-concern {
         |   mode = replica-journaled
         |   w = 2
         |   fsync = true
         |   timeout = 1 second
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[WriteConcernAlm]("write-concern").resultOrEscalate
    res should equal(WriteConcernAlm.ReplicaJournaled(w = 2, fsync = true, wtimeout = Some(1.second)))
  }
  
}