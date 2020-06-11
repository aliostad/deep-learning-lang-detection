import sbt._
import Keys._

object Postgres extends AutoPlugin {

  object autoImport {

    val postgresRemoteHost = settingKey[String](
      "The host of the remote PostgreSQL database."
    )

    val postgresRemoteUsername = settingKey[String](
      "The username used to access the remote PostgeSQL database."
    )

    val postgresRemotePassword = settingKey[String](
      "The password used to access the remote PostgreSQL database."
    )

    val postgresRemoteDatabase = settingKey[String](
      "The name of the remote PostgreSQL database to connect to."
    )

    val postgresDumpBaseDirectory = settingKey[String](
      "The directory where PostgreSQL dumps will be stored."
    )

    val postgresDumpRemote = taskKey[File](
      "Dumps the configured remote PostgreSQL database, returning the dump file."
    )

    val postgresLocalUsername = settingKey[String](
      "The local username used to load the database."
    )

    val postgresLocalDatabase = settingKey[String](
      "The name of the local PostgreSQL database to be replaced."
    )

    val postgresRestoreFromRemote = taskKey[Unit](
      "Drop the local PostgreSQL database, and replace it with the remote one."
    )

  }

  import autoImport._

  def buildUniqueString() = (System.currentTimeMillis / 1000).toString

  override def projectSettings = Seq(

    postgresRemoteHost := "DUMMY",

    postgresRemoteUsername := "DUMMY",

    postgresRemotePassword := "DUMMY",

    postgresRemoteDatabase := "DUMMY",

    postgresDumpBaseDirectory := "dump/postgres",

    postgresDumpRemote := {
      val directory = postgresDumpBaseDirectory.value + "/" + postgresRemoteHost.value + "/" + postgresRemoteDatabase.value
      IO.createDirectory(file(directory))
      val dumpFile = file(directory + "/" + (buildUniqueString()) + ".sql")

      val command = Seq(
        "pg_dump",
        "--host", postgresRemoteHost.value,
        "--username", postgresRemoteUsername.value,
        "--dbname", postgresRemoteDatabase.value,
        "--no-owner",
        "--no-privileges"
      )

      Process(command, None, "PGPASSWORD" -> postgresRemotePassword.value) #> dumpFile !

      dumpFile
    },

    postgresLocalUsername := "useless",

    postgresLocalDatabase := "DUMMY",

    postgresRestoreFromRemote := {
      val dumpFile = postgresDumpRemote.value
      val localDatabase = postgresLocalDatabase.value
      val tmpDatabase = localDatabase + "_" + buildUniqueString()
      val backupDatabase = localDatabase + "_bak"

      s"createdb ${tmpDatabase}".!

      Seq(
        "psql",
        "--dbname", tmpDatabase,
        "--file", dumpFile.getPath,
        "--user", postgresLocalUsername.value
      ).!

      s"dropdb --if-exists ${backupDatabase}".!

      Seq(
        "psql",
        "--dbname", "postgres",
        "--command", s"ALTER DATABASE ${localDatabase} RENAME TO ${backupDatabase}"
      ).!

      Seq(
        "psql",
        "--dbname", "postgres",
        "--command", s"ALTER DATABASE ${tmpDatabase} RENAME TO ${localDatabase}"
      ).!
    }

  )

}
