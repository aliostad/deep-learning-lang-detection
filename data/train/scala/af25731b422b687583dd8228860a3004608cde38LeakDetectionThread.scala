package com.github.dwickern

import java.io.File

import se.jiderhamn.HeapDumper
import se.jiderhamn.classloader.leak.prevention.ClassLoaderLeakPreventor

import scala.ref.WeakReference

private object LeakDetectionThread {
  /**
    * Create a thread to run ClassLoader leak detection.
    *
    * A thread is used because the current thread's stack will still reference the ClassLoader.
    * @param classLoader the classloader which should be garbage collected
    */
  def apply(classLoader: ClassLoader, config: LeakPreventionConfig): LeakDetectionThread =
    new LeakDetectionThread(WeakReference(classLoader), config)
}

private class LeakDetectionThread private (classLoader: WeakReference[ClassLoader], config: LeakPreventionConfig)
    extends Thread("ClassLoader Leak Detection") {

  setContextClassLoader(null)

  override def run(): Unit = {
    for (_ <- 1 to config.detectionAttempts if classLoader.get.isDefined) {
      Thread.sleep(config.detectionInterval.toMillis)
      ClassLoaderLeakPreventor.gc()
    }

    if (classLoader.get.isDefined && config.enableHeapDump) {
      classLoader.clear() // don't include this reference in the heap dump

      val out = new File(config.heapDumpOutputDir, s"heapdump-${System.currentTimeMillis()}.hprof")
      config.logger.error("ClassLoader leak detected! Writing heap dump to: " + out.getAbsolutePath)
      HeapDumper.dumpHeap(out, false)
    } else if (classLoader.get.isDefined) {
      config.logger.error("ClassLoader leak detected! To generate a heap dump, `set ClassLoaderLeakPreventor.enableLeakDetectionHeapDump := true`")
    } else {
      config.logger.debug("No ClassLoader leak was detected.")
    }
  }
}
