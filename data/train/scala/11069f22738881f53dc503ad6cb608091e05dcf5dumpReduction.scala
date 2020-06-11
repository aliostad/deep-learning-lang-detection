package com.ambiata.ivory.cli.debug

import com.ambiata.ivory.cli._
import com.ambiata.ivory.core._
import com.ambiata.ivory.storage.control._
import com.ambiata.ivory.operation.extraction.squash.SquashDumpJob
import com.ambiata.mundane.control._

import pirate._, Pirate._

import scalaz._, Scalaz._

object dumpReduction extends IvoryApp {

  val cmd = Command(
    "debug-dump-reduction", Some("""
    |Dump facts related to the specified features/entities for each stage of the squash as text:
    |  ENTITY|NAMESPACE|ATTRIBUTE|DATETIME|VALUE-IN|VALUE-OUT
    |""".stripMargin),

    ( flag[String](both('e', "entity"), description("A set of entities to debug")).some
  |@| flag[String](both('f', "feature"), description("A set of virtual features to debug, or none to include them all")).many
  |@| flag[String](both('s', "snapshot"), description("The snapshot ID to use as input to the squash"))
  |@| flag[String](both('o', "output"), description("The output location of the dump"))
  |@| IvoryCmd.repository

    )((entities, features, snapshot, output, loadRepo) => IvoryRunner(conf => loadRepo(conf).flatMap(repo =>

    IvoryT.fromRIO(for {
      sid <- RIO.fromOption[SnapshotId](SnapshotId.parse(snapshot), s"Invalid snapshot ${snapshot}")
      out <- RIO.fromDisjunctionString[IvoryLocation](IvoryLocation.parseUri(output, conf))
      fs  <- RIO.fromDisjunctionString[List[FeatureId]](features.traverseU(FeatureId.parse))
      _   <- SquashDumpJob.dump(repo, sid, out, fs, entities)
    } yield Nil)
  ))))
}
