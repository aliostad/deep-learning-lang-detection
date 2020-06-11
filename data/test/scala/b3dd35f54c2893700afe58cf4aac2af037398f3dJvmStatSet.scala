package amplab.charles

import com.codahale.metrics.{Gauge, Metric, MetricSet}

import java.util.{Map => JMap, HashMap => JHashMap, Collections => JCollections}
import sun.jvmstat.monitor.{Monitor, MonitoredHost, VmIdentifier}

class JvmStatSet(val isMinimal: Boolean = false) extends MetricSet {
    val selfVmId = new VmIdentifier("local://0@localhost");
    val thisVmMonitor = MonitoredHost.getMonitoredHost(selfVmId).getMonitoredVm(selfVmId);

    val timerFreq = thisVmMonitor.findByName("sun.os.hrt.frequency").getValue.asInstanceOf[Long]

    private def makeMonitor(target: String): Monitor = {
        return thisVmMonitor.findByName(target)
    }

    val MINIMAL_SET = Set(
        "youngEdenCapacity",
        "promoted",
        "youngGcCount",
        "fullGcCount",
        "youngGcMsec",
        "fullGcMsec",
        "oldGenUsed",
        "edenPreGCBytes",
        "metaUsed",
        "metaCapacity"
    )

    val NUMBER_FIELDS = List(
        "sun.gc.policy.tenuringThreshold" -> "tenuringThreshold",

        "sun.gc.policy.avgOldLive" -> "avgOldLive",
        "sun.gc.policy.promoted" -> "promoted",
        "sun.gc.policy.survived" -> "survived",
        "sun.gc.policy.avgPromotedAvg" -> "avgPromotedAvg",
        "sun.gc.policy.avgPromotedDev" -> "avgPromotedDev",
        "sun.gc.policy.avgSurvivedAvg" -> "avgSurvivedAvg",
        "sun.gc.policy.avgSurvivedDev" -> "avgSurvivedDev",
        "sun.gc.policy.avgYoungLive" -> "avgYoungLive",
        "sun.gc.policy.liveAtLastFullGc" -> "liveAtLastFullGc",
        "sun.gc.policy.majorCollectionSlope" -> "majorCollectionSlope",
        "sun.gc.policy.minorCollectionSlope" -> "minorCollectionSlope",
        "sun.gc.policy.majorGcCost" -> "majorGcCost",
        "sun.gc.policy.minorPauseOldSlope" -> "minorPauseOldSlope",
        "sun.gc.policy.minorPauseYoungSlope" -> "minorPauseYoungSlope",

        "sun.gc.collector.0.invocations" -> "youngGcCount",
        "sun.gc.collector.1.invocations" -> "fullGcCount",

        "sun.gc.generation.0.agetable.bytes.00" -> "youngAge00Bytes",
        "sun.gc.generation.0.agetable.bytes.01" -> "youngAge01Bytes",
        "sun.gc.generation.0.agetable.bytes.02" -> "youngAge02Bytes",
        "sun.gc.generation.0.agetable.bytes.03" -> "youngAge03Bytes",
        "sun.gc.generation.0.agetable.bytes.04" -> "youngAge04Bytes",
        "sun.gc.generation.0.agetable.bytes.05" -> "youngAge05Bytes",
        "sun.gc.generation.0.agetable.bytes.06" -> "youngAge06Bytes",
        "sun.gc.generation.0.agetable.bytes.07" -> "youngAge07Bytes",
        "sun.gc.generation.0.agetable.bytes.08" -> "youngAge08Bytes",
        "sun.gc.generation.0.agetable.bytes.09" -> "youngAge09Bytes",
        "sun.gc.generation.0.agetable.bytes.10" -> "youngAge10Bytes",
        "sun.gc.generation.0.agetable.bytes.11" -> "youngAge11Bytes",
        "sun.gc.generation.0.agetable.bytes.12" -> "youngAge12Bytes",
        "sun.gc.generation.0.agetable.bytes.13" -> "youngAge13Bytes",
        "sun.gc.generation.0.agetable.bytes.14" -> "youngAge14Bytes",
        "sun.gc.generation.0.agetable.bytes.15" -> "youngAge15Bytes",
        // don't check beyond here because age field is often limited to 15
        "sun.gc.generation.0.space.0.capacity" -> "youngEdenCapacity",
        "sun.gc.generation.0.space.0.maxCapacity" -> "youngEdenCapacityMax",
        "sun.gc.generation.0.space.1.capacity" -> "youngS0Capacity",
        "sun.gc.generation.0.space.1.used" -> "youngS0Used",
        "sun.gc.generation.0.space.2.capacity" -> "youngS1Capacity",
        "sun.gc.generation.0.space.2.used" -> "youngS1Used",

        "sun.gc.generation.1.capacity" -> "oldGenCapacity",
        "sun.gc.generation.1.maxCapacity" -> "oldGenMaxCapacity",
        "sun.gc.generation.1.space.0.used" -> "oldGenUsed",

	"sun.gc.collector.0.scanned" -> "youngScanned",
	"sun.gc.collector.0.marked" -> "youngMarked",
	"sun.gc.collector.0.oldMarkedForYoung" -> "oldMarkedForYoung",
	"sun.gc.collector.0.oldScannedForYoung" -> "oldScannedForYoung",
	"sun.gc.collector.0.inOldScannedForYoung" -> "inOldScannedForYoung",
	"sun.gc.collector.0.inOldBytesScannedForYoung" -> "inOldBytesScannedForYoung",
	"sun.gc.collector.0.inOldCardsScannedForYoung" -> "inOldCardsScannedForYoung",
	"sun.gc.collector.0.inOldCardsFoundForYoung" -> "inOldCardsFoundForYoung",
	"sun.gc.collector.0.oldToYoungPointers" -> "oldToYoungPointers",
	
        "sun.gc.collector.0.goodInOldScannedForYoung" -> "goodInOldScannedForYoung",
        "sun.gc.collector.0.bogusCards" -> "bogusCards",
        "sun.gc.collector.0.oneObjectCardRanges" -> "oneObjectCardRanges",
        
        "sun.gc.collector.0.smallInOldScannedForYoung" -> "smallInOldScannedForYoung",
        "sun.gc.collector.0.smallGoodInOldScannedForYoung" -> "smallGoodInOldScannedForYoung",
        "sun.gc.collector.0.smallBytesInOldScannedForYoung" -> "smallBytesInOldScannedForYoung",
	"sun.gc.collector.0.bytesPretenured" -> "bytesPretenured0",
	"sun.gc.collector.0.edenPreGCBytes" -> "edenPreGCBytes",

	"sun.gc.collector.1.scanned" -> "oldScanned",
	"sun.gc.collector.1.marked" -> "oldMarked",
	"sun.gc.collector.1.bytesPretenured" -> "bytesPretenured",

        /* JDK 7
        "sun.gc.generation.2.space.0.used" -> "permUsed",
        "sun.gc.generation.2.space.0.capacity" -> "permCapacity",
        "sun.gc.generation.2.capacity" -> "permCapacityTop",
        */
        
        /* JDK 8 */
        "sun.gc.metaspace.used" -> "metaUsed",
        "sun.gc.metaspace.capacity" -> "metaCapacity",
        "sun.gc.metaspace.maxCapacity" -> "metaMaxCapacity"
    )

