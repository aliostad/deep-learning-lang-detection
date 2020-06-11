import java.io.File
import play.api._
import com.typesafe.config.ConfigFactory

// Stolen from http://stackoverflow.com/questions/9723224/how-to-manage-application-conf-in-several-environments-with-play-2-0
object Global extends GlobalSettings {
  override def onLoadConfig(config: Configuration, path: File, classloader: ClassLoader, mode: Mode.Mode): Configuration = {
    val modeSpecificConfig = config ++ Configuration(ConfigFactory.load(s"application.${mode.toString.toLowerCase}.conf"))
    super.onLoadConfig(modeSpecificConfig, path, classloader, mode)
  }
}