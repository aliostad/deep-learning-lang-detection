package com.revolut.internal_api.contexts

import com.typesafe.config.ConfigFactory

/**
  * Web context to manage web server.
  */
class WebContext {

  /**
    * Lazy load web api configuration.
    */
  private lazy val webApiConfig = ConfigFactory.load().getConfig("internal-api")

  /**
    * Gets api url.
    *
    * @return API url
    */
  def getApiUrl: String = webApiConfig.getString("url")

  /**
    * Gets api port.
    *
    * @return API port
    */
  def getApiPort: Int = webApiConfig.getInt("port")

}