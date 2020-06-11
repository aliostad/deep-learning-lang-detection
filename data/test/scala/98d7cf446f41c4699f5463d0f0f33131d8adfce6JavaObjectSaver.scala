/*
 * (c) Copyright 2016 Hewlett Packard Enterprise Development LP
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package cogx.runtime.checkpoint.javaserialization

import java.io.{ObjectOutputStream, FileOutputStream}

import cogx.platform.checkpoint.{Saveable, ObjectSaver}

/** Cog ComputeGraph saver based on Java Serialization
  *
  * @author Dick Carter
  */
class JavaObjectSaver(filename: String) extends ObjectSaver {
  val fos = new FileOutputStream(filename)
  val oos = new ObjectOutputStream(fos)

  /** Write an Int to the object store. */
  def writeInt(name: String, i32: Int) {
    oos.writeObject(name)
    oos.writeInt(i32)
  }
  /** Write an Array[Int] to the object store. */
  def writeIntArray(name: String, i32Array: Array[Int]) {
    oos.writeObject(name)
    oos.writeObject(i32Array)
  }
  /** Write an Long to the object store. */
  def writeLong(name: String, i64: Long) {
    oos.writeObject(name)
    oos.writeLong(i64)
  }
  /** Write an Array[Long] to the object store. */
  def writeLongArray(name: String, i64Array: Array[Long]) {
    oos.writeObject(name)
    oos.writeObject(i64Array)
  }
  /** Write a Float to the object store. */
  def writeFloat(name: String, f: Float) {
    oos.writeObject(name)
    oos.writeFloat(f)
  }
  /** Write an Array[Float] to the object store. */
  def writeFloatArray(name: String, fArray: Array[Float]) {
    oos.writeObject(name)
    oos.writeObject(fArray)
  }
  /** Write a Double to the object store. */
  def writeDouble(name: String, d: Double) {
    oos.writeObject(name)
    oos.writeDouble(d)
  }
  /** Write an Array[Double] to the object store. */
  def writeDoubleArray(name: String, dArray: Array[Double]) {
    oos.writeObject(name)
    oos.writeObject(dArray)
  }
  /** Write a String to the object store. */
  def writeString(name: String, s: String) {
    oos.writeObject(name)
    oos.writeObject(s)
  }
  /** Write an Array[String] to the object store. */
  def writeStringArray(name: String, sArray: Array[String]) {
    oos.writeObject(name)
    oos.writeObject(sArray)
  }
  /** Write a non-primitive "Saveable" object to the object store. */
  def writeObject(name: String, saveable: Saveable) {
    oos.writeObject(name)
    saveable.save(this)
  }
  /** Write an Array of non-primitive "Saveable" objects to the object store. */
  def writeObjectArray(name: String, saveables: Array[_ <: Saveable]) {
    oos.writeObject(name)
    // Array elements are stored singly, preceded by an Integer indicating the number of elements
    oos.writeInt(saveables.length)
    saveables.foreach(o => o.save(this))
  }
  /** Close object store, preventing further writes. */
  def close(): Unit = {
    oos.close()
    fos.close()
  }
}
