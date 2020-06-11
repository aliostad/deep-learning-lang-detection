import java.io.File
import collection.JavaConversions._
import scala.sys.process._
import scala.concurrent._
import scala.concurrent.duration._
import tasks._
import tasks.queue.NodeLocalCache
import tasks.util.TempFile
import java.io._

import fileutils._
import stringsplit._

import IOHelpers._
import MathHelpers._
import Model._

import akka.stream.ActorMaterializer

case class Feature2CPSecondInput(featureContext: JsDump[StructuralContext.T1],
                                 cppdb: JsDump[SharedTypes.PdbUniGencodeRow])

object Feature2CPSecond {

  type MappedFeatures =
    (FeatureKey, ChrPos, PdbChain, PdbResidueNumberUnresolved, Seq[UniId])

  val task =
    AsyncTask[Feature2CPSecondInput, JsDump[MappedFeatures]](
      "feature2cpsecond-2",
      2) {

      case Feature2CPSecondInput(
          featureContextJsDump,
          cppdbJsDump
          ) =>
        implicit ctx =>
          log.info("Start feature2cpsecond")
          featureContextJsDump.sf.file.flatMap { featureContextLocalFile =>
            cppdbJsDump.sf.file.flatMap { cppdb =>
              val map: collection.mutable.Map[String, List[String]] =
                cppdbJsDump.iterator(cppdb) { iterator =>
                  val mmap =
                    scala.collection.mutable.AnyRefMap[String, List[String]]()
                  iterator.foreach { row =>
                    val cp: ChrPos = row._9
                    val pdbId: PdbId = row._1
                    val pdbChain: PdbChain = row._2
                    val pdbres: PdbResidueNumberUnresolved = row._3
                    val k = pdbId.s + "_" + pdbChain.s + "_" + pdbres.s

                    mmap.get(k) match {
                      case None => mmap.update(k, List(cp.s))
                      case Some(l) => mmap.update(k, cp.s :: l)
                    }
                  }
                  mmap
                }
              log.info("PDB -> cp map read")
              featureContextJsDump.iterator(featureContextLocalFile) {
                featureIterator =>
                  val mappedResidues: Iterator[MappedFeatures] =
                    featureIterator.flatMap {

                      case (featureKey, pdbResidues, uniIds) =>
                        pdbResidues.iterator.flatMap {
                          case (PdbChain(pdbChain),
                                PdbResidueNumberUnresolved(pdbResidue)) =>
                            map
                              .get(featureKey.pdbId.s + "_" + pdbChain + "_" + pdbResidue)
                              .toList
                              .iterator
                              .flatMap(_.map { chrpos =>
                                (featureKey,
                                 ChrPos(chrpos),
                                 PdbChain(pdbChain),
                                 PdbResidueNumberUnresolved(pdbResidue),
                                 uniIds)
                              })

                        }

                    }
                  JsDump.fromIterator(
                    mappedResidues,
                    featureContextJsDump.sf.name + "." + cppdbJsDump.sf.name)
              }

            }
          }
    }

}
