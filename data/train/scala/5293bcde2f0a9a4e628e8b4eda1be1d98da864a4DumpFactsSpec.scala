package com.ambiata.ivory.operation.debug

import org.specs2._
import com.ambiata.mundane.testing.RIOMatcher._
import com.ambiata.notion.core.{TemporaryType => T}
import com.ambiata.ivory.core._
import com.ambiata.ivory.core.IvoryLocationTemporary._
import com.ambiata.ivory.core.arbitraries._

import com.ambiata.ivory.operation.extraction.Snapshots
import com.ambiata.ivory.storage.repository.RepositoryBuilder

import scalaz._, Scalaz._

class DumpFactsSpec extends Specification with ScalaCheck { def is = s2"""

We can dump to a file:
  Factsets                      $factsetsFile              ${tag("mr")}
  Snapshots                     $snapshotsFile             ${tag("mr")}
  Both                          $bothFile                  ${tag("mr")}

We can dump to stdout:
  Factsets                      $factsetsStdout
  Snapshots                     $snapshotsStdout           ${tag("mr")}
  Both                          $bothStdout                ${tag("mr")}

"""
  def factsetsFile = propNoShrink((data: FactsWithDictionary) => {
    withIvoryLocationDir(T.Hdfs) { location =>
      RepositoryBuilder.using { repository => for {
        _ <- RepositoryBuilder.createRepo(repository, data.dictionary, List(data.facts))
        _ <- DumpFacts.dumpToFile(repository, DumpFactsRequest(FactsetId.initial :: Nil, Nil, Nil, Nil), location)
        r <- IvoryLocation.readLines(location)
      } yield r }
    } must beOkLike(r =>
      (r.length, r.forall(_.endsWith(s"Factset[${FactsetId.initial.render}]")), data.facts.forall(f => r.exists(l => l.contains(f.entity) && l.contains(f.feature)))) ==== ((data.facts.length, true, true)))
  }).set(minTestsOk = 3)

  def snapshotsFile = prop((data: FactsWithDictionary) => {
    val facts = uniqueEntities(data.facts)
    withIvoryLocationDir(T.Hdfs) { location =>
      RepositoryBuilder.using { repository => for {
        _ <- RepositoryBuilder.createRepo(repository, data.dictionary, List(data.facts))
        _ <- Snapshots.takeSnapshot(repository, IvoryFlags.default, Date.maxValue)
        _ <- DumpFacts.dumpToFile(repository, DumpFactsRequest(Nil, SnapshotId.initial :: Nil, Nil, Nil), location)
        r <- IvoryLocation.readLines(location)
      } yield r }
    } must beOkLike(r => {
      (r.length, r.forall(_.endsWith(s"Snapshot[${SnapshotId.initial.render}]")), data.facts.forall(f => r.exists(l => l.contains(f.entity) && l.contains(f.feature)))) ==== ((facts.length, true, true)) })
  }).set(minTestsOk = 3)

  def bothFile = propNoShrink((data: FactsWithDictionary) => {
    val facts = uniqueEntities(data.facts)
    withIvoryLocationDir(T.Hdfs) { location =>
      RepositoryBuilder.using { repository => for {
        _ <- RepositoryBuilder.createRepo(repository, data.dictionary, List(facts))
        _ <- Snapshots.takeSnapshot(repository, IvoryFlags.default, Date.maxValue)
        _ <- DumpFacts.dumpToFile(repository, DumpFactsRequest(FactsetId.initial :: Nil, SnapshotId.initial :: Nil, Nil, Nil), location)
        r <- IvoryLocation.readLines(location)
      } yield r}
    } must beOkLike(r =>
      (r.length, r.filter(_.endsWith(s"Snapshot[${SnapshotId.initial.render}]")).size, r.filter(_.endsWith(s"Factset[${FactsetId.initial.render}]")).size) ==== ((facts.length * 2, facts.length, facts.length)))
  }).set(minTestsOk = 3)

  def factsetsStdout = prop((data: FactsWithDictionary) => {
    RepositoryBuilder.using { repository => for {
      _ <- RepositoryBuilder.createRepo(repository, data.dictionary, List(data.facts))
      r <- DumpFacts.dumpToStdout(repository, DumpFactsRequest(FactsetId.initial :: Nil, Nil, Nil, Nil))
    } yield r } must beOkValue(().right[String])
  })

  def snapshotsStdout = propNoShrink((data: FactsWithDictionary) => {
    val facts = uniqueEntities(data.facts)
    RepositoryBuilder.using { repository => for {
      _ <- RepositoryBuilder.createRepo(repository, data.dictionary, List(data.facts))
      _ <- Snapshots.takeSnapshot(repository, IvoryFlags.default, Date.maxValue)
      r <- DumpFacts.dumpToStdout(repository, DumpFactsRequest(Nil, SnapshotId.initial :: Nil, Nil, Nil))
    } yield r } must beOkValue(().right[String])
  }).set(minTestsOk = 3)

  def bothStdout = propNoShrink((data: FactsWithDictionary) => {
    val facts = uniqueEntities(data.facts)
    RepositoryBuilder.using { repository => for {
      _ <- RepositoryBuilder.createRepo(repository, data.dictionary, List(facts))
      _ <- Snapshots.takeSnapshot(repository, IvoryFlags.default, Date.maxValue)
      r <- DumpFacts.dumpToStdout(repository, DumpFactsRequest(FactsetId.initial :: Nil, SnapshotId.initial :: Nil, Nil, Nil))
    } yield r} must beOkValue(().right[String])
  }).set(minTestsOk = 3)

  // We're not here to test the snapshot logic, which involves complex windowing and priority
  def uniqueEntities(facts: List[Fact]): List[Fact] =
    facts.groupBy(_.entity).values.toList.flatMap(_.headOption)
}
