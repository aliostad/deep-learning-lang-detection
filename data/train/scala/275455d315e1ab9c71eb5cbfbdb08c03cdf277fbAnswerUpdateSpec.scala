package au.id.tmm.estimatesqon.model

import java.net.URL
import java.time._

import au.id.tmm.estimatesqon.StandardProjectSpec

class AnswerUpdateSpec extends StandardProjectSpec {

  behaviour of "an update including data for an existing Answer"

  {
    lazy val existingAnswer = AnswerUpdatesForTesting.defaultAnswer()
    lazy val answerUpdate = AnswerUpdate.forExistingAnswer(existingAnswer)

    it should "have an empty value for the old answer" in {
      assert(answerUpdate.oldAnswer.isEmpty)
    }

    it should "have the existing answer as its new answer" in {
      assert(answerUpdate.newAnswer.contains(existingAnswer))
    }

    it should s"have an Answer Update type of ${AnswerUpdateType.EXISTING}" in {
      assert(answerUpdate.updateType === AnswerUpdateType.EXISTING)
    }

    it should "have the estimates of the existing answer" in {
      assert(answerUpdate.estimates === existingAnswer.question.estimates)
    }

    it should "have the qonIdentifier of the existing answer" in {
      assert(answerUpdate.qonId === existingAnswer.question.qonId)
    }
  }

  behaviour of "an update for answers to questions with the same ID for different estimates"

  it should "throw an IllegalArgumentException when constructed" in {
    val oldAnswer = AnswerUpdatesForTesting.defaultAnswer(estimates = ExampleEstimates.COMMUNICATIONS_2015_BUDGET)
    val newAnswer = AnswerUpdatesForTesting.defaultAnswer(estimates = ExampleEstimates.TREASURY_2015_BUDGET)

    intercept[IllegalArgumentException] {
      AnswerUpdate.withOldAndNewAnswers(oldAnswer, newAnswer)
    }
  }

  behaviour of "an update for answers to different questions"

  it should "throw an IllegalArgumentException when constructed" in {
    val oldAnswer = AnswerUpdatesForTesting.defaultAnswer(qonNumber = "1")
    val newAnswer = AnswerUpdatesForTesting.defaultAnswer(qonNumber = "2")

    intercept[IllegalArgumentException] {
      AnswerUpdate.withOldAndNewAnswers(oldAnswer, newAnswer)
    }
  }

  behaviour of "an update from an empty answer to an answer"

  it should s"have an update type of ${AnswerUpdateType.NEW}" in {
    val newAnswer = AnswerUpdatesForTesting.defaultAnswer()

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(None, Some(newAnswer))

    assert(answerUpdate.updateType === AnswerUpdateType.NEW)
  }

  it should "have the estimates of the new Answer" in {
    val newAnswer = AnswerUpdatesForTesting.defaultAnswer()

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(None, Some(newAnswer))

    assert(answerUpdate.estimates === newAnswer.question.estimates)
  }

  it should "have the qonID of the new Answer" in {
    val newAnswer = AnswerUpdatesForTesting.defaultAnswer()

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(None, Some(newAnswer))

    assert(answerUpdate.qonId === newAnswer.question.qonId)
  }

  behaviour of "an update from an answer to an empty answer"

  it should s"have an update type of ${AnswerUpdateType.REMOVED}" in {
    val oldAnswer = AnswerUpdatesForTesting.defaultAnswer()

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(Some(oldAnswer), None)

    assert(answerUpdate.updateType === AnswerUpdateType.REMOVED)
  }

  it should "have the estimates of the old Answer" in {
    val oldAnswer = AnswerUpdatesForTesting.defaultAnswer()

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(Some(oldAnswer), None)

    assert(answerUpdate.estimates === oldAnswer.question.estimates)
  }

  it should "have the qonID of the old Answer" in {
    val oldAnswer = AnswerUpdatesForTesting.defaultAnswer()

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(Some(oldAnswer), None)

    assert(answerUpdate.qonId === oldAnswer.question.qonId)
  }

  behaviour of "an update between two identical answers"

  it should s"have an update type of ${AnswerUpdateType.NO_CHANGE}" in {
    val oldAnswer = AnswerUpdatesForTesting.defaultAnswer()
    val newAnswer = AnswerUpdatesForTesting.defaultAnswer()

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(oldAnswer, newAnswer)

    assert(answerUpdate.updateType === AnswerUpdateType.NO_CHANGE)
  }

