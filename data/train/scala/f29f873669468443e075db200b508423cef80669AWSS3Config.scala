package sample

import java.io.{InputStreamReader, InputStream, File}
import com.amazonaws.services.s3.model.Region
import com.typesafe.config.{Config, ConfigFactory}

case class AWSS3Config(
  accessKey: String,
  secretAccessKey: String,
  bucketName: String,
  region: Region
)

object AWSS3Config {
  def load(): AWSS3Config = {
    load(ConfigFactory.load())
  }

  def load(in: InputStream): AWSS3Config = {
    load(ConfigFactory.parseReader(new InputStreamReader(in, "UTF-8")))
  }

  def load(string: String): AWSS3Config = {
    load(ConfigFactory.parseString(string))
  }

  def load(file: File): AWSS3Config = {
    load(ConfigFactory.parseFile(file))
  }

  def load(config: Config): AWSS3Config = {
    AWSS3Config(
      accessKey = config.getString("aws.s3.accessKey"),
      secretAccessKey = config.getString("aws.s3.secretAccessKey"),
      bucketName = config.getString("aws.s3.bucketName"),
      region = Option(config.getString("aws.s3.region"))
        .filter(_.nonEmpty).map(Region.fromValue)
        .getOrElse(Region.US_Standard)
    )
  }
}