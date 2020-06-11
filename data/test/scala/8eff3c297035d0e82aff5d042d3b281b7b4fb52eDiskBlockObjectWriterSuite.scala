/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.spark.storage

import java.io.File

import org.scalatest.BeforeAndAfterEach

import org.apache.spark.{SparkConf, SparkFunSuite}
import org.apache.spark.executor.ShuffleWriteMetrics
import org.apache.spark.serializer.JavaSerializer
import org.apache.spark.util.Utils

class DiskBlockObjectWriterSuite extends SparkFunSuite with BeforeAndAfterEach {

  var tempDir: File = _

  override def beforeEach(): Unit = {
    super.beforeEach()
    tempDir = Utils.createTempDir()
  }

  override def afterEach(): Unit = {
    try {
      Utils.deleteRecursively(tempDir)
    } finally {
      super.afterEach()
    }
  }

  test("verify write metrics") {
    val file = new File(tempDir, "somefile")
    val writeMetrics = new ShuffleWriteMetrics()
    val writer = new DiskBlockObjectWriter(
      file, new JavaSerializer(new SparkConf()).newInstance(), 1024, os => os, true, writeMetrics)

    writer.write(Long.box(20), Long.box(30))
    // Record metrics update on every write
    assert(writeMetrics.recordsWritten === 1)
    // Metrics don't update on every write
    assert(writeMetrics.bytesWritten == 0)
    // After 32 writes, metrics should update
    for (i <- 0 until 32) {
      writer.flush()
      writer.write(Long.box(i), Long.box(i))
    }
    assert(writeMetrics.bytesWritten > 0)
    assert(writeMetrics.recordsWritten === 33)
    writer.commitAndClose()
    assert(file.length() == writeMetrics.bytesWritten)
  }

  test("verify write metrics on revert") {
    val file = new File(tempDir, "somefile")
    val writeMetrics = new ShuffleWriteMetrics()
    val writer = new DiskBlockObjectWriter(
      file, new JavaSerializer(new SparkConf()).newInstance(), 1024, os => os, true, writeMetrics)

    writer.write(Long.box(20), Long.box(30))
    // Record metrics update on every write
    assert(writeMetrics.recordsWritten === 1)
    // Metrics don't update on every write
    assert(writeMetrics.bytesWritten == 0)
    // After 32 writes, metrics should update
    for (i <- 0 until 32) {
      writer.flush()
      writer.write(Long.box(i), Long.box(i))
    }
    assert(writeMetrics.bytesWritten > 0)
    assert(writeMetrics.recordsWritten === 33)
    writer.revertPartialWritesAndClose()
    assert(writeMetrics.bytesWritten == 0)
    assert(writeMetrics.recordsWritten == 0)
  }

  test("Reopening a closed block writer") {
    val file = new File(tempDir, "somefile")
    val writeMetrics = new ShuffleWriteMetrics()
    val writer = new DiskBlockObjectWriter(
      file, new JavaSerializer(new SparkConf()).newInstance(), 1024, os => os, true, writeMetrics)

    writer.open()
    writer.close()
    intercept[IllegalStateException] {
      writer.open()
    }
  }

  test("calling revertPartialWritesAndClose() on a closed block writer should have no effect") {
    val file = new File(tempDir, "somefile")
    val writeMetrics = new ShuffleWriteMetrics()
    val writer = new DiskBlockObjectWriter(
      file, new JavaSerializer(new SparkConf()).newInstance(), 1024, os => os, true, writeMetrics)
    for (i <- 1 to 1000) {
      writer.write(i, i)
    }
    writer.commitAndClose()
    val bytesWritten = writeMetrics.bytesWritten
    assert(writeMetrics.recordsWritten === 1000)
    writer.revertPartialWritesAndClose()
    assert(writeMetrics.recordsWritten === 1000)
    assert(writeMetrics.bytesWritten === bytesWritten)
  }

  test("commitAndClose() should be idempotent") {
    val file = new File(tempDir, "somefile")
    val writeMetrics = new ShuffleWriteMetrics()
    val writer = new DiskBlockObjectWriter(
      file, new JavaSerializer(new SparkConf()).newInstance(), 1024, os => os, true, writeMetrics)
    for (i <- 1 to 1000) {
      writer.write(i, i)
    }
    writer.commitAndClose()
    val bytesWritten = writeMetrics.bytesWritten
    val writeTime = writeMetrics.writeTime
    assert(writeMetrics.recordsWritten === 1000)
    writer.commitAndClose()
    assert(writeMetrics.recordsWritten === 1000)
    assert(writeMetrics.bytesWritten === bytesWritten)
    assert(writeMetrics.writeTime === writeTime)
  }

  test("revertPartialWritesAndClose() should be idempotent") {
    val file = new File(tempDir, "somefile")
    val writeMetrics = new ShuffleWriteMetrics()
    val writer = new DiskBlockObjectWriter(
      file, new JavaSerializer(new SparkConf()).newInstance(), 1024, os => os, true, writeMetrics)
    for (i <- 1 to 1000) {
      writer.write(i, i)
    }
    writer.revertPartialWritesAndClose()
    val bytesWritten = writeMetrics.bytesWritten
    val writeTime = writeMetrics.writeTime
    assert(writeMetrics.recordsWritten === 0)
    writer.revertPartialWritesAndClose()
    assert(writeMetrics.recordsWritten === 0)
    assert(writeMetrics.bytesWritten === bytesWritten)
    assert(writeMetrics.writeTime === writeTime)
  }

  test("fileSegment() can only be called after commitAndClose() has been called") {
    val file = new File(tempDir, "somefile")
    val writeMetrics = new ShuffleWriteMetrics()
    val writer = new DiskBlockObjectWriter(
      file, new JavaSerializer(new SparkConf()).newInstance(), 1024, os => os, true, writeMetrics)
    for (i <- 1 to 1000) {
      writer.write(i, i)
    }
    intercept[IllegalStateException] {
      writer.fileSegment()
    }
    writer.close()
  }

  test("commitAndClose() without ever opening or writing") {
    val file = new File(tempDir, "somefile")
    val writeMetrics = new ShuffleWriteMetrics()
    val writer = new DiskBlockObjectWriter(
      file, new JavaSerializer(new SparkConf()).newInstance(), 1024, os => os, true, writeMetrics)
    writer.commitAndClose()
    assert(writer.fileSegment().length === 0)
  }
}