  behaviour of "an update from an answer without a pdf link to an answer with a pdf link"

  it should s"have an update type of ${AnswerUpdateType.ANSWERED}" in {
    val oldAnswer = AnswerUpdatesForTesting.defaultAnswer(pdfURLs = List.empty)
    val newAnswer = AnswerUpdatesForTesting.defaultAnswer(pdfURLs = List(new URL("http://example.com/link.pdf")))

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(oldAnswer, newAnswer)

    assert(answerUpdate.updateType === AnswerUpdateType.ANSWERED)
  }

  behaviour of "an update from an answer without a pdf link or a date answered value to an answer with a date " +
    "answered value but no pdf link"

  it should s"have an update type of ${AnswerUpdateType.MARKED_AS_ANSWERED}" in {
    val oldAnswer = AnswerUpdatesForTesting.defaultAnswer(pdfURLs = List.empty, datesReceived = Set.empty)
    val newAnswer = AnswerUpdatesForTesting.defaultAnswer(pdfURLs = List.empty, datesReceived = Set(LocalDate.of(2015, Month.AUGUST, 23)))

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(oldAnswer, newAnswer)

    assert(answerUpdate.updateType === AnswerUpdateType.MARKED_AS_ANSWERED)
  }

  behaviour of "an update from an unanswered answer to another unanswered answer with other details changed"

  it should s"have an answer type of ${AnswerUpdateType.DETAILS_ALTERED}" in {
    val oldAnswer = AnswerUpdatesForTesting.defaultAnswer(senator = Some("Carr"))
    val newAnswer = AnswerUpdatesForTesting.defaultAnswer(senator = Some("Arbib"))

    val answerUpdate = AnswerUpdate.withOldAndNewAnswers(oldAnswer, newAnswer)

    assert(answerUpdate.updateType === AnswerUpdateType.DETAILS_ALTERED)
  }

  behaviour of "computation of AnswerUpdates from answer lists"

  it should "correctly compute the answer updates" in {
    val oldAnswer1 = AnswerUpdatesForTesting.defaultAnswer()
    val oldAnswer2 = AnswerUpdatesForTesting.defaultAnswer(qonNumber = "2")
    val oldAnswers = Set(oldAnswer1, oldAnswer2)

    val newAnswer1 = AnswerUpdatesForTesting.defaultAnswer(pdfURLs = List(new URL("https://example.com")), datesReceived = Set(LocalDate.of(2016, Month.APRIL, 9)))
    val newAnswers = Set(newAnswer1)

    val actualUpdates = AnswerUpdate.fromSetsOfOldAndNewAnswers(oldAnswers, newAnswers)

    val expectedUpdates = Set(
      AnswerUpdate(Some(oldAnswer1), Some(newAnswer1), AnswerUpdateType.ANSWERED),
      AnswerUpdate(Some(oldAnswer2), None, AnswerUpdateType.REMOVED)
    )
  }

  it should "fail if there are any duplicate questions in the old answers" in {
    val oldAnswer1 = AnswerUpdatesForTesting.defaultAnswer()
    val oldAnswer2 = AnswerUpdatesForTesting.defaultAnswer(senator = Some("Dasha"))
    val oldAnswers = Set(oldAnswer1, oldAnswer2)

    val newAnswer1 = AnswerUpdatesForTesting.defaultAnswer()
    val newAnswers = Set(newAnswer1)

    intercept[IllegalArgumentException] {
      AnswerUpdate.fromSetsOfOldAndNewAnswers(oldAnswers, newAnswers)
    }
  }

  it should "fail if there are any duplicate questions in the new answers" in {
    val oldAnswer1 = AnswerUpdatesForTesting.defaultAnswer()
    val oldAnswers = Set(oldAnswer1)

    val newAnswer1 = AnswerUpdatesForTesting.defaultAnswer()
    val newAnswer2 = AnswerUpdatesForTesting.defaultAnswer(senator = Some("Dasha"))
    val newAnswers = Set(newAnswer1, newAnswer2)

    intercept[IllegalArgumentException] {
      AnswerUpdate.fromSetsOfOldAndNewAnswers(oldAnswers, newAnswers)
    }
  }
}
