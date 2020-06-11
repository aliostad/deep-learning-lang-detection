package au.id.tmm.estimatesqon.model

import au.id.tmm.estimatesqon.model.AnswerUpdateType.AnswerUpdateType

case class AnswerUpdate (oldAnswer: Option[Answer],
                         newAnswer: Option[Answer],
                         updateType: AnswerUpdateType) {

  protected def this(oldAnswer: Option[Answer], newAnswer: Option[Answer]) =
    this(oldAnswer, newAnswer, AnswerUpdate.typeOfUpdate(oldAnswer, newAnswer))

  AnswerUpdate.throwIfDifferentQuestion(oldAnswer, newAnswer)

  val estimates: Estimates = oldAnswer.getOrElse(newAnswer.get).question.estimates

  val qonId: String = oldAnswer.getOrElse(newAnswer.get).question.qonId
}

object AnswerUpdate {

  def fromSetsOfOldAndNewAnswers(oldAnswers: Set[Answer], newAnswers: Set[Answer]): Set[AnswerUpdate] = {
    val oldAnswersByQuestion = oldAnswers.groupBy(_.question)
    val newAnswersByQuestion = newAnswers.groupBy(_.question)

    ensureNoDuplicateQuestions(oldAnswersByQuestion)
    ensureNoDuplicateQuestions(newAnswersByQuestion)

    val allQonIds = oldAnswersByQuestion.keySet ++ newAnswersByQuestion.keySet

    allQonIds.map(qonId => {
      val oldAnswer = oldAnswersByQuestion.get(qonId).flatMap(_.headOption)
      val newAnswer = newAnswersByQuestion.get(qonId).flatMap(_.headOption)

      withOldAndNewAnswers(oldAnswer, newAnswer)
    })
  }

  private def ensureNoDuplicateQuestions(answersByQuestions: Map[Question, Set[Answer]]) = {
    val containsDuplicateQuestions = answersByQuestions.values.exists(_.size > 1)

    if (containsDuplicateQuestions) {
      throw new IllegalArgumentException("Cannot determine updates if there are duplicate questions")
    }
  }

  def withOldAndNewAnswers(oldAnswer: Answer, newAnswer: Answer): AnswerUpdate =
    withOldAndNewAnswers(Some(oldAnswer), Some(newAnswer))

  def withOldAndNewAnswers(oldAnswer: Option[Answer], newAnswer: Option[Answer]): AnswerUpdate =
    new AnswerUpdate(oldAnswer, newAnswer)

  /**
   * Used to register an AnswerUpdate the first time, where we have no data about previous answers. This is distinct
   * from the case where the answer is new.
   */
  def forExistingAnswer(existingAnswer: Answer) =
    new AnswerUpdate(None, Some(existingAnswer), AnswerUpdateType.EXISTING)

  private def typeOfUpdate(oldAnswer: Option[Answer], newAnswer: Option[Answer]): AnswerUpdateType = {
    if (oldAnswer.isDefined && newAnswer.isEmpty) {
      AnswerUpdateType.REMOVED

    } else if (oldAnswer.isEmpty && newAnswer.isDefined) {
      AnswerUpdateType.NEW

    } else if (oldAnswer.get.pdfURLs.isEmpty && newAnswer.get.pdfURLs.nonEmpty) {
      AnswerUpdateType.ANSWERED

    } else if (oldAnswer.get.latestDateReceived.isEmpty && newAnswer.get.latestDateReceived.nonEmpty) {
      AnswerUpdateType.MARKED_AS_ANSWERED

    } else if (oldAnswer.get.hasDifferentAnswerDetailsTo(newAnswer.get)) {
      AnswerUpdateType.DETAILS_ALTERED

    } else {
      AnswerUpdateType.NO_CHANGE

    }
  }

  private def throwIfDifferentQuestion(oldAnswer: Option[Answer], newAnswer: Option[Answer]) = {
    if (oldAnswer.isDefined &&
      newAnswer.isDefined &&
      oldAnswer.get.question != newAnswer.get.question) {
      throw new IllegalArgumentException("The answers are to two different questions")
    }
  }
}