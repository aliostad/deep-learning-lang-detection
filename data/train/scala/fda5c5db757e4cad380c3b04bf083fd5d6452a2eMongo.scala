import sbt._
import Keys._

/**
 * NOTICE: This was copied-and-pasted from useless.io.
 */

object Mongo extends AutoPlugin {

  object autoImport {

    val mongoRemoteHost = settingKey[String](
      "The host of the remote Mongo database."
    )

    val mongoRemotePort = settingKey[Int](
      "The port of the remote Mongo database."
    )

    val mongoRemoteUsername = settingKey[String](
      "The username used to access the remote Mongo database."
    )

    val mongoRemotePassword = settingKey[String](
      "The password used to access the remote Mongo database."
    )

    val mongoRemoteDatabase = settingKey[String](
      "The name of the production Mongo database to connect to."
    )

    val mongoDumpBaseDirectory = settingKey[String](
      "The directory where Mongo dumps will be stored."
    )

    val mongoDumpRemote = taskKey[File](
      "Dumps the configured remote Mongo database, returning the dump file."
    )

    val mongoLocalDatabase = settingKey[String](
      "The name of the local PostgreSQL database to be replaced."
    )

    val mongoRestoreFromRemote = taskKey[Unit](
      "Dumps the production Mongo DB and restores it."
    )

  }

  import autoImport._

  def buildUniqueString() = (System.currentTimeMillis / 1000).toString

  override def projectSettings = Seq(

    mongoRemoteHost := "DUMMY",

    mongoRemotePort := 27017,

    mongoRemoteUsername := "DUMMY",

    mongoRemotePassword := "DUMMY",

    mongoRemoteDatabase := "DUMMY",

    mongoDumpBaseDirectory := "dump/mongo",

    mongoDumpRemote := {
      val directory = mongoDumpBaseDirectory.value + "/" + mongoRemoteHost.value + "/" + mongoRemoteDatabase.value
      IO.createDirectory(file(directory))
      val dumpFile = file(directory + "/" + buildUniqueString())

      List("mongodump",
        "--host", mongoRemoteHost.value,
        "--port", mongoRemotePort.value.toString,
        "--username", mongoRemoteUsername.value,
        "--password", mongoRemotePassword.value,
        "--db", mongoRemoteDatabase.value,
        "--out", dumpFile.getPath
      ).!

      dumpFile
    },

    mongoLocalDatabase := "DUMMY",

    mongoRestoreFromRemote := {
      val dumpFile = mongoDumpRemote.value
      val localDatabase = mongoLocalDatabase.value

      List(
        "mongo",
        localDatabase,
        "--eval", "db.dropDatabase()"
      ).!

      List(
        "mongorestore",
        "--db", localDatabase,
        dumpFile.getPath + "/" + mongoRemoteDatabase.value
      ).!
    }

  )

}
