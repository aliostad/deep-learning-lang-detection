package internet_user_churn.extract

/**
  * Created by hungdv on 10/04/2017.
  */
case class LoadJobConfig(
                        inputRootFolder:  String,
                        outputRootFolder: String,
                        sparkConfig: Map[String,String]
                        )extends  Serializable {}

object LoadJobConfig{
  import com.typesafe.config.{Config,ConfigFactory}
  import net.ceedubs.ficus.Ficus._
  import net.ceedubs.ficus.readers.ArbitraryTypeReader.arbitraryTypeValueReader

  def apply(loadJobConfig: Config): LoadJobConfig ={
    val config = loadJobConfig.getConfig("loadExtractJob")
    new LoadJobConfig(config.as[String]("inputRootFolder"),
                      config.as[String]("outputRootFolder"),
                      config.as[Map[String,String]]("sparkConfig"))
  }

  def apply(): LoadJobConfig = apply(ConfigFactory.load)

}

