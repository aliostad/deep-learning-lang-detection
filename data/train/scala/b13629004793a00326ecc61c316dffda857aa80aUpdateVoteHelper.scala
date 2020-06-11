package com.seanshubin.schulze.persistence

import datomic.Connection
import DatomicUtil._
import ReferenceLookup._
import com.seanshubin.schulze.persistence.datomic_util.ScalaAdaptor._

object UpdateVoteHelper {

  private case class Ranking(ranking: Long, candidate: Long, rank: Long)

  def updateVote(connection: Connection, electionName: String, voterName: String, rankingsByCandidateName: Map[String, Long]) {
    val db = connection.db()
    val election: Ref = lookupElection(db, electionName)
    val voter: Ref = lookupVoter(db, voterName)
    val candidateRows: Seq[CandidateRow] = lookupCandidates(db, election)
    val existingRankingRows: Seq[RankingRow] = lookupRankings(db, election, voter)
    val transactions: Seq[Any] = generateTransactions(
      election, voter, candidateRows, existingRankingRows, rankingsByCandidateName)
    transact(connection, transactions)
  }

  private def generateTransactions(election: Long,
                                   voter: Long,
                                   candidateRows: Seq[CandidateRow],
                                   oldRankingRows: Seq[RankingRow],
                                   newRankings: Map[String, Long]): Seq[Any] = {
    def oldRankingRowEntry(row: RankingRow) = row.candidate -> row
    val oldRankings = oldRankingRows.map(oldRankingRowEntry).toMap
    def maybeCreateTransaction(candidateRow: CandidateRow): Option[DatomicTransaction] = {
      def replaceTransaction(id: Ref, rank: Long) = Map(":db/id" -> id, ":ranking/rank" -> rank)
      def createTransaction(rank: Long) = Map(
        ":db/id" -> tempId(),
        ":ranking/candidate" -> candidateRow.candidate,
        ":ranking/election" -> election,
        ":ranking/voter" -> voter,
        ":ranking/rank" -> rank)
      def deleteTransaction(id: Ref, rank: Long) = Seq(":db/retract", id, ":ranking/rank", rank)
      val maybeOldRanking = oldRankings.get(candidateRow.candidate)
      val maybeNewRanking = newRankings.get(candidateRow.name)
      (maybeOldRanking, maybeNewRanking) match {
        case (Some(oldRanking), Some(newRank)) => Some(replaceTransaction(oldRanking.ranking, newRank))
        case (None, Some(newRank)) => Some(createTransaction(newRank))
        case (Some(oldRanking), None) => Some(deleteTransaction(oldRanking.ranking, oldRanking.rank))
        case (None, None) => None
      }
    }
    val transactions = candidateRows.flatMap(maybeCreateTransaction)
    transactions
  }
}
