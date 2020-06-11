// Copyright: 2010 - 2017 https://github.com/ensime/ensime-server/graphs
// License: http://www.gnu.org/licenses/gpl-3.0.en.html
package org.ensime.util

import java.io.File
import java.lang.management.ManagementFactory

import scala.concurrent.{ ExecutionContext, Future }
import scala.concurrent.duration._

import com.sun.management.HotSpotDiagnosticMXBean

// used to diagnose problems on the CI machines
object HeapDumper {
  private lazy val diagnostics = ManagementFactory.newPlatformMXBeanProxy(
    ManagementFactory.getPlatformMBeanServer(),
    "com.sun.management:type=HotSpotDiagnostic",
    classOf[HotSpotDiagnosticMXBean]
  )

  def dump(file: File): Unit = diagnostics.dumpHeap(file.getAbsolutePath, false)

  def dumpAndExit(file: File, duration: FiniteDuration = 10.seconds): Unit = {
    import ExecutionContext.Implicits.global
    Future {
      Thread.sleep(duration.toMillis)
      dump(file)
      sys.exit(1)
    }
  }
}
