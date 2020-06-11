package com.prophetstor.storageai.metadata

/**
  * Created by brian on 02/02/2017.
  */
object DiskIoMetadata {
  val DiskIoTableName = "diskio"
  val Host = "host"

  // InfluxDB column names
  // time,host,io_time,name,read_bytes,read_time,reads,write_bytes,write_time,writes
  val Time = "time"
  val IoTime = "io_time"
  val DiskName = "name" // device name, e.g. sdb, sde
  val ReadBytes = "read_bytes" // Read throughput
  val ReadTime = "read_time" // Read letency
  val Reads = "reads" // Read IOPS
  val WriteBytes = "write_bytes" // Write throughput
  val WriteTime = "write_time" // Write letency
  val Writes = "writes" // Write IOPS


  // Graphite's attribute names
  val IoTimeMetricsName = "disk_io_time.io_time"
  val ReadBytesMetricsName = "disk_octets.read"
  val WriteBytesMetricsName = "disk_octets.write"
  val ReadsMetricsName = "disk_ops.read"
  val WritesMetricsName = "disk_ops.write"
  val ReadIoMetricsTime = "disk_time.read"
  val WriteIoMericsTime = "disk_time.write"
}