    val NUMBER_MONITORS = NUMBER_FIELDS.map { case (k, v) => makeMonitor(k) -> v }
    
    val TIME_FIELDS = List(
        "sun.gc.collector.0.time" -> "youngGcMsec",
        "sun.gc.collector.1.time" -> "fullGcMsec"
    )

    val TIME_MONITORS = TIME_FIELDS.map { case (k, v) => makeMonitor(k) -> v }

    val STRING_FIELDS = List(
        "sun.gc.cause" -> "gcCause",
        "sun.gc.lastCause" -> "lastGCCause"
    )

    val STRING_MONITORS = STRING_FIELDS.map { case (k, v) => makeMonitor(k) -> v }

    override def getMetrics: JMap[String, Metric] = {
        val result = new JHashMap[String, Metric]
        for ((monitor, label) <- NUMBER_MONITORS) {
            if (monitor != null) {
                result.put(label, new Gauge[Long] {
                    override def getValue: Long = monitor.getValue.asInstanceOf[Long]
                })
            }
        }
        for ((monitor, label) <- TIME_MONITORS) {
            result.put(label, new Gauge[Double] {
                override def getValue: Double = {
                    monitor.getValue.asInstanceOf[Long] / (timerFreq / 1000.0)
                }
            })
        }
        for ((monitor, label) <- STRING_MONITORS) {
            result.put(label, new Gauge[String] {
                override def getValue: String = monitor.getValue.asInstanceOf[String]
            })
        }
        if (isMinimal) {
            val realResult = new JHashMap[String, Metric]
            for (k <- MINIMAL_SET) {
                val item = result.get(k)
                if (item != null) {
                    realResult.put(k, result.get(k))
                } else {
                    System.err.println("JvmStatSet: Could not find " + k)
                }
            }
            return JCollections.unmodifiableMap(realResult)
        } else {
            return JCollections.unmodifiableMap(result)
        }
    }
}
