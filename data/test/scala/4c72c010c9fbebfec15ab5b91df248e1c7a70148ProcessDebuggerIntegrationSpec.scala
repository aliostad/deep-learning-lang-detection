package org.scaladebugger.api.debuggers
import java.io.IOException
import java.util.concurrent.atomic.AtomicBoolean

import org.scaladebugger.api.utils.JDITools
import org.scaladebugger.test.helpers.ParallelMockFunSpec
import test.{ApiTestUtilities, VirtualMachineFixtures}

import scala.util.Try

class ProcessDebuggerIntegrationSpec extends ParallelMockFunSpec
  with VirtualMachineFixtures
  with ApiTestUtilities
{
  describe("ProcessDebugger") {
    it("should be able to attach to a running JVM process") {
      withProcess((pid, process) => {
        val processDebugger = ProcessDebugger(pid)

        val attachedToVirtualMachine = new AtomicBoolean(false)

        // Need to keep retrying until process is ready to be attached to
        // NOTE: If unable to connect, ensure that hostname is "localhost"
        eventually {
          processDebugger.start(_ => attachedToVirtualMachine.set(true))
        }

        // Keep checking back until we have successfully attached
        eventually {
          attachedToVirtualMachine.get() should be (true)
        }
      })
    }
  }

  /** Pid, Process */
  private def withProcess[T](testCode: (Int, Process) => T): T = {
    val jvmProcess = createProcess()

    val result = Try(testCode(jvmProcess._1, jvmProcess._2))

    destroyProcess(jvmProcess._2)

    result.get
  }

  private def createProcess(): (Int, Process) = {
    val (pid, process) = JDITools.spawnAndGetPid(
      className = "org.scaladebugger.test.misc.AttachingMain",
      server = true,
      port = 0 // Assign ephemeral port
    )

    // If unable to retrieve the process PID, exit now
    if (pid <= 0) {
      process.destroy()
      throw new IOException("Unable to retrieve process PID!")
    }

    (pid, process)
  }

  private def destroyProcess(process: Process): Unit = process.destroy()
}
