package zzb.srvbox

import akka.actor.{Props, ActorRef, ActorSystem}
import com.typesafe.scalalogging.slf4j.Logging
import zzb.config.EnvConfigLoader
import com.typesafe.config.{ConfigFactory, Config}
import zzb.shell.{Shell, Task}
import zzb.shell.remote.ShellDaemon
import spray.can.Http.Bind
import spray.can.Http
import javax.net.ssl.{TrustManagerFactory, KeyManagerFactory, SSLContext}
import java.security.{SecureRandom, KeyStore}
import spray.io.ServerSSLEngineProvider
import spray.can.server.ServerSettings

/**
 * Created with IntelliJ IDEA.
 * User: Simon Xiao
 * Date: 13-7-27
 * Time: 下午1:29
 * Copyright goodsl.org 2012~2020
 */
object BoxApp extends App with Logging with EnvConfigLoader {

  val (config, servicesOpts) = BoxBuilder.getSelectService(args.toList)

  //启动服务
  // todo: 解决端口绑定失败，服务不能退出的问题
  val system = ActorSystem("srvbox", config)

  val boxBuilder = new BoxBuilder(system,config)

  //启动部署的服务
  boxBuilder.startBoxedServices(servicesOpts)
  //启动远程管理支持
  startRemoteManage(config, system)
  //启动 Rest 管理服务
  startRestManager(config, system)


  private[srvbox] def startRemoteManage(config: Config, system: ActorSystem): ActorRef = {
    def loadTaskConfig() = {
      import scala.collection.JavaConversions._

      val urls = Thread.currentThread().getContextClassLoader.
        getResources("srv-task.conf").toIterator

      urls.foreach {
        url =>
          val taskConfig = ConfigFactory.parseURL(url).getConfig("task")
          Task.parseConfig(taskConfig)
      }
    }

    val defaultRmConfig = ConfigFactory.load("defaultRemoteManage.conf").getConfig("remoteManage")
    val rmConfig = try {
      config.getConfig("remoteManage").withFallback(defaultRmConfig)
    } catch {
      case ex: Throwable ⇒ defaultRmConfig
    }

    if (rmConfig.getInt("enable") == 1) {

      Shell.init(rmConfig, system, sysOnlyForShell = false)

      val appName = rmConfig.getString("appname")

      val shellActor = ShellDaemon.install(appName)
      logger.info(s"remote manage actor  ： ${shellActor.path.toString} ")

      loadTaskConfig()
      shellActor
    } else {
      system.deadLetters
    }
  }

  private[srvbox] def startRestManager(config: Config, system: ActorSystem) {
    val host = config.getString("http.host")
    val port = config.getInt("http.port")
    val api = system.actorOf(Props(new RestInterface()), "httpInterface")
    val isHttpOpen = if (config.hasPath("http.isHttpOpen")) config.getBoolean("http.isHttpOpen") else true
    val isHttpsOpen = if (config.hasPath("http.isHttpsOpen")) config.getBoolean("http.isHttpOpen") else false
    if (isHttpOpen) {
      //默认启动http地端口,强行设置该端口不为http，主要是为防止设置了spray.can.server.ssl-encryption = on
      Http(system).manager ! Bind(listener = api, interface = host, port = port, settings = Some(ServerSettings(system).copy(sslEncryption = false)))
    }

    //启动https端口
    if (isHttpsOpen) {
      val httpsPort = config.getInt("http.https-port")
      val password = config.getString("http.keystore.password")
      val keystorePath = config.getString("http.keystore.path")

      implicit def sslContext: SSLContext = {
        val keyStore = KeyStore.getInstance("jks")
        val ksIs = getClass.getClassLoader.getResourceAsStream(keystorePath) //new FileInputStream(keystorePath)
        keyStore.load(ksIs, password.toCharArray)
        val keyManagerFactory = KeyManagerFactory.getInstance("SunX509")
        keyManagerFactory.init(keyStore, password.toCharArray)
        val trustManagerFactory = TrustManagerFactory.getInstance("SunX509")
        trustManagerFactory.init(keyStore)
        val context = SSLContext.getInstance("TLS")
        context.init(keyManagerFactory.getKeyManagers, trustManagerFactory.getTrustManagers, new SecureRandom)
        context
      }
      def sslEngineProvider: ServerSSLEngineProvider = {
        ServerSSLEngineProvider {
          engine =>
            //默认jce不支持256位加密
            engine.setEnabledCipherSuites(Array("TLS_RSA_WITH_AES_128_CBC_SHA"))
            engine.setEnabledProtocols(Array("SSLv3", "TLSv1"))
            engine
        }
      }
      Http(system).manager ! Bind(listener = api, interface = host, port = httpsPort, settings = Some(ServerSettings(system).copy(sslEncryption = true)))(sslEngineProvider)
    }
  }

}


