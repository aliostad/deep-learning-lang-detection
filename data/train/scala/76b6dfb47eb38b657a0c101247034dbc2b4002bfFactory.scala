package cucumber.ext.ssh

import net.schmizz.sshj.SSHClient

/**
 * Helper base class to manage SSH operations
 */
object Factory {

  private[ssh] def login(host:String, user:String, pass:String, hostKeys:Array[String],timeout:Int = 10000) = {
    val ssh = new SSHClient()
    // if support.server hasn't responded in X seconds, fall over
    ssh.setTimeout(timeout)
    ssh.loadKnownHosts()
    hostKeys.toArray.foreach { (host) =>
      host match {
        case host:String => ssh.addHostKeyVerifier(host)
      }
    }
    ssh.connect(host)
    ssh.authPassword(user, pass)
    ssh
  }

}
