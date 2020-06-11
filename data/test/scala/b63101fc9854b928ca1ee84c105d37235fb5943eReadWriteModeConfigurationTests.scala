package almhirt.reactivemongox

import scala.concurrent.duration._
import almhirt.common._
import almhirt.almvalidation.kit._
import almhirt.configuration._
import com.typesafe.config.ConfigFactory
import org.scalatest._

class ReadWriteModeConfigurationTests extends FunSuite with Matchers {
  test("Configure ReadWriteMode.ReadAndWrite(primary-only, journaled) via SupportsReading") {
    val cfgStr =
      """|read-write-mode {
         |  write-concern {
         |     mode = journaled
         |  }
         |  read-preference {
         |    mode = primary-only
         |  }
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[ReadWriteMode.SupportsReading]("read-write-mode").resultOrEscalate
    res should equal(ReadWriteMode.ReadAndWrite(ReadPreferenceAlm.PrimaryOnly, WriteConcernAlm.Journaled(fsync = false)))
  }

  test("Configure ReadWriteMode.ReadAndWrite(primary-only, journaled) via SupportsWriting") {
    val cfgStr =
      """|read-write-mode {
         |  write-concern {
         |     mode = journaled
         |  }
         |  read-preference {
         |    mode = primary-only
         |  }
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[ReadWriteMode.SupportsWriting]("read-write-mode").resultOrEscalate
    res should equal(ReadWriteMode.ReadAndWrite(ReadPreferenceAlm.PrimaryOnly, WriteConcernAlm.Journaled(fsync = false)))
  }

  test("Configure ReadWriteMode.ReadAndWrite(primary-only, journaled) via ReadWriteMode") {
    val cfgStr =
      """|read-write-mode {
         |  write-concern {
         |     mode = journaled
         |  }
         |  read-preference {
         |    mode = primary-only
         |  }
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[ReadWriteMode]("read-write-mode").resultOrEscalate
    res should equal(ReadWriteMode.ReadAndWrite(ReadPreferenceAlm.PrimaryOnly, WriteConcernAlm.Journaled(fsync = false)))
  }

  test("Configure ReadWriteMode.ReadOnly(primary-only)") {
    val cfgStr =
      """|read-write-mode {
         |  write-concern = none
         |  read-preference {
         |    mode = primary-only
         |  }
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[ReadWriteMode.SupportsReading]("read-write-mode").resultOrEscalate
    res should equal(ReadWriteMode.ReadOnly(ReadPreferenceAlm.PrimaryOnly))
  }

  test("Configure ReadWriteMode.WriteOnly(journaled)") {
    val cfgStr =
      """|read-write-mode {
         |  write-concern {
         |     mode = journaled
         |  }
         |  read-preference = none
         |}""".stripMargin
    val cfg = ConfigFactory.parseString(cfgStr)
    val res = cfg.v[ReadWriteMode.SupportsWriting]("read-write-mode").resultOrEscalate
    res should equal(ReadWriteMode.WriteOnly(WriteConcernAlm.Journaled(fsync = false)))
  }

}