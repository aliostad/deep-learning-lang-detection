package testutil

import javax.management.MBeanServer
import java.lang.management.ManagementFactory
import com.sun.management.HotSpotDiagnosticMXBean

object HeapDumper {
  private final val HOTSPOT_BEAN_NAME: String = "com.sun.management:type=HotSpotDiagnostic"
  /**
    * Call this method from your application whenever you
    * want to dump the heap snapshot into a file.
    *
    * @param fileName name of the heap dump file
    * @param live flag that tells whether to dump
    *             only the live objects
    */
  private def dumpHeap(fileName: String, live: Boolean) {
    initHotspotMBean()
    try {
      hotspotMBean.dumpHeap(fileName, live)
    } catch {
      case re: RuntimeException =>
        throw re
      case exp: Exception =>
        throw new RuntimeException(exp)
    }
  }

  private def initHotspotMBean() {
    if (hotspotMBean == null) {
      HeapDumper synchronized {
        if (hotspotMBean == null) {
          hotspotMBean = getHotspotMBean
        }
      }
    }
  }

  private def getHotspotMBean: HotSpotDiagnosticMXBean = {
    try {
      val server: MBeanServer = ManagementFactory.getPlatformMBeanServer
      val bean: HotSpotDiagnosticMXBean = ManagementFactory.newPlatformMXBeanProxy(server, HOTSPOT_BEAN_NAME, classOf[HotSpotDiagnosticMXBean])
      bean
    } catch {
      case re: RuntimeException =>
        throw re
      case exp: Exception =>
        throw new RuntimeException(exp)
    }
  }

  def main(args: Array[String]) {
    var fileName: String = "heap.bin"
    var live: Boolean = true
    args.length match {
      case 2 =>
        fileName = args(0)
        live = args(1) == "true"
      case 1 =>
        fileName = args(0)
    }
    dumpHeap(fileName, live)
  }

  @volatile
  private var hotspotMBean: HotSpotDiagnosticMXBean = null
}