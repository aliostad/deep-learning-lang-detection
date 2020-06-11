package com.gravity.utilities

import java.io.File
import java.net.InetAddress
import java.util.concurrent.atomic.AtomicBoolean

import scala.collection._

/*
 *    __   _         __         
 *   / /  (_)__  ___/ /__  ____
 *  / _ \/ / _ \/ _  / _ \/ _  /
 * /_//_/_/_//_/\_,_/\___/\_, / 
 *                       /___/
 */

class HeapDumpMonitorThread(outputPath: String, liveOnly: Boolean = false, threshold: Float = 0.90f, frequency: Long = 1000) extends Thread {
	@volatile var shouldStop: Boolean = false
	setDaemon(true)

	override def run(): Unit = {
		HeapDumpMonitorThread.running.synchronized {
			if (HeapDumpMonitorThread.running.get()) {
				println("Heap dump monitor already running, won't start another one")
				return
			} else {
				println(s"Starting heap dump monitor with outputPath: $outputPath, liveOnly: $liveOnly, threshold: $threshold, frequency: $frequency")
			}
			HeapDumpMonitorThread.running.set(true)
		}

		while (!shouldStop) {
			val max = Runtime.getRuntime.maxMemory()
			val total = Runtime.getRuntime.totalMemory()
			val free = Runtime.getRuntime.freeMemory()
			val usage = 1.0f - (free.toFloat / total.toFloat)

			//println(s"max: $max, total: $total, free: $free, usage: ${usage * 100}%")

			if (usage > threshold) {
				val outputFile = new File(outputPath, "heapdump_" + InetAddress.getLocalHost.getHostName + "_" + System.currentTimeMillis().toString + ".hprof").toString

				println(s"Heap usage exceeded threshold ${threshold * 100}%, dumping heap to $outputFile...")
				HeapDumper.dumpHeap(outputFile, liveOnly)
				println(s"Heap dump complete.")
				shouldStop = true
			} else {
				Thread.sleep(frequency)
			}

		}
	}
}

object HeapDumpMonitorThread {
	val running = new AtomicBoolean(false)
}
