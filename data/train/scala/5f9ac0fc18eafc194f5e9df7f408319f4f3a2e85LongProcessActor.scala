package actors

import se.scalablesolutions.akka.actor._
import play.cache.Cache
import play.db.jpa._

/**
 * @param longProcess function returning a json String
 * @param procId a delegated process id based on the user's session and other info
 */
case class Spawn(useCache: Boolean, longProcess: () => Any, procId: String)

class LongProcessActor() extends Actor {
    
    def receive = {
        case Spawn(true, longProcess, procId) => 
            storeInCache(executeLongProcess(longProcess), procId)
        case Spawn(false, longProcess, procId) =>
            self.reply(executeLongProcess(longProcess), procId)
        case _ => throw new RuntimeException("unknown message")
    }

    private def executeLongProcess(longProcess: () => Any): Any = {
        var processOutput: Any = None

        try {
            JPAPlugin.startTx(false)
            processOutput = longProcess
            JPAPlugin.closeTx(false)
        }
        catch {
            case e => {
                processOutput = e
                JPAPlugin.closeTx(true)
            }
        }

        return processOutput
    }

    // longProcessResponse can also be an exception message
    private def storeInCache(processOutput: Any, procId: String) = {
        Cache.set(procId, processOutput, "1mn")
    }    
}
