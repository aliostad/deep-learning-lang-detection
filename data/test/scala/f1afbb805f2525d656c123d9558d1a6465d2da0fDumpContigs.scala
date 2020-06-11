package bio.cmdlets

import scala.io.Source
import java.io.File
import bio.Color
import bio.velvet.ReadGraph.readGraph
import bio.io.Fasta
import bio.BioSeq
import bio.db.SeqDB
import java.io.PrintStream
import bio.velvet._

/*
 * Display in text the contig alignments
 * 
 */
class DumpContigs extends VelvetReader with Cmdlet {
  def dumpContig(out: PrintStream, nr: NR, contig: BioSeq, seqs: SeqDB, colors: SeqDB) {
    val colorSeq = Color.de2color(contig.text)
    if (nr.nodeId < 0) {
      out.println(" " + colorSeq.reverse)
    } else {
      out.println(" " + colorSeq)
    }

    for (read <- nr.reads.sortBy(_.offsetFromStart)) {
      seqs.find(read.readId) match {
        case Some(idxseq) => {
          val seqName = idxseq.seq.name.split(Array(' ', '\t'))(0)
          if (read.offsetFromStart >= 0) {
            colors.find(seqName) match {
              case Some(idxColor) => out.println((" " * (read.offsetFromStart)) + Color.decodeFirst(idxColor.seq.text).drop(read.startCoord))
              case None => out.println((" " * (1 + read.offsetFromStart)) + idxseq.seq.text.drop(read.startCoord))
            }
          }
        }
        case _ => throw new Exception("Read %d not found".format(read.readId))
      }
    }
  }

  def dumpContigs(things: Iterator[Thing],
    seqs: SeqDB,
    contigs: SeqDB,
    colors: SeqDB,
    output: File) = {

    nrWithContigWalker(things, contigs) { (nr, seq) =>
      val out = new PrintStream(
        new File(output.getAbsolutePath + "/" +
          "node%d.txt".format(nr.nodeId)))

      println("Processing Node %d".format(nr.nodeId))
      dumpContig(out, nr, seq, seqs, colors)

      out.close
    }
  }

  def dumpContigs(velvetDir: String, csfastaFile: String, outputDir: String) {

    val output = getOutput(outputDir);

    val (header, things, contigsdb, seqdb, colordb) = readInputFiles(velvetDir, csfastaFile)

    dumpContigs(things, seqdb, contigsdb, colordb, output)
    
    seqdb.close
    contigsdb.close
    colordb.close
  }

  def run(args: Array[String]) {
    if (args.length >= 3) {
    	dumpContigs(args(0),args(1),args(2))
    } else {
      println("Missing args!!!")
      println("Use: dumpContigs velvetDir csfastaFile outputDir")
    }
  }
}

