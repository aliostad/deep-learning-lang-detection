package concordance.sentences

class SentencesFinder {

  def apply(text: Seq[Word]): Seq[Seq[Word]] = {
    val initialAccumulator: (Option[Word], Seq[Seq[Word]], Seq[Word]) = (None, Seq(), Seq())
    val (_, sentences, lastSentence) =
      text.foldLeft(initialAccumulator)({
        case ((previousWord, oldSentences, currentSentence), word) =>
          if (isSentenceBreak(previousWord, word)) {
            (Some(word), oldSentences :+ currentSentence, Seq(word))
          } else {
            (Some(word), oldSentences, currentSentence :+ word)
          }

      }
    )
    sentences :+ lastSentence
  }

  private def isSentenceBreak(previousWord: Option[Word], word: Word) = {
    val possibleSentenceEnd = previousWord.exists(_.isPossibleSentenceEnd)
    val possibleSentenceStart = word.isPossibleSentenceStart
    possibleSentenceStart && possibleSentenceEnd
  }
}
