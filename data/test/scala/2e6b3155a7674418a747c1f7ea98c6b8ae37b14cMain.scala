/*
 *  Main.scala
 *  (Schwaermen)
 *
 *  Copyright (c) 2017 Hanns Holger Rutz. All rights reserved.
 *
 *  This software is published under the GNU General Public License v2+
 *
 *
 *  For further information, please contact Hanns Holger Rutz at
 *  contact@sciss.de
 */

package de.sciss.schwaermen
package control

object Main extends MainLike {
  protected val pkgLast = "control"

  def main(args: Array[String]): Unit = {
    println(s"-- $name $fullVersion --")
    val default = Config()
    val p = new scopt.OptionParser[Config](namePkg) {
      opt[Unit] ('d', "dump-osc")
        .text (s"Enable OSC dump (default ${default.dumpOSC})")
        .action { (_, c) => c.copy(dumpOSC = true) }
    }
    p.parse(args, default).fold(sys.exit(1)) { config =>
      val host = Network.thisIP()
      run(host, config)
    }
  }

  def run(host: String, config: Config): Unit = {
    val c = OSCClient(config, host)
    new MainFrame(c)
  }
}