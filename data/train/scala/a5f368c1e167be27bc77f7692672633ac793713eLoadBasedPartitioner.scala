package de.hpi.isg.sodap.rdfind.operators

import de.hpi.isg.sodap.rdfind.operators.LoadBasedPartitioner.PartitionLoad
import org.apache.flink.api.common.functions.Partitioner
import org.slf4j.LoggerFactory

import scala.collection.mutable

/**
 * @author sebastian.kruse 
 * @since 09.06.2015
 */
class LoadBasedPartitioner extends Partitioner[Int] {

  private var partitions: mutable.PriorityQueue[PartitionLoad] = _

  private var counter = 0

  override def partition(key: Int, numPartitions: Int): Int = {
    // Lazy-initialize the priority-queue with 
    if (this.partitions == null) {
      this.partitions = new mutable.PriorityQueue[PartitionLoad]()
      0 until numPartitions foreach { partitionId =>
        this.partitions += PartitionLoad(partitionId, 0L)
      }
    }

    // Add the load to the element with the least load.
    val elementLoad = key.asInstanceOf[Long] * key
    val leastLoad = this.partitions.dequeue()
    leastLoad.load += elementLoad
    this.partitions += leastLoad

    // Occasionally, log load-balancing statistics.
    this.counter += 1
    if (this.counter == 10000) {
      this.counter = 0
      LoggerFactory.getLogger(getClass).info(s"Current load-balancing: ${this.partitions}")
    }

    // Send element to the partition with the least load.
    leastLoad.partition
  }
  
}

object LoadBasedPartitioner {
  
  case class PartitionLoad(partition: Int, var load: Long) extends Ordered[PartitionLoad] {
    override def compare(that: PartitionLoad): Int = java.lang.Long.compare(that.load, this.load)
  }
  
}
