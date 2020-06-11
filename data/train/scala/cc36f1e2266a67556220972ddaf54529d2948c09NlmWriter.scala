package org.navmo.osm2nlm

import java.io.File
import java.io.OutputStream
import java.io.DataOutputStream
import java.io.FileOutputStream
import java.util.zip.GZIPOutputStream
import org.apache.commons.compress.compressors.bzip2.BZip2CompressorOutputStream

class NlmWriter(nlmData: NlmData, outputDir: String) {

  def withDataStream(filename: String)(writeTo: DataOutputStream => Unit) = {
    val extension = filename.substring(filename.lastIndexOf("."))
    val compress: OutputStream => OutputStream = extension match {
      case ".gz"  => s => new GZIPOutputStream(s)
      case ".bz2" => s => new BZip2CompressorOutputStream(s)
      case _      => s => s
    }
    val s = new DataOutputStream(compress(new FileOutputStream(new File(outputDir, filename))))
    try { writeTo(s) } 
    finally { if (s != null) s.close() }
  }

  class NlmBinaryFormat {

    def write() {
      withDataStream("metadata.bin.gz") {writeMetadata}
      withDataStream("place.bin.gz") {writePlaces}
      withDataStream("junction.bin.gz") {writeJunctions}
      withDataStream("attached_section.bin.gz") {writeAttachedSections}
      withDataStream("section.bin.gz") {writeSections}
    }

    def writeMetadata(s: DataOutputStream) {
      def writeEntry (key: String, value: String) {
        s.writeUTF(key);
        s.writeUTF(value)
      }
      val m = nlmData.metadata

      s.writeInt(2) // version
      s.writeInt(6) // number of entries 

      writeEntry("CountryCode", m.countryCode)
      writeEntry("MapName", m.mapName)
      writeEntry("CoordinateMapping", m.coordinateMapping)
      writeEntry("CoordinateSystemId", m.coordinateSystemId)
      writeEntry("BuildVersion", m.buildVersion)
      writeEntry("DataVersion", m.dataVersion)
    }

    def writePlaces(s: DataOutputStream) {
      val size = nlmData.places.size
      s.writeInt(1)        // file format version
      s.writeInt(0)        // min Id
      s.writeInt(size - 1) // max Id
      s.writeInt(size)     // number of records
 
      nlmData.places.foreach { p =>
        s.writeInt(p.id)
        s.writeUTF(p.name)
        s.writeByte(p.size)
        s.writeFloat(p.x)
        s.writeFloat(p.y)
      }
    }

    def writeJunctions(s: DataOutputStream) {
      s.writeInt(1)
      s.writeInt(nlmData.junctions.head.id)
      s.writeInt(nlmData.junctions.last.id)
      s.writeInt(nlmData.junctions.length)
      s.writeInt(0) // TODO: include some sensible fields

      nlmData.junctions.foreach { j =>
        try {
          s.writeInt(j.id)
          s.writeFloat(j.x)
          s.writeFloat(j.y)
          s.writeInt(0) // TODO: attributes
          s.writeInt(j.attachedSections.size)
        }
        catch {
          case e: Exception => println(e.toString())
        }
      }
    }

    def writeAttachedSections(s: DataOutputStream) {
      s.writeInt(1)
      s.writeInt(nlmData.junctions.map(_.attachedSections.size).sum)

      nlmData.junctions.foreach { j => 
        s.writeInt(j.id)
        j.attachedSections.zipWithIndex.foreach { case(sectionId, index) =>
           s.writeByte(index)
           s.writeInt(sectionId)
        }
      }
    }

    def writeSections(s: DataOutputStream) {
      s.writeInt(1)
    }
  }

  class NlmTextFormat {
    def write() {
      withDataStream("metadata.txt.bz2") {writeMetadata}
    }

    def writeMetadata(s: DataOutputStream) {
      s.writeUTF("CountryCode," + nlmData.metadata.countryCode + "\n")  // This should be CP1252, but writing text as UTF8 works as long as it is ASCII.
      s.writeUTF("MapName," + nlmData.metadata.mapName + "\n")
      s.writeUTF("CoordinateMapping," + nlmData.metadata.coordinateMapping + "\n")
      s.writeUTF("CoordinateSystemId" + nlmData.metadata.coordinateSystemId + "\n")
      s.writeUTF("BuildVersion" + nlmData.metadata.buildVersion + "\n")
      s.writeUTF("DataVersion" + nlmData.metadata.dataVersion + "\n")
    }
  }

  def cleanDir(dir: String) {
    val f = new File(dir)
    if (!f.exists()) f.mkdirs()
  }

  def write() {
    cleanDir(outputDir)
    new NlmBinaryFormat().write()
    new NlmTextFormat().write()
  }
}