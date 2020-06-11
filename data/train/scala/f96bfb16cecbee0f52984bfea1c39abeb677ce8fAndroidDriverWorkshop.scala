package com.stubhub.qe.platform.elephant.agency.workshop

import java.net.URL
import java.nio.file.Paths
import java.util.concurrent.TimeUnit.SECONDS

import com.stubhub.qe.platform.elephant.agency.manage.AndroidDriverAgent
import com.stubhub.qe.platform.elephant.context.ContextTree
import com.stubhub.qe.platform.elephant.exception.AppFileMissingException
import com.stubhub.qe.platform.elephant.log.LogRepository
import io.appium.java_client.AppiumDriver
import org.openqa.selenium.remote.DesiredCapabilities

/**
 *
 * @author Hongfei Zhou
 * @version 1.0, Sep. 11 2014
 */
object AndroidDriverWorkshop {
    def produceAgent(context: ContextTree): AndroidDriverAgent = {
        val capabilities = buildCapabilities(context)

        val server = context.getOptValue("grid") match {
            case Some(grid) => new URL(grid)
            case None => new URL("http://127.0.0.1:4723/wd/hub")
        }

        val driver = new AppiumDriver(server, capabilities)

        context.getOptValue("android.timeout") match {
            case Some(time) => driver.manage().timeouts().implicitlyWait(time.toInt, SECONDS)
            case None => driver.manage().timeouts().implicitlyWait(30, SECONDS)
        }
        AndroidDriverAgent(driver, context)
    }

    def buildCapabilities(context: ContextTree): DesiredCapabilities = {
        val logBlock = LogRepository.current.newBlock

        val capabilities = new DesiredCapabilities()

        context.getOptValue("appium.version") match {
            case Some(version) => capabilities.setCapability("appium-version", version)
            case None => capabilities.setCapability("appium-version", "1.2.0.1")
        }

        capabilities.setCapability("platformName", "Android")
        capabilities.setCapability("deviceName", "Android")

        context.getOptValue("android.version") match {
            case Some(version) => capabilities.setCapability("platformVersion", version)
            case None => capabilities.setCapability("platformVersion", 4.3)
        }

        capabilities.setCapability("name", "StubHub Android Native APP")

        context.getOptValue("android.apk") match {
            case Some(apk) => capabilities.setCapability("app", Paths.get(System.getProperty("user.dir"), apk).toAbsolutePath.toString)
            case None => throw new AppFileMissingException("Android APK file needs to be set with key app.android.apk")
        }

        capabilities
    }
}
