package uk.vitalcode.events.crawler.services

import java.util.concurrent.TimeUnit

import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.model._
import akka.http.scaladsl.model.headers._
import akka.stream.ActorMaterializer
import org.apache.hadoop.hbase.util.Bytes
import org.openqa.selenium.Dimension
import org.openqa.selenium.phantomjs.{PhantomJSDriver, PhantomJSDriverService}
import org.openqa.selenium.remote.DesiredCapabilities
import uk.vitalcode.events.crawler.common.AppConfig

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._
import scala.concurrent.{Await, Future, Promise}

trait HttpClient {
    def makeRequest(url: String, phantom: Boolean): Array[Byte]

    def dispose(): Unit
}

class DefaultHttpClient(system: ActorSystem) extends HttpClient {

    implicit val materializer = ActorMaterializer.create(system)

    override def makeRequest(url: String, phantom: Boolean): Array[Byte] = {
        if (phantom) getWebPage(url) else getImage(url)
    }

    override def dispose() = phantomDriver.quit()

    private val phantomDriver: PhantomJSDriver = {
        val caps = new DesiredCapabilities()
        caps.setJavascriptEnabled(true)
        caps.setCapability("phantomjs.page.settings.takesScreenshot", false)
        caps.setCapability("phantomjs.page.settings.loadImages", false)
        caps.setCapability("phantomjs.page.settings.userAgent", AppConfig.httpClientUserAgent)
        caps.setCapability("phantomjs.page.settings.resourceTimeout", AppConfig.httpClientTimeout)
        caps.setCapability(PhantomJSDriverService.PHANTOMJS_GHOSTDRIVER_CLI_ARGS, "--webdriver-loglevel=ERROR")
        caps.setCapability(PhantomJSDriverService.PHANTOMJS_EXECUTABLE_PATH_PROPERTY, AppConfig.httpClientPhantomPath)

        val driver = new PhantomJSDriver(caps)
        driver.manage().window().setSize(new Dimension(AppConfig.httpClientWindowWidth, AppConfig.httpClientWindowHeight))
        driver.manage().timeouts().setScriptTimeout(AppConfig.httpClientTimeout, TimeUnit.MILLISECONDS)
        driver.manage().timeouts().pageLoadTimeout(AppConfig.httpClientTimeout, TimeUnit.MILLISECONDS)
        driver.manage().timeouts().implicitlyWait(AppConfig.httpClientTimeout, TimeUnit.MILLISECONDS)
        driver
    }

    private def buildHttpRequest(url: String): HttpRequest = {
        val acceptEncoding = headers.`Accept-Encoding`(
            List(HttpEncodingRange(HttpEncodings.gzip), HttpEncodingRange(HttpEncodings.deflate)))
        val accept = headers.Accept(
            List(MediaRange(MediaTypes.`text/html`), MediaRange(MediaTypes.`application/xml`),
                MediaRange(MediaTypes.`application/xhtml+xml`), MediaRange(MediaTypes.`image/webp`)))
        val userAgent = headers.`User-Agent`(AppConfig.httpClientUserAgent)

        HttpRequest(
            uri = url,
            method = HttpMethods.GET,
            headers = List(acceptEncoding, accept, userAgent),
            protocol = HttpProtocols.`HTTP/1.0`)
    }

    private def getImage(url: String): Array[Byte] =
        Await.result(
            Http(system).singleRequest(buildHttpRequest(url))
                .flatMap(response => response.entity.toStrict(60.second))
                .map(b => b.getData().toArray),
            atMost = 60.second)

    private def getWebPage(url: String): Array[Byte] = {
        phantomDriver.get(url)
        Bytes.toBytes(phantomDriver.getPageSource)
    }
}


