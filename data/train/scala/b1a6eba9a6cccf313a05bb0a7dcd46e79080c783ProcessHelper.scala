package com.shocktrade.server.common

import io.scalajs.nodejs.Process

/**
  * ShockTrade Process Helper
  * @author Lawrence Daniels <lawrence.daniels@gmail.com>
  */
object ProcessHelper {

  /**
    * Process configuration extensions
    * @param process the given [[Process process]]
    */
  implicit class ProcessConfigExtensions(val process: Process) extends AnyVal {

    /**
      * Attempts to returns the web application listen port
      * @return the option of the web application listen port
      */
    @inline
    def port: Option[String] = process.env.find(_._1.equalsIgnoreCase("port")).map(_._2)

    /**
      * Attempts to returns the database connection URL
      * @return the option of the database connection URL
      */
    @inline
    def dbConnect: Option[String] = process.env.find(_._1.equalsIgnoreCase("db_connection")).map(_._2)

    /**
      * Attempts to returns the Zookeeper connection URL
      * @return the option of the Zookeeper connection URL
      */
    @inline
    def zookeeperConnect: Option[String] = process.env.find(_._1.equalsIgnoreCase("zk_connection")).map(_._2)

  }

}
