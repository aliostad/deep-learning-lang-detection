package com.stubhub.qe.platform.elephant.agency.workshop

import com.stubhub.qe.platform.elephant.agency.manage.{DriverAgent, UXDriverAgent}
import com.stubhub.qe.platform.elephant.context.ContextTree
import com.stubhub.qe.platform.elephant.log.Log

/**
 *
 * @author Hongfei Zhou
 * @version 1.0, Aug. 13 2014
 */
class DriverWorkshop


object DriverWorkshop {
    def produceAgent(context: ContextTree): DriverAgent = context.getValue match {
        case "chrome" | "Chrome" | "CHROME" =>ChromeDriverWorkshop.produceAgent(context)
        case "firefox" | "Firefox" | "FIREFOX" =>FirefoxDriverWorkshop.produceAgent(context)
        case "android" | "Android" | "ANDROID" => AndroidDriverWorkshop.produceAgent(context)
        case _ => ???
    }
}

class WorkshopLog(content: String) extends Log("WORKSHOP", content)

object WorkshopLog {
    def apply(content: String) = new WorkshopLog(content)
}